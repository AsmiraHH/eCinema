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
    public class LanguageService : BaseService<Language,LanguageDTO, LanguageUpsertDTO, LanguageSearchObject, ILanguageRepository>, ILanguageService
    {
        public LanguageService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<LanguageUpsertDTO> validator) : base(mapper, unitOfWork, validator)
        {

        }
    }
}
