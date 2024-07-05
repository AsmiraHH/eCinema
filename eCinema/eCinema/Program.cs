using AutoMapper;
using eCinema.Core;
using eCinema.Repository;
using eCinema.Service;
using eCinema.Service.Authentication;
using Microsoft.AspNetCore.Authentication;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;
using System.Reflection.Emit;
using System.Text.Json.Serialization;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddAutoMapper(typeof(Program), typeof(MappingProfile));
builder.Services.ConfigureValidators();
builder.Services.ConfigureServices();
builder.Services.ConfigureRepositories();
builder.Services.AddDbContext<DatabaseContext>(options => options.UseSqlServer(builder.Configuration.GetConnectionString("connectionString")));

builder.Services.AddSwaggerGen(c =>
{
    c.AddSecurityDefinition("basicAuth", new Microsoft.OpenApi.Models.OpenApiSecurityScheme()
    {
        Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
        Scheme = "basic"
    });

    c.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement()
    {
        {
            new OpenApiSecurityScheme
            {
                Reference=new OpenApiReference{Type=ReferenceType.SecurityScheme,Id="basicAuth"}
            },
            new string[]{}
        }
    });
});

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddControllers().AddJsonOptions(x =>
                x.JsonSerializerOptions.ReferenceHandler = ReferenceHandler.IgnoreCycles);

builder.Services.AddAuthentication("BasicAuthentication")
                .AddScheme<AuthenticationSchemeOptions, BasicAuthentication>("BasicAuthentication", null);

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

using (var scope = app.Services.CreateScope())
{
    var context = scope.ServiceProvider.GetRequiredService<DatabaseContext>();
    context.Database.Migrate();
}

app.Run();
