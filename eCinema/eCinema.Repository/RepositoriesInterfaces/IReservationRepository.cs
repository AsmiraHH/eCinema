using eCinema.Core.DTOs;
using eCinema.Core.Entities;
using eCinema.Core.SearchObjects;

namespace eCinema.Repository.RepositoriesInterfaces
{
    public interface IReservationRepository : IBaseRepository<Reservation, int, ReservationSearchObject>
    {
        Task<IEnumerable<Reservation>> GetByUserID(int userID);
        Task<List<Reservation>> GetForReportAsync(ReportDTO dto);
        Task DeleteByShowIdsAsync(List<int> ids);
        Task<int> GetMostFrequentGenreAsync(int userID, int cinemaID);
    }
}
