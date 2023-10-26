using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Service.ServiceInterfaces
{
    public interface IBaseService<TPrimaryKey, TDTO, TUpsertDTO>
        where TDTO : class
        where TUpsertDTO : class
    {
        Task<TDTO?> GetByIdAsync(TPrimaryKey id);
        Task<TDTO> AddAsync(TUpsertDTO dto);
        Task<TDTO> UpdateAsync(TUpsertDTO dto);
        Task DeleteAsync(TDTO dto);
        Task DeleteByIdAsync(TPrimaryKey id);
    }
}
