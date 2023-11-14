using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    public class CountryController : BaseController<CountryDTO, CountryUpsertDTO, BaseSearchObject, ICountryService>
    {
        public CountryController(ICountryService service) : base(service) { }
    }
}
