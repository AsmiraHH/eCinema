using eCinema.Core.Enums;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.Entities
{
    public class Hall : BaseEntity
    {
        public int ID { get; set; }
        public string Name { get; set; } = null!;
        public int NumberOfSeats { get; set; }
        public int NumberOfRows { get; set; }
        public int MaxNumberOfSeatsPerRow { get; set; }

        [ForeignKey(nameof(Cinema))]
        public int CinemaId { get; set; }
        public Cinema Cinema { get; set; } = null!;

        public ICollection<Seat> Seats { get; set; } = null!;
        public ICollection<Show> Shows { get; set; } = null!;

    }
}
