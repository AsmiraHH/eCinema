using eCinema.Core.Entities;
using eCinema.Core.SearchObjects;

namespace eCinema.Repository.RepositoriesInterfaces
{
    public interface IActorRepository : IBaseRepository<Actor, int, ActorSearchObject>
    {
    }
}
