using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;

namespace eCinema.Service.ServiceInterfaces
{
    public interface IReservationSeatService : IBaseService<int, ReservationSeatDTO, ReservationSeatUpsertDTO, BaseSearchObject>
    {
        Task<List<SeatDTO>?> GetByShowIdAsync(int showId);
    }
}
