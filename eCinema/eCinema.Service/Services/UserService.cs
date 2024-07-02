using AutoMapper;
using eCinema.Core.DTOs;
using eCinema.Core.Entities;
using eCinema.Core.Exceptions;
using eCinema.Core.SearchObjects;
using eCinema.RabbitMQ;
using eCinema.Repository.RepositoriesInterfaces;
using eCinema.Repository.UnitOfWork;
using eCinema.Service.CryptoService;
using eCinema.Service.MailService;
using eCinema.Service.ServiceInterfaces;
using FluentValidation;

namespace eCinema.Service.Services
{
    public class UserService : BaseService<User, UserDTO, UserUpsertDTO, UserSearchObject, IUserRepository>, IUserService
    {
        private readonly ICryptoService cryptoService;
        IMailService mailService;
        public UserService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<UserUpsertDTO> validator, ICryptoService _cryptoService, IMailService _mailService) : base(mapper, unitOfWork, validator)
        {
            cryptoService = _cryptoService;
            mailService = _mailService;
        }

        public override async Task<UserDTO> AddAsync(UserUpsertDTO upsertDTO)
        {
            await ValidateAsync(upsertDTO);

            var entity = Mapper.Map<User>(upsertDTO);

            entity.PasswordSalt = cryptoService.GenerateSalt();
            entity.PasswordHash = cryptoService.GenerateHash(upsertDTO.Password!, entity.PasswordSalt);

            if (!string.IsNullOrEmpty(upsertDTO?.PhotoBase64))
                entity.ProfilePhoto = Convert.FromBase64String(upsertDTO.PhotoBase64);

            entity.Role = 0;
            entity.Token = GenerateRandomNo();
           
            await CurrentRepository.AddAsync(entity);
            await UnitOfWork.SaveChangesAsync();

            var mail = new Email_TokenDTO()
            {
                Mail = entity.Email,
                Token = entity.Token
            };

            mailService.StartRabbitMQ(mail);

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

            if (!string.IsNullOrEmpty(upsertDTO?.PhotoBase64))
                entity.ProfilePhoto = Convert.FromBase64String(upsertDTO.PhotoBase64);

            CurrentRepository.Update(entity);
            await UnitOfWork.SaveChangesAsync();

            return Mapper.Map<UserDTO>(entity);
        }
        public async Task<UserDTO> UpdateProfileImageAsync(UserUpsertImageDTO upsertDTO)
        {
            var user = await CurrentRepository.GetByIdAsync(upsertDTO.ID);

            if (user == null)
                throw new UserNotFoundException();

            if (!string.IsNullOrEmpty(upsertDTO?.PhotoBase64))
                user.ProfilePhoto = Convert.FromBase64String(upsertDTO.PhotoBase64);

            CurrentRepository.Update(user);
            await UnitOfWork.SaveChangesAsync();

            return Mapper.Map<UserDTO>(user);
        }
        public async Task<UserDTO> Login(string username, string password)
        {
            var user = await CurrentRepository.GetByUsernameAsync(username);

            if (user == null)
                throw new UserNotFoundException();

            if (!cryptoService.VerifyPassword(user.PasswordHash, password, user.PasswordSalt))
                throw new UserWrongCredentialsException();

            return Mapper.Map<UserDTO>(user);
        }
        public async Task<List<string>> GetRoles(string username)
        {
            var roles = await CurrentRepository.GetRolesByUsernameAsync(username);

            if (roles == null)
                return null;

            return roles;
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
        public async Task Verify(VerificationDTO req)
        {
            var entity = await CurrentRepository.GetByEmailAsync(req.Email) ?? throw new UserNotFoundException();

            if (entity.Token != req.Token)
                throw new UserNotFoundException();

            entity.IsVerified = true;
            await UnitOfWork.SaveChangesAsync();
        }

        private int GenerateRandomNo()
        {
            int _min = 1000;
            int _max = 10000;
            Random _rdm = new Random();
            return _rdm.Next(_min, _max);
        }
    }
}
