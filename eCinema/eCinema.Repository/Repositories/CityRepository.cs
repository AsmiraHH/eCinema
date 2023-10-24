using eCinema.Core.Entities;
using eCinema.Repository.RepositoriesInterfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Repository.Repositories
{
    public class CityRepository : BaseRepository<City, int>, ICityRepository
    {
        public CityRepository(DatabaseContext db) : base(db) { }

    }
}
