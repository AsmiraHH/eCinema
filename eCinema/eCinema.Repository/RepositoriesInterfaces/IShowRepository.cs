using eCinema.Core.Entities;
using eCinema.Core.SearchObjects;

namespace eCinema.Repository.RepositoriesInterfaces
{
    public interface IShowRepository : IBaseRepository<Show, int, ShowSearchObject>
    {
        Task DeleteByMovieIdAsync(int id);
        Task DeleteByHallIdAsync(int id);
        Task<List<Show>> GetByMovieIdAsync(int id);
        Task<List<Show>> GetByHallIdAsync(int id);
        Task<List<Show>> GetLastAddedAsync(int cinemaId);
        Task<List<Show>> GetMostWatchedAsync(int cinemaId);
        Task<List<Show>> GetRecommendedAsync(int cinemaId, int genreId);
    }
}
