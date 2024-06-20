using eCinema.Core.Enums;
using System.ComponentModel.DataAnnotations;
using System.Data;
using System.Reflection;

namespace eCinema.Core.Entities
{
    public class User : BaseEntity
    {
        public int ID { get; set; }
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public string Username { get; set; } = null!;

        public string Email { get; set; } = null!;
        public string PhoneNumber { get; set; } = null!;

        [DataType(DataType.Date)]
        public DateTime BirthDate { get; set; }
        public Gender Gender { get; set; }
        public string PasswordHash { get; set; } = null!;
        public string PasswordSalt { get; set; } = null!;
        public Role Role { get; set; }
        public bool IsVerified { get; set; }
        public bool IsActive { get; set; }
        public byte[]? ProfilePhoto { get; set; }
        public ICollection<Reservation> Reservations { get; set; } = null!;
    }
}
