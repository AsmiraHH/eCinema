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
            var items = dbSet.Include(x => x.Hall).Include(x => x.Cinema).Include(x => x.Movie).AsQueryable();

            if (searchObject.CinemaID != null)
                items = items.Where(x => x.CinemaId == searchObject.CinemaID);

            var result = await items.ToPagedListAsync(searchObject);

            return result;
        }
    }
}
