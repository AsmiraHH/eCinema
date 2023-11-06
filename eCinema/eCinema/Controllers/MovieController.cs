using eCinema.Core.DTOs;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    public class MovieController : BaseController<MovieDTO, MovieUpsertDTO, IMovieService>
    {
        public MovieController(IMovieService service) : base(service) { }
    }
}
