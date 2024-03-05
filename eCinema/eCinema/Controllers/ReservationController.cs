using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;

namespace eCinema.Controllers
{
    public class ReservationController : BaseController<ReservationDTO, ReservationUpsertDTO, BaseSearchObject, IReservationService>
    {
        public ReservationController(IReservationService service, ILogger<ReservationController> logger) : base(service, logger) { }
    }
}
