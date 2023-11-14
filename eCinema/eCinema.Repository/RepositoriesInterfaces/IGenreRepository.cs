using eCinema.Core.Entities;
using eCinema.Core.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Repository.RepositoriesInterfaces
{
    public interface IGenreRepository : IBaseRepository<Genre, int, BaseSearchObject>
    {
    }
}
