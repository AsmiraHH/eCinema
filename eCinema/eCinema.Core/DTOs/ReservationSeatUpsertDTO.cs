using eCinema.Core.Entities;
using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.DTOs
{
    public class ReservationSeatUpsertDTO
    {
        public int ReservationId { get; set; }

        public int SeatId { get; set; }
    }
}
