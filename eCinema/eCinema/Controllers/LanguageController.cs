using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;

namespace eCinema.Controllers
{
    public class LanguageController : BaseController<LanguageDTO, LanguageUpsertDTO, LanguageSearchObject, ILanguageService>
    {
        public LanguageController(ILanguageService service, ILogger<LanguageController> logger) : base(service, logger) { }
    }
}
