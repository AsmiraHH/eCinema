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
    public class HallService : BaseService<Hall,HallDTO, HallUpsertDTO, HallSearchObject, IHallRepository>, IHallService
    {
        private IShowService _showService;

        public HallService(IMapper mapper, IUnitOfWork unitOfWork, IShowService showService, IValidator<HallUpsertDTO> validator) : base(mapper, unitOfWork, validator)
        {
            _showService = showService;
        }
        public override async Task DeleteByIdAsync(int id)
        {
            var entity = CurrentRepository.GetByIdAsync(id);
            if (entity.Result != null)
            {
                await _showService.DeleteByHallIdAsync(id);
            }

            await CurrentRepository.DeleteByIdAsync(id);
            await UnitOfWork.SaveChangesAsync();
        }
    }
}
