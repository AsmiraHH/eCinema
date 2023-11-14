using eCinema.Core.Entities;
using eCinema.Core.Enums;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.DTOs
{
    public class EmployeeDTO
    {
        public int ID { get; set; }
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public string Email { get; set; } = null!;
        public string PhoneNumber { get; set; } = null!;
        public DateTime BirthDate { get; set; }
        public Gender Gender { get; set; }
        public Role Role { get; set; }
        public bool IsActive { get; set; }
        public byte[]? ProfilePhoto { get; set; }
        public int CinemaId { get; set; }
        public Cinema Cinema { get; set; } = null!;
    }
}
