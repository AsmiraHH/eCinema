using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    public class CityController : BaseController<CityDTO, CityUpsertDTO, BaseSearchObject, ICityService>
    {
        public CityController(ICityService service) : base(service) { }
    }
}
