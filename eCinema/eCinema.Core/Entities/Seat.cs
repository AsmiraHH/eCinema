using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.Entities
{
    public class Seat
    {
        public int ID { get; set; }
        public string Row { get; set; } = null!;
        public int Column { get; set; }
        public bool isDisabled { get; set; }
                
        [ForeignKey(nameof(Hall))]
        public int HallId { get; set; }
        public Hall Hall { get; set; } = null!;

        public ICollection<Reservation> Reservations { get; set; } = null!;
    }
}
