using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;

namespace eCinema.Service.ServiceInterfaces
{
    public interface IMovieService : IBaseService<int, MovieDTO, MovieUpsertDTO, MovieSearchObject>
    {
        Task<List<MovieDTO>?> GetLastAddedAsync(int cinemaId);
        Task<List<MovieDTO>?> GetMostWatchedAsync(int cinemaId);
    }
}
