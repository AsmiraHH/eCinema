using eCinema.Core.Entities;
using eCinema.Core.Helpers;
using eCinema.Core.SearchObjects;
using eCinema.Repository.RepositoriesInterfaces;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Repository.Repositories
{
    public class CinemaRepository : BaseRepository<Cinema, int, CinemaSearchObject>, ICinemaRepository
    {
        public CinemaRepository(DatabaseContext db) : base(db) { }
        public override async Task<PagedList<Cinema>> GetPagedAsync(CinemaSearchObject searchObject)
        {
            var items = dbSet.Include(x => x.City).OrderByDescending(x => x.ID).AsQueryable();

            if (!string.IsNullOrEmpty(searchObject.Name))
                items = items.Where(x => x.Name.ToLower().Contains(searchObject.Name.ToLower()));

            var result = await items.ToPagedListAsync(searchObject);

            return result;
        }
    }
}
