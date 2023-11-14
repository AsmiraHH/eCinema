using eCinema.Core.Entities;
using eCinema.Core.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Repository.RepositoriesInterfaces
{
    public interface IMovieRepository : IBaseRepository<Movie, int, MovieSearchObject>
    {
    }
}
