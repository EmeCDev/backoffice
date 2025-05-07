using ClientLicenseApi.Filters;
using ClientLicenseApi.Models;
using ClientLicenseApi.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace ClientLicenseApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LicenseController : ControllerBase
    {
        private readonly LicenseService _licenseService;
        public LicenseController(LicenseService licenseService)
        {
            _licenseService = licenseService;
        }

        [HttpGet("get-data")]
        [ValidateJwt(true)]
        [RequiredGrant(401)]
        public async Task<IActionResult> GetClientLicenseAsync([FromQuery] GetLicenseRequest getLicenseRequest)
        {
            Request.HttpContext.Items["ProcessName"] = "Consultar Licencia Cliente";

            var response = await _licenseService.GetLicenceDetailsAsync(getLicenseRequest);
            return StatusCode(response.StatusCode, response);
        }

        [HttpPost("update")]
        [ValidateJwt(true)]
        [RequiredGrant(400)]
        public async Task<IActionResult> UpdateClientLicenseAsync([FromBody] UpdateLicenseRequest updateLicenseRequest)
        {
            Request.HttpContext.Items["ProcessName"] = "Actualizar Licencia Cliente";
            Request.HttpContext.Items["Parameters"] = updateLicenseRequest.ToString();

            var response = await _licenseService.UpdateClientLicenseAsync(updateLicenseRequest);
            return StatusCode(response.StatusCode, response);
        }
    }
}
