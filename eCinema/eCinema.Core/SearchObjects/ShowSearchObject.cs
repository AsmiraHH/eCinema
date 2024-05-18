namespace eCinema.Core.SearchObjects
{
    public class ShowSearchObject : BaseSearchObject
    {
        public int? Cinema { get; set; }
        public int? Hall { get; set; }
        public string? Format { get; set; }
        public string? Movie { get; set; }
        public int? Genre { get; set; }
    }
}
