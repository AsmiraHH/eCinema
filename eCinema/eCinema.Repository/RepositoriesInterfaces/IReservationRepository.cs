using eCinema.Core.Entities;
using eCinema.Core.SearchObjects;

namespace eCinema.Repository.RepositoriesInterfaces
{
    public interface IReservationRepository : IBaseRepository<Reservation, int, ReservationSearchObject>
    {
        Task<IEnumerable<Reservation>> GetByUserID(int userID);
        Task DeleteByShowIdsAsync(List<int> ids);
    }
}
