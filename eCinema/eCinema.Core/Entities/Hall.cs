using eCinema.Core.Enums;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.Entities
{
    public class Hall
    {
        public int ID { get; set; }
        public string Name { get; set; } = null!;
        public int NumberOfSeats { get; set; }
        //public List<Format> Formats { get; set; } = null!;

        [ForeignKey(nameof(Cinema))]
        public int CinemaId { get; set; }
        public Cinema Cinema { get; set; } = null!;

        public ICollection<Seat> Seats { get; set; } = null!;

    }
}
