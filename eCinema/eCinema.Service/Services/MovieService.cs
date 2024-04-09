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
        private IMovieGenreService _movieGenreService;
        public MovieService(IMapper mapper, IMovieGenreService movieGenreService, IUnitOfWork unitOfWork, IValidator<MovieUpsertDTO> validator) : base(mapper, unitOfWork, validator)
        {
            _movieGenreService = movieGenreService;
        }
        public override async Task<MovieDTO> AddAsync(MovieUpsertDTO dto)
        {
            await ValidateAsync(dto);

            var entity = Mapper.Map<Movie>(dto);
            if (!string.IsNullOrEmpty(dto?.PhotoBase64))
                entity.Photo = Convert.FromBase64String(dto.PhotoBase64);
            if (dto.GenreIDs.Any())
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

            await CurrentRepository.AddAsync(entity);
            await UnitOfWork.SaveChangesAsync();
            return Mapper.Map<MovieDTO>(entity);
        }
        public override async Task<MovieDTO> UpdateAsync(MovieUpsertDTO dto)
        {
            await ValidateAsync(dto);

            var entity = Mapper.Map<Movie>(dto);
            if (!string.IsNullOrEmpty(dto?.PhotoBase64))
                entity.Photo = Convert.FromBase64String(dto.PhotoBase64);

            if (dto.GenreIDs.Any())
            {
                await _movieGenreService.DeleteByMovieIdAsync(entity.ID);
                
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

            CurrentRepository.Update(entity);
            await UnitOfWork.SaveChangesAsync();
            return Mapper.Map<MovieDTO>(entity);
        }
    }
}
