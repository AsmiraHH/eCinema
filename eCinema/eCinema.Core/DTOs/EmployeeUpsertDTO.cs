using eCinema.Core.Entities;
using eCinema.Core.Enums;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.DTOs
{
    public class EmployeeUpsertDTO
    {
        public int? ID { get; set; }
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public string Email { get; set; } = null!;
        public string PhoneNumber { get; set; } = null!;
        public DateTime BirthDate { get; set; }
        public Gender Gender { get; set; }
        public bool IsActive { get; set; }
        public string? PhotoBase64 { get; set; }
        public int CinemaId { get; set; }
    }
}
