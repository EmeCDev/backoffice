using UsersApi.Filters;
using UsersApi.Services;
using UsersApi.Helpers;
using UsersApi.Repositories;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers().AddJsonOptions(options =>
{
    options.JsonSerializerOptions.DefaultBufferSize = 1024 * 1024 * 100;
});

// Usar minusculas para urls y querystrings
builder.Services.AddRouting(options =>
{
    options.LowercaseUrls = true;
    options.LowercaseQueryStrings = true;
});

// AppSettings.json
builder.Services.AddSingleton<IConfiguration>(builder.Configuration);

// Servicios
builder.Services.AddScoped<UserService>();
builder.Services.AddScoped<ProfileService>();
builder.Services.AddScoped<LogService>();

// Repositorios
builder.Services.AddScoped<UserRepository>();
builder.Services.AddScoped<ProfileRepository>();
builder.Services.AddScoped<LogRepository>();

// Helpers
builder.Services.AddScoped<BcryptHelper>();
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

var frontDomain = builder.Configuration.GetValue<string>("AllowedOrigins:Frontend");

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