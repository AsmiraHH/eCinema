using AutoMapper;
using eCinema.Core.DTOs;
using eCinema.Core.Entities;
using eCinema.Core.SearchObjects;
using eCinema.Repository.RepositoriesInterfaces;
using eCinema.Repository.UnitOfWork;
using eCinema.Service.ServiceInterfaces;
using FluentValidation;

namespace eCinema.Service.Services
{
    public class SeatService : BaseService<Seat, SeatDTO, SeatUpsertDTO, BaseSearchObject, ISeatRepository>, ISeatService
    {
        public SeatService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<SeatUpsertDTO> validator) : base(mapper, unitOfWork, validator)
        {

        }
        public async Task<SeatDTO> AddByRowColumnAsync(SeatUpsertDTO upsertDTO)
        {
            List<Seat> seats = new List<Seat>();

            for (char row = 'A'; row < 'A' + upsertDTO.numRows; row++)
            {
                for (int column = 1; column <= upsertDTO.numColumns; column++)
                {
                    seats.Add(new Seat()
                    {
                        HallId = upsertDTO.HallId,
                        Row = Convert.ToString(row),
                        Column = column,
                        isDisabled = false
                    });
                }
            }

            await CurrentRepository.AddRangeAsync(seats);
            await UnitOfWork.SaveChangesAsync();
            return Mapper.Map<SeatDTO>(seats[0]);
        }
        public async Task<SeatDTO> DisableAsync(List<SeatDisableDTO> dtos)
        {
            var entities = Mapper.Map<List<Seat>>(dtos);

            foreach (var e in entities)
            {
                e.isDisabled = true;
            }

            CurrentRepository.UpdateRange(entities);
            await UnitOfWork.SaveChangesAsync();
            return Mapper.Map<SeatDTO>(entities[0]);
        }
        public async Task<List<SeatDTO>?> GetByHallIdAsync(int hallId)
        {
            var entities = await CurrentRepository.GetByHallIdAsync(hallId);
            return Mapper.Map<List<SeatDTO>>(entities);
        }
    }
}
