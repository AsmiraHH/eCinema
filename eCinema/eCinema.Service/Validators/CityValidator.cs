using eCinema.Core.DTOs;
using FluentValidation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Service.Validators
{
    public class CityValidator : AbstractValidator<CityUpsertDTO>
    {
        public CityValidator()
        {
            RuleFor(a => a.Name).NotEmpty().WithErrorCode("NotEmpty");
            RuleFor(a => a.ZipCode).NotEmpty().WithErrorCode("NotEmpty");
            RuleFor(a => a.CountryId).NotNull().WithErrorCode("NotNull");
        }
    }
}
