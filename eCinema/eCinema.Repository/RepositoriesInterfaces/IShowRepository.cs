using eCinema.Core.Entities;
using eCinema.Core.SearchObjects;

namespace eCinema.Repository.RepositoriesInterfaces
{
    public interface IShowRepository : IBaseRepository<Show, int, ShowSearchObject>
    {
        Task<List<Show>> GetRecommendedAsync(int cinemaId, int genreId);
        Task<List<Show>?> GetByMovieIdAsync(int movieId, int cinemaId, bool isDistinct);
    }
}
