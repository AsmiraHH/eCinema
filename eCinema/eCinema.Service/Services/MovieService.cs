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

            await CurrentRepository.AddAsync(entity);
            await UnitOfWork.SaveChangesAsync();
            return Mapper.Map<MovieDTO>(entity);
        }
    }
}
