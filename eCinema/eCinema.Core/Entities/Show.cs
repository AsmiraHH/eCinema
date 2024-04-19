using eCinema.Core.Enums;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.Entities
{
    public class Show
    {
        public int ID { get; set; }

        [DataType(DataType.Date)]
        public DateTime DateTime { get; set; }

        public string Format { get; set; } = null!;
        public double Price { get; set; }

        [ForeignKey(nameof(Hall))]
        public int HallId { get; set; }
        public Hall Hall { get; set; } = null!;

        [ForeignKey(nameof(Movie))]
        public int MovieId { get; set; }
        public Movie Movie { get; set; } = null!;

        public ICollection<Reservation> Reservations { get; set; } = null!;
    }
}
