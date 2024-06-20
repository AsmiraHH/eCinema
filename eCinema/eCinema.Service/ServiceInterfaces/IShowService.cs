using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;

namespace eCinema.Service.ServiceInterfaces
{
    public interface IShowService : IBaseService<int, ShowDTO, ShowUpsertDTO, ShowSearchObject>
    {
        Task<List<ShowDTO>?> GetLastAddedAsync(int cinemaId);
        Task<List<ShowDTO>?> GetMostWatchedAsync(int cinemaId);
        Task<List<ShowDTO>?> GetRecommendedAsync(int cinemaId, int userId);
    }
}
