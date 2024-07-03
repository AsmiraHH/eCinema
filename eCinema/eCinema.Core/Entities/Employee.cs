using eCinema.Core.Enums;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.Entities
{
    public class Employee : BaseEntity
    {
        public int ID { get; set; }
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public string Email { get; set; } = null!;
        public string PhoneNumber { get; set; } = null!;

        [DataType(DataType.Date)]
        public DateTime BirthDate { get; set; }
        public Gender Gender { get; set; }
        public bool IsActive { get; set; }
        public byte[]? ProfilePhoto { get; set; }

        [ForeignKey(nameof(Cinema))]
        public int CinemaId { get; set; }
        public Cinema Cinema { get; set; } = null!;
    }
}
