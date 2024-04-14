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
            var items = dbSet.Include(x => x.Hall).ThenInclude(x => x.Cinema).Include(x => x.Movie).AsQueryable();

            if (searchObject.CinemaID != null)
                items = items.Where(x => x.Hall.CinemaId == searchObject.CinemaID);

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
    }
}
