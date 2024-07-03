using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;

namespace eCinema.Controllers
{
    [Authorize(Roles = "Administrator")]
    public class MovieGenreController : BaseController<MovieGenreDTO, MovieGenreUpsertDTO, BaseSearchObject, IMovieGenreService>
    {
        public MovieGenreController(IMovieGenreService service, ILogger<MovieGenreController> logger) : base(service, logger) { }
    }
}
