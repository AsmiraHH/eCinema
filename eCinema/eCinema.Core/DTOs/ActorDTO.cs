using eCinema.Core.Enums;
using System.ComponentModel.DataAnnotations;
using System.Reflection;

namespace eCinema.Core.DTOs
{
    public class ActorDTO
    {
        public int ID { get; set; }
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public string Email { get; set; } = null!;
        public DateTime BirthDate { get; set; }
        public Gender Gender { get; set; }
    }
}
