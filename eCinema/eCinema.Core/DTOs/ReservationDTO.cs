using eCinema.Core.Entities;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.DTOs
{
    public class ReservationDTO
    {
        public int ID { get; set; }
        public bool isActive { get; set; }

        public ShowDTO Show { get; set; } = null!;

        public UserDTO User { get; set; } = null!;
        public List<ReservationSeatDTO> Seats { get; set; } = null!;
    }
}
