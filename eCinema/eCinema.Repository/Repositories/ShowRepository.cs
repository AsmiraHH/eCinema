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
            var items = dbSet.Include(x => x.Hall).ThenInclude(x => x.Cinema).Include(x => x.Movie).ThenInclude(x => x.Genres).ThenInclude(x => x.Genre).Include(x => x.Movie).ThenInclude(x => x.Actors).ThenInclude(x => x.Actor).AsQueryable();

            if (searchObject.Cinema != null && searchObject.Cinema != 0)
                items = items.Where(x => x.Hall.CinemaId == searchObject.Cinema);
            if (searchObject.Hall != null && searchObject.Hall != 0)
                items = items.Where(x => x.HallId == searchObject.Hall);
            if (searchObject.Genre != null && searchObject.Genre != 0)
                items = items.Where(x => x.Movie.Genres.Any(y => y.GenreId == searchObject.Genre));
            if (searchObject.Movie != null)
                items = items.Where(x => x.Movie.Title.ToLower().Contains(searchObject.Movie.ToLower()));
            if (searchObject.Format != null)
                items = items.Where(x => x.Format.ToLower().Contains(searchObject.Format.ToLower()));

            var result = await items.ToPagedListAsync(searchObject);

            return result;
        }
        public virtual async Task<List<Show>> GetRecommendedAsync(int cinemaId, int genreId)
        {
            var entities = await dbSet.Where(x => x.Hall.CinemaId == cinemaId && x.Movie.Genres.Any(x => x.GenreId == genreId)).Include(x => x.Movie).ThenInclude(x => x.Genres).ThenInclude(x => x.Genre).Include(x => x.Movie).ThenInclude(x => x.Actors).ThenInclude(x => x.Actor).Take(6).ToListAsync();
            return entities;
        }
        public async Task<List<Show>?> GetByMovieIdAsync(int movieId, int cinemaId, bool isDistinct)
        {
            if (isDistinct)
                return await dbSet.Include(x => x.Hall).Include(x=>x.Movie).Where(x => x.MovieId == movieId && x.Hall.CinemaId == cinemaId).GroupBy(x => x.DateTime.Date).Select(g => g.First()).ToListAsync();
            else
                return await dbSet.Include(x => x.Hall).Include(x => x.Movie).Where(x => x.MovieId == movieId && x.Hall.CinemaId == cinemaId).ToListAsync();
        }
    }
}
