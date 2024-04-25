using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;

namespace eCinema.Service.ServiceInterfaces
{
    public interface ISeatService : IBaseService<int, SeatDTO, SeatUpsertDTO, BaseSearchObject>
    {
        Task<SeatDTO> AddByRowColumnAsync(SeatUpsertDTO upsertDTO);
        Task<List<SeatDTO>?> GetByHallIdAsync(int hallId);
        Task<SeatDTO> DisableAsync(List<SeatDisableDTO> dtos);
    }
}
