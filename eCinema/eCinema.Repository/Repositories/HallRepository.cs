using eCinema.Core.Entities;
using eCinema.Core.Helpers;
using eCinema.Core.SearchObjects;
using eCinema.Repository.RepositoriesInterfaces;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Repository.Repositories
{
    public class HallRepository : BaseRepository<Hall, int, HallSearchObject>, IHallRepository
    {
        public HallRepository(DatabaseContext db) : base(db) { }
        public override async Task<PagedList<Hall>> GetPagedAsync(HallSearchObject searchObject)
        {
            var items = dbSet.Include(x => x.Cinema).OrderBy(x=>x.Cinema.Name).AsQueryable();

            if (searchObject.Cinema!= null)
                items = items.Where(x => x.CinemaId== searchObject.Cinema);
            if (searchObject.Name != null)
                items = items.Where(x => x.Name.ToLower().Contains(searchObject.Name.ToLower()));

            var result = await items.ToPagedListAsync(searchObject);

            return result;
        }
    }
}
