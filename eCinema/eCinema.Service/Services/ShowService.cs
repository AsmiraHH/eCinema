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
        private IReservationService _reservationService;
        public ShowService(IMapper mapper, IReservationService reservationService, IUnitOfWork unitOfWork, IValidator<ShowUpsertDTO> validator) : base(mapper, unitOfWork, validator)
        {
            _reservationService = reservationService;
        }
       
        public async Task<List<ShowDTO>?> GetLastAddedAsync(int cinemaId)
        {
            var entities = await CurrentRepository.GetLastAddedAsync(cinemaId);
            return Mapper.Map<List<ShowDTO>>(entities);
        }
        public async Task<List<ShowDTO>?> GetMostWatchedAsync(int cinemaId)
        {
            var entities = await CurrentRepository.GetMostWatchedAsync(cinemaId);
            return Mapper.Map<List<ShowDTO>>(entities);
        }
        public async Task<List<ShowDTO>?> GetRecommendedAsync(int cinemaId, int userId)
        {
            var mostFrequentGenre = await UnitOfWork.ReservationRepository.GetMostFrequentGenreAsync(userId, cinemaId);

            List<Show>? entities;

            if (mostFrequentGenre != -1)
                entities = await CurrentRepository.GetRecommendedAsync(cinemaId, mostFrequentGenre);
            else
                entities = await CurrentRepository.GetMostWatchedAsync(cinemaId);

            return Mapper.Map<List<ShowDTO>>(entities);
        }
    }
}
