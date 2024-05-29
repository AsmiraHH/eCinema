using eCinema.Core.Entities;
using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.DTOs
{
    public class ReservationSeatDTO
    {
        public int ReservationId { get; set; }
        public ReservationDTO Reservation { get; set; } = null!;

        public int SeatId { get; set; }
        public SeatDTO Seat { get; set; } = null!;
    }
}
