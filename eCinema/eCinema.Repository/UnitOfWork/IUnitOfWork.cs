using Microsoft.EntityFrameworkCore.Storage;

namespace eCinema.Repository.UnitOfWork
{
    public interface IUnitOfWork
    {
        Task<int> SaveChangesAsync();
    }
}
