using eCinema.Core.Helpers;
using eCinema.Core.SearchObjects;

namespace eCinema.Service.ServiceInterfaces
{
    public interface IBaseService<TPrimaryKey, TDTO, TUpsertDTO, TSearchObject>
        where TDTO : class
        where TUpsertDTO : class
        where TSearchObject : BaseSearchObject
    {
        Task<List<TDTO>?> GetAllAsync();
        Task<TDTO?> GetByIdAsync(TPrimaryKey id);
        Task<PagedList<TDTO>> GetPagedAsync(TSearchObject searchObject);
        Task<TDTO> AddAsync(TUpsertDTO dto);
        Task<TDTO> UpdateAsync(TUpsertDTO dto);
        Task DeleteAsync(TDTO dto);
        Task DeleteByIdAsync(TPrimaryKey id);
        Task SoftDeleteAsync(int id);
    }
}
