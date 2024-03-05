using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;

namespace eCinema.Controllers
{
    public class CountryController : BaseController<CountryDTO, CountryUpsertDTO, BaseSearchObject, ICountryService>
    {
        public CountryController(ICountryService service, ILogger<CountryController> logger) : base(service, logger) { }
    }
}
