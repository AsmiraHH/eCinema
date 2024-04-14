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
            if(shows!=null)
                await _reservationService.DeleteByShowIdsAsync(shows.Result.Select(x=>x.ID).ToList());

            await CurrentRepository.DeleteByMovieIdAsync(id);
            await UnitOfWork.SaveChangesAsync();
        }
    }
}
