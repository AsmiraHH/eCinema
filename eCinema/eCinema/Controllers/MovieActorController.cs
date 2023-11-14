using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    public class MovieActorController : BaseController<MovieActorDTO, MovieActorUpsertDTO, BaseSearchObject, IMovieActorService>
    {
        public MovieActorController(IMovieActorService service) : base(service) { }
    }
}
