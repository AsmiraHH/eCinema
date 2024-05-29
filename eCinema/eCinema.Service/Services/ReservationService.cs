using AutoMapper;
using eCinema.Core.DTOs;
using eCinema.Core.Entities;
using eCinema.Core.Helpers;
using eCinema.Core.SearchObjects;
using eCinema.Repository.RepositoriesInterfaces;
using eCinema.Repository.UnitOfWork;
using eCinema.Service.ServiceInterfaces;
using FluentValidation;

namespace eCinema.Service.Services
{
    public class ReservationService : BaseService<Reservation, ReservationDTO, ReservationUpsertDTO, ReservationSearchObject, IReservationRepository>, IReservationService
    {
        public ReservationService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<ReservationUpsertDTO> validator) : base(mapper, unitOfWork, validator)
        {

        }

        public async Task<IEnumerable<ReservationDTO>> GetByUserID(int userID)
        {
            var entities = await CurrentRepository.GetByUserID(userID);
            return Mapper.Map<IEnumerable<ReservationDTO>>(entities);
        }
        public async Task<ReportModel> GetForReportAsync(ReportDTO dto)
        {
            ReportModel report = new ReportModel();

            var list = await CurrentRepository.GetForReportAsync(dto);

            report.ListOfReservations = Mapper.Map<List<ReservationDTO>>(list);
            report.TotalPrice = list.Sum(x => x.Show.Price);
            report.TotalCount = list.Count();
            report.TotalUsers = list.DistinctBy(x=>x.UserId).Count();

            return report;
        }
        public virtual async Task DeleteByShowIdsAsync(List<int> ids)
        {
            await CurrentRepository.DeleteByShowIdsAsync(ids);
            await UnitOfWork.SaveChangesAsync();
        }
        public override async Task<ReservationDTO> AddAsync(ReservationUpsertDTO dto)
        {
            await ValidateAsync(dto);

            var entity = Mapper.Map<Reservation>(dto);
           
            if (dto.SeatIDs.Any())
            {
                entity.Seats = new List<ReservationSeat>();
                foreach (var seat in dto.SeatIDs)
                {
                    entity.Seats.Add(new ReservationSeat()
                    {
                        SeatId = seat,
                        Reservation = entity
                    });
                }
            }

            await CurrentRepository.AddAsync(entity);
            await UnitOfWork.SaveChangesAsync();
            return Mapper.Map<ReservationDTO>(entity);
        }
        public override async Task<ReservationDTO> UpdateAsync(ReservationUpsertDTO dto)
        {
            await ValidateAsync(dto);

            var entity = Mapper.Map<Reservation>(dto);

            if (dto.SeatIDs.Any())
            {
                entity.Seats = new List<ReservationSeat>();
                foreach (var seat in dto.SeatIDs)
                {
                    entity.Seats.Add(new ReservationSeat()
                    {
                        SeatId = seat,
                        Reservation = entity
                    });
                }
            }

            CurrentRepository.Update(entity);
            await UnitOfWork.SaveChangesAsync();
            return Mapper.Map<ReservationDTO>(entity);
        }
    }
}
