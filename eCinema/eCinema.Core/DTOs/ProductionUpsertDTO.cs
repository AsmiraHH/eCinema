using eCinema.Core.Entities;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.DTOs
{
    public class ProductionUpsertDTO
    {
        public int ID { get; set; }
        public string Name { get; set; } = null!;

        public int CountryId { get; set; }
    }
}
