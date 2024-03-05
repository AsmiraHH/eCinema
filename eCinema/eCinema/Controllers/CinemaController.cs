using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;

namespace eCinema.Controllers
{
    public class CinemaController : BaseController<CinemaDTO, CinemaUpsertDTO, BaseSearchObject, ICinemaService>
    {
        public CinemaController(ICinemaService service, ILogger<CinemaController> logger) : base(service, logger) { }
    }
}
