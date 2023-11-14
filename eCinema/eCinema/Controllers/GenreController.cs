using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    public class GenreController : BaseController<GenreDTO, GenreUpsertDTO, BaseSearchObject, IGenreService>
    {
        public GenreController(IGenreService service) : base(service) { }
    }
}
