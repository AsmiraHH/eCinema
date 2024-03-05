using eCinema.Core.Entities;
using eCinema.Core.SearchObjects;
using eCinema.Repository.RepositoriesInterfaces;

namespace eCinema.Repository.Repositories
{
    public class GenreRepository : BaseRepository<Genre, int, BaseSearchObject>, IGenreRepository
    {
        public GenreRepository(DatabaseContext db) : base(db) { }

    }
}
