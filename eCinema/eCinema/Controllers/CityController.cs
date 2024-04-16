using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;

namespace eCinema.Controllers
{
    public class CityController : BaseController<CityDTO, CityUpsertDTO, CitySearchObject, ICityService>
    {
        public CityController(ICityService service, ILogger<CityController> logger) : base(service, logger) { }
    }
}
