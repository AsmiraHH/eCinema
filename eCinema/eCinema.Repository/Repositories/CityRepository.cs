using eCinema.Core.Entities;
using eCinema.Core.Helpers;
using eCinema.Core.SearchObjects;
using eCinema.Repository.RepositoriesInterfaces;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Repository.Repositories
{
    public class CityRepository : BaseRepository<City, int, CitySearchObject>, ICityRepository
    {
        public CityRepository(DatabaseContext db) : base(db) { }
        public override async Task<PagedList<City>> GetPagedAsync(CitySearchObject searchObject)
        {
            var items = dbSet.Include(x=>x.Country).OrderByDescending(x => x.Name).AsQueryable();

            if (searchObject.Country != null)
                items = items.Where(x => x.CountryId == searchObject.Country);
            if (searchObject.Name!= null)
                items = items.Where(x => x.Name.ToLower().Contains(searchObject.Name.ToLower()));

            var result = await items.ToPagedListAsync(searchObject);

            return result;
        }
    }
}
