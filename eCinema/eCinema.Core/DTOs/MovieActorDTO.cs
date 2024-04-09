using eCinema.Core.Entities;
using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.DTOs
{
    public class MovieActorDTO
    {
        public int MovieId { get; set; }
        public MovieDTO Movie { get; set; } = null!;

        public int ActorId { get; set; }
        public ActorDTO Actor { get; set; } = null!;
    }
}
