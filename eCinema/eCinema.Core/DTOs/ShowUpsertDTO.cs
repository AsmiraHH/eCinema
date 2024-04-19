using eCinema.Core.Entities;
using eCinema.Core.Enums;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.DTOs
{
    public class ShowUpsertDTO
    {
        public int ID { get; set; }

        public DateTime DateTime { get; set; }

        public string Format { get; set; } = null!;
        public double Price { get; set; }

        public int HallId { get; set; }

        public int MovieId { get; set; }
    }
}
