using eCinema.Core.DTOs;
using FluentValidation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Service.Validators
{
    public class CountryValidator : AbstractValidator<CountryUpsertDTO>
    {
        public CountryValidator()
        {
            RuleFor(a => a.Name).NotEmpty().WithErrorCode("NotEmpty");
        }
    }
}
