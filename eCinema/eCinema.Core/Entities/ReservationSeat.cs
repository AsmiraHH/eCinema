using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.Entities
{
    [PrimaryKey(nameof(ReservationId), nameof(SeatId))]
    public class ReservationSeat : BaseEntity
    {
        [ForeignKey(nameof(Reservation))]
        public int ReservationId { get; set; }
        public Reservation Reservation { get; set; } = null!;

        [ForeignKey(nameof(Seat))]
        public int SeatId { get; set; }
        public Seat Seat { get; set; } = null!;
    }
}
