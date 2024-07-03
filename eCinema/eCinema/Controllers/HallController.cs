using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;

namespace eCinema.Controllers
{
    [Authorize(Roles = "Administrator")]
    public class HallController : BaseController<HallDTO, HallUpsertDTO, HallSearchObject, IHallService>
    {
        public HallController(IHallService service, ILogger<HallController> logger) : base(service, logger) { }
    }
}
