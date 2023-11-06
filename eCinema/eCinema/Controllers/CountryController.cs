using eCinema.Core.DTOs;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    public class CountryController : BaseController<CountryDTO, CountryUpsertDTO, ICountryService>
    {
        public CountryController(ICountryService service) : base(service) { }
    }
}
