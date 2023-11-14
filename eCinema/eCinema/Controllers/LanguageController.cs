using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    public class LanguageController : BaseController<LanguageDTO, LanguageUpsertDTO, BaseSearchObject, ILanguageService>
    {
        public LanguageController(ILanguageService service) : base(service) { }
    }
}
