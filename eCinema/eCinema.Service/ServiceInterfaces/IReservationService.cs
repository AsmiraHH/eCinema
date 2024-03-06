using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;

namespace eCinema.Service.ServiceInterfaces
{
    public interface IReservationService : IBaseService<int, ReservationDTO, ReservationUpsertDTO, BaseSearchObject>
    {
        Task<IEnumerable<ReservationDTO>> GetByUserID(int userID);
    }
}
