using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    [Authorize(Roles = "Administrator")]
    public class CityController : BaseController<CityDTO, CityUpsertDTO, CitySearchObject, ICityService>
    {
        public CityController(ICityService service, ILogger<CityController> logger) : base(service, logger) { }
    }
}
