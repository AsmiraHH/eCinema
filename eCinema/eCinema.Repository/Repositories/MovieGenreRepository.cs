using eCinema.Core.Entities;
using eCinema.Core.SearchObjects;
using eCinema.Repository.RepositoriesInterfaces;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Repository.Repositories
{
    public class MovieGenreRepository : BaseRepository<MovieGenre, int, BaseSearchObject>, IMovieGenreRepository
    {
        public MovieGenreRepository(DatabaseContext db) : base(db) { }
        public virtual async Task DeleteByMovieIdAsync(int id)
        {
            var entity = await dbSet.Where(x => x.MovieId == id).ToListAsync();
            if (entity != null)
                dbSet.RemoveRange(entity);
        }
    }
}
