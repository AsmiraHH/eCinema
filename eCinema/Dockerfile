FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 7019
ENV ASPNETCORE_URLS=http://+:7019

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY . .

FROM build AS publish
RUN dotnet publish "eCinema/eCinema.csproj" -c Release -o /app
FROM base AS final
WORKDIR /app
COPY --from=publish /app .

ENTRYPOINT ["dotnet","eCinema.dll"]