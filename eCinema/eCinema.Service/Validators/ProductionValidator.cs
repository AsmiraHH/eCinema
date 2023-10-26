using eCinema.Core.DTOs;
using FluentValidation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Service.Validators
{
    public class ProductionValidator : AbstractValidator<ProductionUpsertDTO>
    {
        public ProductionValidator()
        {
            RuleFor(a => a.Name).NotEmpty().WithErrorCode("NotEmpty");
            RuleFor(a => a.CountryId).NotNull().WithErrorCode("NotNull");
        }
    }
}
