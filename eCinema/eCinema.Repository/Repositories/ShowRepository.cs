using eCinema.Core.Entities;
using eCinema.Core.Helpers;
using eCinema.Core.SearchObjects;
using eCinema.Repository.RepositoriesInterfaces;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Repository.Repositories
{
    public class ShowRepository : BaseRepository<Show, int, ShowSearchObject>, IShowRepository
    {
        public ShowRepository(DatabaseContext db) : base(db) { }

        public override async Task<PagedList<Show>> GetPagedAsync(ShowSearchObject searchObject)
        {
            var items = dbSet.Include(x => x.Hall).ThenInclude(x => x.Cinema).Include(x => x.Movie).ThenInclude(x=>x.Genres).ThenInclude(x=>x.Genre).AsQueryable();

            if (searchObject.Cinema != null && searchObject.Cinema != 0)
                items = items.Where(x => x.Hall.CinemaId == searchObject.Cinema);
            if (searchObject.Hall != null && searchObject.Hall != 0)
                items = items.Where(x => x.HallId == searchObject.Hall);
            if (searchObject.Genre != null && searchObject.Genre != 0)
                items = items.Where(x => x.Movie.Genres.Any(y => y.GenreId == searchObject.Genre));
            if (searchObject.Movie != null )
                items = items.Where(x => x.Movie.Title.ToLower().Contains(searchObject.Movie.ToLower()));
            if (searchObject.Format != null)
                items = items.Where(x => x.Format.ToLower().Contains(searchObject.Format.ToLower()));

            var result = await items.ToPagedListAsync(searchObject);

            return result;
        }
        public virtual async Task DeleteByMovieIdAsync(int id)
        {
            var entity = await dbSet.Where(x => x.MovieId == id).ToListAsync();
            if (entity != null)
                dbSet.RemoveRange(entity);
        }
        public virtual async Task<List<Show>> GetByMovieIdAsync(int id)
        {
            var entities = await dbSet.Where(x => x.MovieId == id).ToListAsync();
            return entities;
        }

        public virtual async Task<List<Show>> GetLastAddedAsync()
        {
            var entities = await dbSet.Include(x => x.Movie).ThenInclude(x => x.Genres).ThenInclude(x => x.Genre).OrderByDescending(x => x.ID).Take(6).ToListAsync();
            return entities;
        }

        public virtual async Task<List<Show>> GetMostWatchedAsync()
        {
            var entities = await dbSet.Include(x => x.Movie).ThenInclude(x=>x.Genres).ThenInclude(x => x.Genre).OrderByDescending(x => x.Reservations.Count).Take(6).ToListAsync();
            return entities;
        }
    }
}
