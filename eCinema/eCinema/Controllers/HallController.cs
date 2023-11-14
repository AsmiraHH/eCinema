using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    public class HallController : BaseController<HallDTO, HallUpsertDTO, BaseSearchObject, IHallService>
    {
        public HallController(IHallService service) : base(service) { }
    }
}
