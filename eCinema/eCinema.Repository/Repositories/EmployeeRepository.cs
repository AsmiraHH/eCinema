using eCinema.Core.Entities;
using eCinema.Core.Helpers;
using eCinema.Core.SearchObjects;
using eCinema.Repository.RepositoriesInterfaces;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Repository.Repositories
{
    public class EmployeeRepository : BaseRepository<Employee, int, EmployeeSearchObject>, IEmployeeRepository
    {
        public EmployeeRepository(DatabaseContext db) : base(db) { }
        public override async Task<PagedList<Employee>> GetPagedAsync(EmployeeSearchObject searchObject)
        {
            var items = dbSet.Include(x => x.Cinema).AsQueryable();

            if (searchObject.Cinema != null)
                items = items.Where(x => x.CinemaId == searchObject.Cinema);
            if (searchObject.Gender != null)
                items = items.Where(x => x.Gender == searchObject.Gender);
            if (searchObject.isActive != null)
                items = items.Where(x => x.IsActive == searchObject.isActive);
            if (searchObject.Name != null)
                items = items.Where(x => (x.FirstName + " " + x.LastName).ToLower().Contains(searchObject.Name.ToLower()));

            var result = await items.ToPagedListAsync(searchObject);

            return result;
        }
    }
}
