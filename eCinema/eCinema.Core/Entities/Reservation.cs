using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.Entities
{
    public class Reservation
    {
        public int ID { get; set; }
        public bool isActive { get; set; }

        [ForeignKey(nameof(Show))]
        public int ShowId { get; set; }
        public Show Show { get; set; } = null!;

        [ForeignKey(nameof(User))]
        public int UserId { get; set; }
        public User User { get; set; } = null!;
        public ICollection<ReservationSeat> Seats { get; set; } = new List<ReservationSeat>();
    }
}
