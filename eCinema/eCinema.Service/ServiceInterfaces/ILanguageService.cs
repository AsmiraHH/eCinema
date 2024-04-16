using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Service.ServiceInterfaces
{
    public interface ILanguageService : IBaseService<int, LanguageDTO, LanguageUpsertDTO, LanguageSearchObject>
    {
    }
}
