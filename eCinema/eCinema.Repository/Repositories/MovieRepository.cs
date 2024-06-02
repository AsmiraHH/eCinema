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
            var items = dbSet.Include(x => x.Production).Include(x => x.Language).Include(x => x.Genres).ThenInclude(x => x.Genre).Include(x => x.Actors).ThenInclude(x => x.Actor).OrderByDescending(x => x.ID).AsQueryable();

            if (searchObject.Genre != null)
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
    }
}
