using eCinema.Core.Enums;
using System.ComponentModel.DataAnnotations;
using System.Reflection;

namespace eCinema.Core.Entities
{
    public abstract class BaseEntity
    {
        public bool IsDeleted { get; set; } = false;

        public DateTime? ModifiedAt { get; set; }
    }
}
