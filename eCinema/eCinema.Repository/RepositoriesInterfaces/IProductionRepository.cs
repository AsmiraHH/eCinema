using eCinema.Core.Entities;
using eCinema.Core.SearchObjects;

namespace eCinema.Repository.RepositoriesInterfaces
{
    public interface IProductionRepository : IBaseRepository<Production, int, ProductionSearchObject>
    {
    }
}
