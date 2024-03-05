using eCinema.Core.SearchObjects;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Core.Helpers
{
    public static class PagedListExtension
    {
        public static async Task<PagedList<T>> ToPagedListAsync<T>(this IQueryable<T> queryable, BaseSearchObject searchObject)
        {
            var itemsList = await queryable
                                  .Skip((searchObject.PageNumber - 1) * searchObject.PageSize)
                                  .Take(searchObject.PageSize)
                                  .ToListAsync();

            var totalCount = await queryable.CountAsync();

            var pagedList = new PagedList<T>();

            pagedList.ListOfItems = itemsList;
            pagedList.TotalCount = totalCount;
            pagedList.PageNumber = searchObject.PageNumber;
            pagedList.PageSize = searchObject.PageSize;

            pagedList.PageCount = totalCount > 0 ? (int)Math.Ceiling(pagedList.TotalCount / (double)pagedList.PageSize) : 0;
            pagedList.HasPreviousPage = pagedList.PageNumber > 1;
            pagedList.HasNextPage = pagedList.PageNumber < pagedList.TotalCount;

            return pagedList;
        }
    }
}
