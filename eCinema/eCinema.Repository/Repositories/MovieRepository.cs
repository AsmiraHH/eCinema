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
            var items = dbSet.Include(x => x.MovieGenres).ThenInclude(x => x.Genre).AsQueryable();

            if (searchObject.Genre != null)
                items = items.Where(x => x.MovieGenres.Any(y => y.GenreId == searchObject.Genre)).AsQueryable();

            var result = await items.ToPagedListAsync(searchObject);

            return result;
        }
    }
}
