using eCinema.Core.DTOs;
using eCinema.Core.Helpers;
using eCinema.Core.SearchObjects;

namespace eCinema.Service.ServiceInterfaces
{
    public interface IReservationService : IBaseService<int, ReservationDTO, ReservationUpsertDTO, ReservationSearchObject>
    {
        Task<IEnumerable<ReservationDTO>> GetByUserID(int userID);
        Task<ReportModel> GetForReportAsync(ReportDTO dto);
    }
}
