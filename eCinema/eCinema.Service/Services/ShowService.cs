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
    public class ShowService : BaseService<Show, ShowDTO, ShowUpsertDTO, ShowSearchObject, IShowRepository>, IShowService
    {
        public ShowService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<ShowUpsertDTO> validator) : base(mapper, unitOfWork, validator)
        {
        }
       
        public async Task<List<ShowDTO>?> GetByMovieIdAsync(int movieId,int cinemaId, bool isDistinct)
        {
            var entities = await CurrentRepository.GetByMovieIdAsync(movieId, cinemaId, isDistinct);
            return Mapper.Map<List<ShowDTO>>(entities);
        }
    }
}
