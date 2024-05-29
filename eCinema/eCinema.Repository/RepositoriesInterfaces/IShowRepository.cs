using eCinema.Core.Entities;
using eCinema.Core.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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
    }
}
