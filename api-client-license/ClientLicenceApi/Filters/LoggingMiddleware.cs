using System.Diagnostics;
using ClientLicenseApi.Models;
using ClientLicenseApi.Repositories;

namespace ClientLicenseApi.Filters
{
    public class LoggingMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly IServiceScopeFactory _scopeFactory;

        public LoggingMiddleware(RequestDelegate next, IServiceScopeFactory scopeFactory)
        {
            _next = next;
            _scopeFactory = scopeFactory;
        }

        public async Task Invoke(HttpContext context)
        {
            var startDate = DateTime.UtcNow;
            var ipAddress = context.Connection.RemoteIpAddress?.ToString() ?? "Desconocida";
            var httpMethod = context.Request.Method;
            var endpoint = context.Request.Path;
            var parameters = context.Request.QueryString.HasValue ? context.Request.QueryString.Value : string.Empty;
            var userId = 0;
            var responseData = string.Empty;
            var processName = string.Empty;
            var processStatus = "Pendiente";
            var endDate = DateTime.UtcNow;
            var innerError = string.Empty;

            var originalBodyStream = context.Response.Body;
            using (var responseBody = new MemoryStream())
            {
                context.Response.Body = responseBody;

                await _next(context);

                endDate = DateTime.UtcNow;

                responseBody.Seek(0, SeekOrigin.Begin);
                responseData = await new StreamReader(responseBody).ReadToEndAsync();
                responseBody.Seek(0, SeekOrigin.Begin);

                await responseBody.CopyToAsync(originalBodyStream);
            }

            processStatus = "Éxito";

            using (var scope = _scopeFactory.CreateScope())
            {
                var logRepository = scope.ServiceProvider.GetRequiredService<LogRepository>();

                var log = new ApplicationLog
                (
                    userId: userId,
                    ipAddress: ipAddress,
                    startDate: startDate,
                    processName: processName,
                    httpMethod: httpMethod,
                    endpoint: endpoint,
                    parameters: parameters,
                    responseData: responseData,
                    processStatus: processStatus,
                    endDate: endDate,
                    innerError: innerError
                );

                log.UserId = Convert.ToInt32(context.Items["User"]);
                log.Parameters = context.Items["Parameters"]?.ToString() ?? string.Empty;
                log.ProcessName = context.Items["ProcessName"]?.ToString() ?? string.Empty;
                log.ProcessStatus = context.Items["ProcessStatus"]?.ToString() ?? string.Empty;
                log.InnerError = context.Items["InnerError"]?.ToString() ?? string.Empty;


                try
                {
                    var isSuccess = await logRepository.InsertLogAsync(log);
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"| No se pudo guardar el log en la bd, debido a: {ex.Message}");
                }
            }
        }
    }
}
