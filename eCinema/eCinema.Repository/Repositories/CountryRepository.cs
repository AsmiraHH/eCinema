using eCinema.Core.Entities;
using eCinema.Core.Helpers;
using eCinema.Core.SearchObjects;
using eCinema.Repository.RepositoriesInterfaces;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Repository.Repositories
{
    public class CountryRepository : BaseRepository<Country, int, CountrySearchObject>, ICountryRepository
    {
        public CountryRepository(DatabaseContext db) : base(db) { }
        public override async Task<PagedList<Country>> GetPagedAsync(CountrySearchObject searchObject)
        {
            var items = dbSet.OrderBy(x => x.Name).AsQueryable();

            if (searchObject.Name != null)
                items = items.Where(x => x.Name.ToLower().Contains(searchObject.Name.ToLower()));

            var result = await items.ToPagedListAsync(searchObject);

            return result;
        }
    }
}
