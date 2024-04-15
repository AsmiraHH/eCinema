using eCinema.Core.DTOs;
using FluentValidation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Service.Validators
{
    public class EmployeeValidator : AbstractValidator<EmployeeUpsertDTO>
    {
        public EmployeeValidator()
        {
            RuleFor(c => c.FirstName).NotEmpty().WithErrorCode("NotEmpty");
            RuleFor(c => c.LastName).NotEmpty().WithErrorCode("NotEmpty");
            RuleFor(c => c.Email).NotEmpty().WithErrorCode("NotEmpty");
            RuleFor(c => c.BirthDate).NotNull().WithErrorCode("NotNull");
            RuleFor(c => c.Gender).NotNull().WithErrorCode("NotNull");
            RuleFor(c => c.IsActive).NotNull().WithErrorCode("NotNull");
            RuleFor(a => a.CinemaId).NotNull().WithErrorCode("NotNull");
            RuleFor(a => a.Password)
                .NotEmpty()
                .NotNull()
                .MinimumLength(7)
                .Matches(@"[A-Z]+")
                .Matches(@"[a-z]+")
                .Matches(@"[0-9]+")
                .WithErrorCode("InvalidValue")
                .When(u => u.ID == null || u.Password != null);
            RuleFor(a => a.PhotoBase64).NotEmpty().WithErrorCode("NotNull");
        }
    }
}
