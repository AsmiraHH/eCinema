using eCinema.Core.Entities;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.DTOs
{
    public class ReservationDTO
    {
        public int ID { get; set; }
        public bool isActive { get; set; }

        public int ShowId { get; set; }
        public Show Show { get; set; } = null!;

        public int SeatId { get; set; }
        public Seat Seat { get; set; } = null!;

        public int UserId { get; set; }
        public User User { get; set; } = null!;
    }
}
