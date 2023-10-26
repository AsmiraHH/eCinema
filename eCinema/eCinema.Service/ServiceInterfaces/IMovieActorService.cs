using eCinema.Core.DTOs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Service.ServiceInterfaces
{
    public interface IMovieActorService : IBaseService<int, MovieActorDTO, MovieActorUpsertDTO>
    {
    }
}
