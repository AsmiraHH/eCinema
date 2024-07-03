using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    [Authorize(Roles = "Administrator")]
    public class CountryController : BaseController<CountryDTO, CountryUpsertDTO, CountrySearchObject, ICountryService>
    {
        public CountryController(ICountryService service, ILogger<CountryController> logger) : base(service, logger) { }
    }
}
