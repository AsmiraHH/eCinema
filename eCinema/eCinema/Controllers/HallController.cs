using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;

namespace eCinema.Controllers
{
    public class HallController : BaseController<HallDTO, HallUpsertDTO, HallSearchObject, IHallService>
    {
        public HallController(IHallService service, ILogger<HallController> logger) : base(service, logger) { }
    }
}
