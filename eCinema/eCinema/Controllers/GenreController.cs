using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;

namespace eCinema.Controllers
{
    public class GenreController : BaseController<GenreDTO, GenreUpsertDTO, GenreSearchObject, IGenreService>
    {
        public GenreController(IGenreService service, ILogger<GenreController> logger) : base(service, logger) { }
    }
}
