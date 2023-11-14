using AutoMapper;
using eCinema.Core.DTOs;
using eCinema.Core.Entities;
using eCinema.Core.Exceptions;
using eCinema.Core.SearchObjects;
using eCinema.Repository.RepositoriesInterfaces;
using eCinema.Repository.UnitOfWork;
using eCinema.Service.CryptoService;
using eCinema.Service.ServiceInterfaces;
using FluentValidation;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Service.Services
{
    public class UserService : BaseService<User, UserDTO, UserUpsertDTO, BaseSearchObject, IUserRepository>, IUserService
    {
        private readonly ICryptoService cryptoService;
        public UserService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<UserUpsertDTO> validator, ICryptoService _cryptoService) : base(mapper, unitOfWork, validator)
        {
            cryptoService = _cryptoService;
        }

        public override async Task<UserDTO> AddAsync(UserUpsertDTO upsertDTO)
        {
            await ValidateAsync(upsertDTO);

            var entity = Mapper.Map<User>(upsertDTO);

            entity.PasswordSalt = cryptoService.GenerateSalt();
            entity.PasswordHash = cryptoService.GenerateHash(upsertDTO.Password!, entity.PasswordSalt);

            await CurrentRepository.AddAsync(entity);
            await UnitOfWork.SaveChangesAsync();
            return Mapper.Map<UserDTO>(entity);
        }

        public override async Task<UserDTO> UpdateAsync(UserUpsertDTO upsertDTO)
        {
            var entity = await CurrentRepository.GetByIdAsync(upsertDTO.ID.Value);
            if (entity == null)
                throw new UserNotFoundException();

            Mapper.Map(upsertDTO, entity);

            if (!string.IsNullOrEmpty(upsertDTO.Password))
            {
                entity.PasswordSalt = cryptoService.GenerateSalt();
                entity.PasswordHash = cryptoService.GenerateHash(upsertDTO.Password, entity.PasswordSalt);
            }

            CurrentRepository.Update(entity);
            await UnitOfWork.SaveChangesAsync();

            return Mapper.Map<UserDTO>(entity);
        }

        public async Task ChangePassword(UserNewPasswordDTO dto)
        {
            var user = await CurrentRepository.GetByIdAsync(dto.ID);

            if (user == null)
                throw new UserNotFoundException();

            if (!cryptoService.VerifyPassword(user.PasswordHash, dto.Password, user.PasswordSalt))
                throw new UserWrongCredentialsException();

            user.PasswordSalt = cryptoService.GenerateSalt();
            user.PasswordHash = cryptoService.GenerateHash(dto.NewPassword, user.PasswordSalt);

            CurrentRepository.Update(user);
            await UnitOfWork.SaveChangesAsync();
        }
    }
}
