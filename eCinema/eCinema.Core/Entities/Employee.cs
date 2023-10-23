using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.Entities
{
    [Table("Employee")]
    public class Employee : User
    {
        public string Title { get; set; } = null!;

        [ForeignKey(nameof(Cinema))]
        public int CinemaId { get; set; }
        public Cinema Cinema { get; set; } = null!;
    }
}
