using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;

namespace eCinema.Service.ServiceInterfaces
{
    public interface IEmployeeService : IBaseService<int, EmployeeDTO, EmployeeUpsertDTO, EmployeeSearchObject>
    {
        Task ChangePassword(EmployeeNewPasswordDTO dto);
    }
}
