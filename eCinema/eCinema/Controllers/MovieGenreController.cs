using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;

namespace eCinema.Controllers
{
    public class MovieGenreController : BaseController<MovieGenreDTO, MovieGenreUpsertDTO, BaseSearchObject, IMovieGenreService>
    {
        public MovieGenreController(IMovieGenreService service, ILogger<MovieGenreController> logger) : base(service, logger) { }
    }
}
