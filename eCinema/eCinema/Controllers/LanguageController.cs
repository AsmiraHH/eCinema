using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    [Authorize(Roles = "Administrator")]
    public class LanguageController : BaseController<LanguageDTO, LanguageUpsertDTO, LanguageSearchObject, ILanguageService>
    {
        public LanguageController(ILanguageService service, ILogger<LanguageController> logger) : base(service, logger) { }
    }
}
