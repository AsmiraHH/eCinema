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
    public class MovieGenreRepository : BaseRepository<MovieGenre, int, BaseSearchObject>, IMovieGenreRepository
    {
        public MovieGenreRepository(DatabaseContext db) : base(db) { }

    }
}
