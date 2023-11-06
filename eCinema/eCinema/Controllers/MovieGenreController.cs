using eCinema.Core.DTOs;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    public class MovieGenreController : BaseController<MovieGenreDTO, MovieGenreUpsertDTO, IMovieGenreService>
    {
        public MovieGenreController(IMovieGenreService service) : base(service) { }
    }
}
