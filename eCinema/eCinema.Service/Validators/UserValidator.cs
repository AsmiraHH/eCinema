using eCinema.Core.DTOs;
using FluentValidation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Service.Validators
{
    public class UserValidator : AbstractValidator<UserUpsertDTO>
    {
        public UserValidator()
        {
            RuleFor(a => a.FirstName).NotEmpty().WithErrorCode("NotEmpty");
            RuleFor(a => a.LastName).NotEmpty().WithErrorCode("NotEmpty");
            RuleFor(a => a.Email).NotEmpty().WithErrorCode("NotEmpty");
            RuleFor(a => a.PhoneNumber).NotEmpty().WithErrorCode("NotEmpty");

            RuleFor(a => a.Password)
                .NotEmpty()
                .NotNull()
                .MinimumLength(7)
                .Matches(@"[A-Z]+")
                .Matches(@"[a-z]+")
                .Matches(@"[0-9]+")
                .WithErrorCode("InvalidValue")
                .When(u => u.ID == null || u.Password != null); //ZASTOOOO

            RuleFor(a => a.BirthDate).NotNull().WithErrorCode("NotNull");
            RuleFor(a => a.Gender).IsInEnum().WithErrorCode("NotNull");
            RuleFor(a => a.Role).NotNull().WithErrorCode("NotNull");
            RuleFor(a => a.IsVerified).NotNull().WithErrorCode("NotNull");
            RuleFor(a => a.IsActive).NotNull().WithErrorCode("NotNull");

            //RuleFor(a => a.ProfilePhoto).NotNull().WithErrorCode("NotNull");//uraditi validaciju slike
        }
    }
}
