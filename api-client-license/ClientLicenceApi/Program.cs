using ClientLicenseApi.Filters;
using ClientLicenseApi.Helpers;
using ClientLicenseApi.Repositories;
using ClientLicenseApi.Services;
using Microsoft.AspNetCore.Mvc.Filters;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();

// AppSettings.json
builder.Services.AddSingleton<IConfiguration>(builder.Configuration);

// Servicios
builder.Services.AddScoped<LicenseService>();

// Repositorios
builder.Services.AddScoped<LogRepository>();
builder.Services.AddScoped<LicenseRepository>();

// Helpers
builder.Services.AddScoped<DbConnectionHelper>();
builder.Services.AddScoped<JwtHelper>();

// Filters
builder.Services.AddScoped<ValidateJwtFilter>();
builder.Services.AddScoped<RequiredGrantFilter>();
builder.Services.AddScoped<ExceptionFilter>();
builder.Services.AddControllers(options =>
{
    options.Filters.AddService<ValidateJwtFilter>();
    options.Filters.AddService<RequiredGrantFilter>();
    options.Filters.Add<ExceptionFilter>();
});

// CORS 

var frontDomain = builder.Configuration.GetValue<string>("AllowedOrigns:Frontend");

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFront", policy =>
    {
        policy.WithOrigins(frontDomain)
                  .AllowCredentials()
                  .AllowAnyHeader()
                  .AllowAnyMethod();
    });
});

var app = builder.Build();

app.UseHttpsRedirection();
app.UseRouting();
app.UseCors("AllowFront");
app.UseMiddleware<LoggingMiddleware>();
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();
app.Run();