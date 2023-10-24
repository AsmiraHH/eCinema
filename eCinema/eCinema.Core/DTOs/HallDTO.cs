using eCinema.Core.Entities;
using eCinema.Core.Enums;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.DTOs
{
    public class HallDTO
    {
        public int ID { get; set; }
        public string Name { get; set; } = null!;
        public int NumberOfSeats { get; set; }
        public int CinemaId { get; set; }
        public Cinema Cinema { get; set; } = null!;
    }
}
