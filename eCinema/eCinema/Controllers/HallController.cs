using eCinema.Core.DTOs;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    public class HallController : BaseController<HallDTO, HallUpsertDTO, IHallService>
    {
        public HallController(IHallService service) : base(service) { }
    }
}
