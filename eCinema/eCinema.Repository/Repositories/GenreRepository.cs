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
    public class GenreRepository : BaseRepository<Genre, int, BaseSearchObject>, IGenreRepository
    {
        public GenreRepository(DatabaseContext db) : base(db) { }

    }
}
