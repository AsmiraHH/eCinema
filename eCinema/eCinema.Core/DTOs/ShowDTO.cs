using eCinema.Core.Entities;
using eCinema.Core.Enums;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.DTOs
{
    public class ShowDTO
    {
        public int ID { get; set; }

        public DateTime Date { get; set; }

        public DateTime StartTime { get; set; }
        public Format Format { get; set; }
        public double Price { get; set; }

        public HallDTO Hall { get; set; } = null!;

        public MovieDTO Movie { get; set; } = null!;
    }
}
