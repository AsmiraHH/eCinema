using eCinema.Core.Entities;
using eCinema.Core.SearchObjects;
using eCinema.Repository.RepositoriesInterfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Repository.Repositories
{
    public class MovieActorRepository : BaseRepository<MovieActor, int, BaseSearchObject>, IMovieActorRepository
    {
        public MovieActorRepository(DatabaseContext db) : base(db) { }

    }
}
