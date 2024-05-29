using eCinema.Core.DTOs;
using eCinema.Core.Entities;
using eCinema.Core.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Service.ServiceInterfaces
{
    public interface IShowService : IBaseService<int, ShowDTO, ShowUpsertDTO, ShowSearchObject>
    {
        Task DeleteByMovieIdAsync(int id);
        Task DeleteByHallIdAsync(int id);
        Task<List<ShowDTO>?> GetLastAddedAsync(int cinemaId);
        Task<List<ShowDTO>?> GetMostWatchedAsync(int cinemaId);
    }
}
