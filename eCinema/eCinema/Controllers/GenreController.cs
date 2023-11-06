using eCinema.Core.DTOs;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    public class GenreController : BaseController<GenreDTO, GenreUpsertDTO, IGenreService>
    {
        public GenreController(IGenreService service) : base(service) { }
    }
}
