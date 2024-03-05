using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;

namespace eCinema.Controllers
{
    public class GenreController : BaseController<GenreDTO, GenreUpsertDTO, BaseSearchObject, IGenreService>
    {
        public GenreController(IGenreService service, ILogger<GenreController> logger) : base(service, logger) { }
    }
}
