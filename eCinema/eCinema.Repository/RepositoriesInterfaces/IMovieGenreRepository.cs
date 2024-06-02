using eCinema.Core.Entities;
using eCinema.Core.SearchObjects;

namespace eCinema.Repository.RepositoriesInterfaces
{
    public interface IMovieGenreRepository : IBaseRepository<MovieGenre, int, BaseSearchObject>
    {
        void DetachEntity(MovieGenre entity);
    }
}
