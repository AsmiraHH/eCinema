using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;

namespace eCinema.Controllers
{
    public class SeatController : BaseController<SeatDTO, SeatUpsertDTO, BaseSearchObject, ISeatService>
    {
        public SeatController(ISeatService service, ILogger<SeatController> logger) : base(service, logger) { }
    }
}
