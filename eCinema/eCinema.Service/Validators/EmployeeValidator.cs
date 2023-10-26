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
            RuleFor(a => a.Title).NotEmpty().WithErrorCode("NotEmpty");
            RuleFor(a => a.CinemaId).NotNull().WithErrorCode("NotNull");
        }
    }
}
