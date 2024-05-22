using AutoMapper;
using eCinema.Core.DTOs;
using eCinema.Core.Entities;
using eCinema.Core.SearchObjects;
using eCinema.Repository.RepositoriesInterfaces;
using eCinema.Repository.UnitOfWork;
using eCinema.Service.ServiceInterfaces;
using FluentValidation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Service.Services
{
    public class ShowService : BaseService<Show, ShowDTO, ShowUpsertDTO, ShowSearchObject, IShowRepository>, IShowService
    {
        private IReservationService _reservationService;
        public ShowService(IMapper mapper, IReservationService reservationService, IUnitOfWork unitOfWork, IValidator<ShowUpsertDTO> validator) : base(mapper, unitOfWork, validator)
        {
            _reservationService = reservationService;
        }
        public virtual async Task DeleteByMovieIdAsync(int id)
        {
            var shows = CurrentRepository.GetByMovieIdAsync(id);
            if (shows != null)
                await _reservationService.DeleteByShowIdsAsync(shows.Result.Select(x => x.ID).ToList());

            await CurrentRepository.DeleteByMovieIdAsync(id);
            await UnitOfWork.SaveChangesAsync();
        }
        public override async Task DeleteByIdAsync(int id)
        {
            var entity = CurrentRepository.GetByIdAsync(id);
            if (entity.Result != null)
            {
                await _reservationService.DeleteByShowIdsAsync(new List<int>() { id });
            }

            await CurrentRepository.DeleteByIdAsync(id);
            await UnitOfWork.SaveChangesAsync();
        }
        public async Task<List<ShowDTO>?> GetLastAddedAsync(int cinemaId)
        {
            var entities = await CurrentRepository.GetLastAddedAsync(cinemaId);
            return Mapper.Map<List<ShowDTO>>(entities);
        }
        public async Task<List<ShowDTO>?> GetMostWatchedAsync(int cinemaId)
        {
            var entities = await CurrentRepository.GetMostWatchedAsync(cinemaId);
            return Mapper.Map<List<ShowDTO>>(entities);
        }
    }
}
