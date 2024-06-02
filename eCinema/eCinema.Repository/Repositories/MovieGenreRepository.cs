using eCinema.Core.Entities;
using eCinema.Core.SearchObjects;
using eCinema.Repository.RepositoriesInterfaces;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Repository.Repositories
{
    public class MovieGenreRepository : BaseRepository<MovieGenre, int, BaseSearchObject>, IMovieGenreRepository
    {
        public MovieGenreRepository(DatabaseContext db) : base(db) { }
        public void DetachEntity(MovieGenre entity)
        {
            var entry = db.Entry(entity);
            if (entry != null)
            {
                entry.State = EntityState.Modified;
            }
        }
    }
}
