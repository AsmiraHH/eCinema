using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;

namespace eCinema.Controllers
{
    public class MovieActorController : BaseController<MovieActorDTO, MovieActorUpsertDTO, BaseSearchObject, IMovieActorService>
    {
        public MovieActorController(IMovieActorService service, ILogger<MovieActorController> logger) : base(service, logger) { }
    }
}
