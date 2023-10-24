using eCinema.Core.Entities;
using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.DTOs
{
    public class MovieActorUpsertDTO
    {
        public int MovieId { get; set; }

        public int ActorId { get; set; }
    }
}
