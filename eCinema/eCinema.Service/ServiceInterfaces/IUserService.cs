using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;

namespace eCinema.Service.ServiceInterfaces
{
    public interface IUserService : IBaseService<int, UserDTO, UserUpsertDTO, UserSearchObject>
    {
        Task ChangePassword(UserNewPasswordDTO dto);
        Task<UserDTO> Login(string username, string password);
        Task<List<string>> GetRoles(string username);
    }
}
