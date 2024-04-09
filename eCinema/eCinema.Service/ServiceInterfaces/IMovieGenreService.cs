using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;

namespace eCinema.Service.ServiceInterfaces
{
    public interface IMovieGenreService : IBaseService<int, MovieGenreDTO, MovieGenreUpsertDTO, BaseSearchObject>
    {
        Task DeleteByMovieIdAsync(int id);
    }
}
