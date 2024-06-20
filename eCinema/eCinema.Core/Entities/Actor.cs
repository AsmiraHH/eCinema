using eCinema.Core.Enums;
using System.ComponentModel.DataAnnotations;
using System.Reflection;

namespace eCinema.Core.Entities
{
    public class Actor:BaseEntity
    {
        public int ID { get; set; }
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public string Email { get; set; } = null!;

        [DataType(DataType.Date)]
        public DateTime BirthDate { get; set; }
        public Gender Gender { get; set; }

        public ICollection<MovieActor> Movies { get; set; } = null!;
    }
}
