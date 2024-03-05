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
            var items = dbSet.Include(x => x.Hall).AsQueryable();

            if (searchObject.CinemaID != null)
                items = items.Include(x => x.Hall).Where(x => x.Hall.CinemaId == searchObject.CinemaID).AsQueryable();

            var result = await items.ToPagedListAsync(searchObject);

            return result;
        }
    }
}
