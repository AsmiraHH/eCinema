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
    public class ReservationSeatService : BaseService<ReservationSeat, ReservationSeatDTO, ReservationSeatUpsertDTO, BaseSearchObject, IReservationSeatRepository>, IReservationSeatService
    {
        public ReservationSeatService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<ReservationSeatUpsertDTO> validator) : base(mapper, unitOfWork, validator)
        {

        }
        public async Task<List<SeatDTO>?> GetByShowIdAsync(int showId)
        {
            var entities = await CurrentRepository.GetByShowIdAsync(showId);
            return Mapper.Map<List<SeatDTO>>(entities);
        }
    }
}
