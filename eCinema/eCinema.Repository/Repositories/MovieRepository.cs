using eCinema.Core.Entities;
using eCinema.Core.Helpers;
using eCinema.Core.SearchObjects;
using eCinema.Repository.RepositoriesInterfaces;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Repository.Repositories
{
    public class MovieRepository : BaseRepository<Movie, int, MovieSearchObject>, IMovieRepository
    {
        public MovieRepository(DatabaseContext db) : base(db) { }
        public override async Task<Movie?> GetByIdAsync(int id)
        {
            return await dbSet.Include(x => x.Genres).ThenInclude(x => x.Genre).Include(x => x.Actors).ThenInclude(x => x.Actor).Include(x => x.Shows).AsNoTracking().FirstOrDefaultAsync(x => x.ID == id);
        }
        public override async Task<PagedList<Movie>> GetPagedAsync(MovieSearchObject searchObject)
        {
            var items = dbSet.Include(x => x.Shows).ThenInclude(x => x.Hall).Include(x => x.Production).Include(x => x.Language).Include(x => x.Genres).ThenInclude(x => x.Genre).Include(x => x.Actors).ThenInclude(x => x.Actor).OrderByDescending(x => x.ID).AsQueryable();

            if (searchObject.Cinema != null)
                items = items.Where(x => x.Shows.Any(y => y.Hall.CinemaId == searchObject.Cinema));
            if (searchObject.Genre != null && searchObject.Genre != 0)
                items = items.Where(x => x.Genres.Any(y => y.GenreId == searchObject.Genre));
            if (searchObject.Language != null)
                items = items.Where(x => x.LanguageId == searchObject.Language);
            if (searchObject.Production != null)
                items = items.Where(x => x.ProductionId == searchObject.Production);
            if (searchObject.Title != null)
                items = items.Where(x => x.Title.ToLower().Contains(searchObject.Title.ToLower()));

            var result = await items.ToPagedListAsync(searchObject);

            return result;
        }
        public virtual async Task<List<Movie>> GetLastAddedAsync(int cinemaId)
        {
            var entities = await dbSet.Where(x => x.Shows.Any(y => y.Hall.CinemaId == cinemaId)).Include(x => x.Genres).ThenInclude(x => x.Genre).Include(x => x.Actors).ThenInclude(x => x.Actor).OrderByDescending(x => x.ID).Take(6).ToListAsync();
            return entities;
        }
        public virtual async Task<List<Movie>> GetMostWatchedAsync(int cinemaId)
        {
            var moviesWithShows = await dbSet
                .Where(x => x.Shows.Any(show => show.Hall.CinemaId == cinemaId))
                .Include(x => x.Shows)
                    .ThenInclude(x => x.Hall)
                .Include(x => x.Shows)
                    .ThenInclude(x => x.Reservations)
                .Include(x => x.Genres)
                    .ThenInclude(x => x.Genre)
                .Include(x => x.Actors)
                    .ThenInclude(x => x.Actor)
                .ToListAsync();

            var mostWatchedMovies = moviesWithShows
                .Select(movie => new
                {
                    Movie = movie,
                    TotalReservations = movie.Shows
                        .Where(show => show.Hall.CinemaId == cinemaId)
                        .Sum(show => show.Reservations.Count)
                })
                .OrderByDescending(x => x.TotalReservations)
                .Take(6)
                .Select(x => x.Movie)
                .ToList();

            return mostWatchedMovies;
        }
    }
}
