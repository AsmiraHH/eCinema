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
        public int NumberOfRows { get; set; }
        public int MaxNumberOfSeatsPerRow { get; set; }

        public CinemaDTO Cinema { get; set; } = null!;
    }
}
