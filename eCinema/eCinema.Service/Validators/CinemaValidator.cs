using eCinema.Core.DTOs;
using FluentValidation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Service.Validators
{
    public class CinemaValidator : AbstractValidator<CinemaUpsertDTO>
    {
        public CinemaValidator()
        {
            RuleFor(a => a.Name).NotEmpty().WithErrorCode("NotEmpty");
            RuleFor(a => a.Address).NotEmpty().WithErrorCode("NotEmpty");
            RuleFor(a => a.Email).NotEmpty().WithErrorCode("NotEmpty");
            RuleFor(a => a.PhoneNumber).NotNull().WithErrorCode("NotNull");
            RuleFor(a => a.NumberOfHalls).NotNull().WithErrorCode("NotNull");
            RuleFor(a => a.CityId).NotNull().WithErrorCode("NotNull");
        }
    }
}
