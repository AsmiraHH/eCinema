using eCinema.Core.Entities;
using eCinema.Core.Enums;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.DTOs
{
    public class ShowDTO
    {
        public int ID { get; set; }

        public DateTime DateTime { get; set; }

        public string Format { get; set; } = null!;
        public double Price { get; set; }

        public HallDTO Hall { get; set; } = null!;

        public MovieDTO Movie { get; set; } = null!;
    }
}
