using eCinema.Core.Entities;
using eCinema.Core.Helpers;
using eCinema.Core.SearchObjects;
using eCinema.Repository.RepositoriesInterfaces;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Repository.Repositories
{
    public class UserRepository : BaseRepository<User, int, UserSearchObject>, IUserRepository
    {
        public UserRepository(DatabaseContext db) : base(db) { }

        public virtual async Task<User?> GetByUsernameAsync(string username)
        {
            return await dbSet.FirstOrDefaultAsync(x => x.Username == username);
        }
        public virtual async Task<List<string>> GetRolesByUsernameAsync(string username)
        {
            return await dbSet.Where(x => x.Username == username).Select(x => x.Role.ToString()).ToListAsync();
        }
        public override async Task<PagedList<User>> GetPagedAsync(UserSearchObject searchObject)
        {
            var items = dbSet.AsQueryable();

            if (searchObject.Gender != null)
                items = items.Where(x => x.Gender == searchObject.Gender);
            if (searchObject.isActive != null)
                items = items.Where(x => x.IsActive == searchObject.isActive);
            if (searchObject.isVerified != null)
                items = items.Where(x => x.IsVerified == searchObject.isVerified);
            if (searchObject.Name != null)
                items = items.Where(x => (x.FirstName + " " + x.LastName).ToLower().Contains(searchObject.Name.ToLower()));

            var result = await items.ToPagedListAsync(searchObject);

            return result;
        }
    }
}
