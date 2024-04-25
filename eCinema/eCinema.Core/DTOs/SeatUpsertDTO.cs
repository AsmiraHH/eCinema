using eCinema.Core.Entities;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.DTOs
{
    public class SeatUpsertDTO
    {
        public int ID { get; set; }
        public int numRows { get; set; }
        public int numColumns { get; set; }

        public int HallId { get; set; }
    }
}
