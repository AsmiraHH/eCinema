using AutoMapper;
using eCinema.Core.DTOs;
using eCinema.Core.Entities;
using eCinema.Core.SearchObjects;
using eCinema.Repository.RepositoriesInterfaces;
using eCinema.Repository.UnitOfWork;
using eCinema.Service.ServiceInterfaces;
using FluentValidation;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;

namespace eCinema.Service.Services
{
    public class MovieService : BaseService<Movie, MovieDTO, MovieUpsertDTO, MovieSearchObject, IMovieRepository>, IMovieService
    {
        static MLContext mlContext = null;
        static object isLocked = new object();
        static ITransformer model = null;

        public MovieService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<MovieUpsertDTO> validator) : base(mapper, unitOfWork, validator)
        {
        }
        public override async Task<MovieDTO> AddAsync(MovieUpsertDTO dto)
        {
            await ValidateAsync(dto);

            var entity = Mapper.Map<Movie>(dto);
            if (!string.IsNullOrEmpty(dto?.PhotoBase64))
                entity.Photo = Convert.FromBase64String(dto.PhotoBase64);

            if (dto!.GenreIDs.Any())
            {
                entity.Genres = new List<MovieGenre>();
                foreach (var genre in dto.GenreIDs)
                {
                    entity.Genres.Add(new MovieGenre()
                    {
                        GenreId = genre,
                        Movie = entity
                    });
                }
            }

            if (dto!.ActorIDs.Any())
            {
                entity.Actors = new List<MovieActor>();
                foreach (var actor in dto.ActorIDs)
                {
                    entity.Actors.Add(new MovieActor()
                    {
                        ActorId = actor,
                        Movie = entity
                    });
                }
            }

            await CurrentRepository.AddAsync(entity);
            await UnitOfWork.SaveChangesAsync();
            return Mapper.Map<MovieDTO>(entity);
        }
        public override async Task<MovieDTO> UpdateAsync(MovieUpsertDTO dto)
        {
            var movie = await CurrentRepository.GetByIdAsync(dto.ID);
            if (movie == null)
                throw new Exception();

            await ValidateAsync(dto);

            var entity = Mapper.Map<Movie>(dto);

            if (!string.IsNullOrEmpty(dto?.PhotoBase64))
                entity.Photo = Convert.FromBase64String(dto.PhotoBase64);

            if (dto!.GenreIDs.Any() && !movie.Genres.Select(x => x.GenreId).SequenceEqual(dto.GenreIDs))
            {
                foreach (var genre in movie.Genres)
                {
                    UnitOfWork.MovieGenreRepository.DetachEntity(genre);
                    UnitOfWork.MovieGenreRepository.Delete(genre);
                }

                entity.Genres = new List<MovieGenre>();
                foreach (var genre in dto.GenreIDs)
                {
                    entity.Genres.Add(new MovieGenre()
                    {
                        GenreId = genre,
                        Movie = entity
                    });
                }
            }

            if (dto!.ActorIDs.Any() && !movie.Actors.Select(x => x.ActorId).SequenceEqual(dto.ActorIDs))
            {
                foreach (var actor in movie.Actors)
                {
                    UnitOfWork.MovieActorRepository.DetachEntity(actor);
                    UnitOfWork.MovieActorRepository.Delete(actor);
                }

                entity.Actors = new List<MovieActor>();
                foreach (var actor in dto.ActorIDs)
                {
                    entity.Actors.Add(new MovieActor()
                    {
                        ActorId = actor,
                        Movie = entity
                    });
                }
            }

            CurrentRepository.Update(entity);
            await UnitOfWork.SaveChangesAsync();
            return Mapper.Map<MovieDTO>(entity);
        }
        public async Task<List<MovieDTO>?> GetLastAddedAsync(int cinemaId)
        {
            var entities = await CurrentRepository.GetLastAddedAsync(cinemaId);
            return Mapper.Map<List<MovieDTO>>(entities);
        }
        public async Task<List<MovieDTO>?> GetMostWatchedAsync(int cinemaId)
        {
            var entities = await CurrentRepository.GetMostWatchedAsync(cinemaId);
            return Mapper.Map<List<MovieDTO>>(entities);
        }

        public List<MovieDTO> GetRecommended(int cinemaId, int userId)
        {
            lock (isLocked)
            {
                if (mlContext == null)
                {
                    mlContext = new MLContext();

                    var reservations = UnitOfWork.ReservationRepository.GetAllAsync();

                    if (reservations.Result?.Count == 0)
                    {
                        return new List<MovieDTO>();
                    }

                    var data = new List<UserItemEntry>();

                    foreach (var x in reservations.Result!)
                    {
                        data.Add(new UserItemEntry()
                        {
                            UserId = (uint)x.UserId,
                            ItemId = (uint)x.Show.MovieId,
                            Rating = 1
                        });
                    }

                    var trainData = mlContext.Data.LoadFromEnumerable(data);

                    MatrixFactorizationTrainer.Options options = new MatrixFactorizationTrainer.Options();
                    options.MatrixColumnIndexColumnName = nameof(UserItemEntry.UserId);
                    options.MatrixRowIndexColumnName = nameof(UserItemEntry.ItemId);
                    options.LabelColumnName = "Rating";
                    options.LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass;
                    options.Alpha = 0.01;
                    options.Lambda = 0.025;
                    options.NumberOfIterations = 100;
                    options.C = 0.00001;

                    var est = mlContext.Recommendation().Trainers.MatrixFactorization(options);

                    model = est.Fit(trainData);
                }
            }

            var movies = CurrentRepository.GetForRecommendedAsync(cinemaId, userId);

            var predictionResult = new List<Tuple<Movie, float>>();

            foreach (var movie in movies.Result!)
            {
                var predictionEngine = mlContext.Model.CreatePredictionEngine<UserItemEntry, UserBasedPrediction>(model);
                var prediction = predictionEngine.Predict(
                    new UserItemEntry()
                    {
                        UserId = (uint)userId,
                        ItemId = (uint)movie.ID
                    });

                predictionResult.Add(new Tuple<Movie, float>(movie, prediction.Score));
            }

            var finalResult = predictionResult.OrderByDescending(x => x.Item2).Select(y => y.Item1).Take(3).ToList();

            return Mapper.Map<List<MovieDTO>>(finalResult);
        }

        public class UserItemEntry
        {
            [KeyType(count: 10)]
            public uint UserId { get; set; }

            [KeyType(count: 10)]
            public uint ItemId { get; set; }

            public float Rating { get; set; }
        }

        public class UserBasedPrediction
        {
            public float Score { get; set; }
        }
    }
}
