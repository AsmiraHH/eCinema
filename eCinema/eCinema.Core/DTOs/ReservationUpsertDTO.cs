using eCinema.Core.Entities;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.DTOs
{
    public class ReservationUpsertDTO
    {
        public int ID { get; set; }
        public bool isActive { get; set; }

        public int ShowId { get; set; }

        public int SeatId { get; set; }

        public int UserId { get; set; }
    }
}
