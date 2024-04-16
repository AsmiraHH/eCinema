using eCinema.Core.Entities;
using eCinema.Core.SearchObjects;

namespace eCinema.Repository.RepositoriesInterfaces
{
    public interface IUserRepository : IBaseRepository<User, int, UserSearchObject>
    {
        Task<User?> GetByUsernameAsync(string username);
        Task<List<string>> GetRolesByUsernameAsync(string username);

    }
}
