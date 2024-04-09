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

        public override async Task<PagedList<Movie>> GetPagedAsync(MovieSearchObject searchObject)
        {
            var items = dbSet.Include(x => x.Production).Include(x => x.Language).Include(x => x.Genres).ThenInclude(x=>x.Genre).OrderByDescending(x => x.ID).AsQueryable();

            if (searchObject.Genre != null)
                items = items.Where(x => x.Genres.Any(y => y.GenreId == searchObject.Genre));
            if (searchObject.Title != null)
                items = items.Where(x => x.Title.ToLower().Contains(searchObject.Title.ToLower()));

            var result = await items.ToPagedListAsync(searchObject);

            return result;
        }
    }
}
