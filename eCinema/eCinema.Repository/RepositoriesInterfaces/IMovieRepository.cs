using eCinema.Core.Entities;
using eCinema.Core.SearchObjects;

namespace eCinema.Repository.RepositoriesInterfaces
{
    public interface IMovieRepository : IBaseRepository<Movie, int, MovieSearchObject>
    {
        Task<List<Movie>> GetLastAddedAsync(int cinemaId);
        Task<List<Movie>> GetMostWatchedAsync(int cinemaId);
    }
}
