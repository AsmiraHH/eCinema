using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;

namespace eCinema.Service.ServiceInterfaces
{
    public interface ICountryService : IBaseService<int, CountryDTO, CountryUpsertDTO, CountrySearchObject>
    {
    }
}
