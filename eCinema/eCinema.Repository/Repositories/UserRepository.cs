using eCinema.Core.Entities;
using eCinema.Core.SearchObjects;
using eCinema.Repository.RepositoriesInterfaces;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Repository.Repositories
{
    public class UserRepository : BaseRepository<User, int, BaseSearchObject>, IUserRepository
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
    }
}
