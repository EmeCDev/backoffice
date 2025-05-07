using Microsoft.AspNetCore.Mvc;
using UsersApi.Filters;
using UsersApi.Models;
using UsersApi.Services;

namespace UsersApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LogController : ControllerBase
    {
        private readonly LogService _logService;
        public LogController(LogService logService)
        {
            _logService = logService;
        }

        [HttpGet("get-all")]
        [ValidateJwt(true)]
        [RequiredGrant(800)]
        public async Task<IActionResult> GetAllLogDetailsAsync([FromQuery] GetLogsRequest getLogsRequest)
        {
            Request.HttpContext.Items["ProcessName"] = "Consultar Logs";

            var response = await _logService.GetAllLogsDetailsAsync(getLogsRequest);
            return StatusCode(response.StatusCode, response);
        }
    }
}