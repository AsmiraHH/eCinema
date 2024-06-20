using AutoMapper;
using eCinema.Core.DTOs;
using eCinema.Core.Entities;
using eCinema.Core.SearchObjects;
using eCinema.Repository.RepositoriesInterfaces;
using eCinema.Repository.UnitOfWork;
using eCinema.Service.ServiceInterfaces;
using FluentValidation;

namespace eCinema.Service.Services
{
    public class MovieService : BaseService<Movie, MovieDTO, MovieUpsertDTO, MovieSearchObject, IMovieRepository>, IMovieService
    {
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
    }
}
