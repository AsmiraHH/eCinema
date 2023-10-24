using eCinema.Core.Entities;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.DTOs
{
    public class SeatDTO
    {
        public int ID { get; set; }
        public string Row { get; set; } = null!;
        public int Column { get; set; }
                
        public int HallId { get; set; }
        public Hall Hall { get; set; } = null!;
    }
}
