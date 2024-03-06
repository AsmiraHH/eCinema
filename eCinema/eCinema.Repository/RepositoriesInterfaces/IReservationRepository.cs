using eCinema.Core.Entities;
using eCinema.Core.SearchObjects;

namespace eCinema.Repository.RepositoriesInterfaces
{
    public interface IReservationRepository : IBaseRepository<Reservation, int, BaseSearchObject>
    {
        Task<IEnumerable<Reservation>> GetByUserID(int userID);
    }
}
