using eCinema.Core.Enums;
using System.ComponentModel.DataAnnotations;
using System.Data;
using System.Reflection;

namespace eCinema.Core.DTOs
{
    public class UserUpsertDTO
    {
        public int? ID { get; set; }
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public string Email { get; set; } = null!;
        public string? Password { get; set; }
        public string PhoneNumber { get; set; } = null!;
        public DateTime BirthDate { get; set; }
        public Gender Gender { get; set; }
        public Role Role { get; set; }
        public bool IsVerified { get; set; }
        public bool IsActive { get; set; }
        public byte[]? ProfilePhoto { get; set; }
    }
}
