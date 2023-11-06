using eCinema.Core.DTOs;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    public class CityController : BaseController<CityDTO, CityUpsertDTO, ICityService>
    {
        public CityController(ICityService service) : base(service) { }
    }
}
