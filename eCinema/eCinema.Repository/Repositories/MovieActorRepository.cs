using eCinema.Core.Entities;
using eCinema.Core.SearchObjects;
using eCinema.Repository.RepositoriesInterfaces;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Repository.Repositories
{
    public class MovieActorRepository : BaseRepository<MovieActor, int, BaseSearchObject>, IMovieActorRepository
    {
        public MovieActorRepository(DatabaseContext db) : base(db) { }
        public void DetachEntity(MovieActor entity)
        {
            var entry = db.Entry(entity);
            if (entry != null)
            {
                entry.State = EntityState.Modified;
            }
        }
    }
}
