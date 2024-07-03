using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;

namespace eCinema.Controllers
{
    [Authorize(Roles = "Administrator")]
    public class MovieActorController : BaseController<MovieActorDTO, MovieActorUpsertDTO, BaseSearchObject, IMovieActorService>
    {
        public MovieActorController(IMovieActorService service, ILogger<MovieActorController> logger) : base(service, logger) { }
    }
}
