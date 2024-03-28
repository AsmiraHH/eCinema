using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;

namespace eCinema.Controllers
{
    public class MovieController : BaseController<MovieDTO, MovieUpsertDTO, MovieSearchObject, IMovieService>
    {
        public MovieController(IMovieService service, ILogger<MovieController> logger) : base(service, logger) { }

    }
}
