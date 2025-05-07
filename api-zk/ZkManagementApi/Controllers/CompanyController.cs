using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using ZkManagementApi.Filters;
using ZkManagementApi.Models;
using ZkManagementApi.Services;

namespace ZkManagementApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CompanyController : ControllerBase
    {
        private readonly CompanyService _companyService;

        public CompanyController(CompanyService companyService)
        {
            _companyService = companyService;
        }

        [HttpGet("get-info")]
        [ValidateJwt(true)]
        [RequiredGrant(200)]
        public async Task<IActionResult> GetCompaniesAsync([FromQuery] GetCompanyInfoRequest getCompanyInfoRequest)
        {
            Request.HttpContext.Items["Parameters"] = getCompanyInfoRequest.ToString();
            Request.HttpContext.Items["ProcessName"] = "Consultar Clientes";

            var response = await _companyService.GetCompaniesAsync(getCompanyInfoRequest);
            return StatusCode(response.StatusCode, response);
        }

        [HttpGet("get-all")]
        [ValidateJwt(true)]
        [RequiredGrant(501)]
        public async Task<IActionResult> GetZkCompaniesAsync([FromQuery] GetCompanyRequest getCompanyRequest) 
        {
            Request.HttpContext.Items["Parameters"] = getCompanyRequest.ToString();
            Request.HttpContext.Items["ProcessName"] = "Consultar Clientes Zk";

            var response = await _companyService.GetZkCompaniesAsync(getCompanyRequest);
            return StatusCode(response.StatusCode, response);
        }

        [HttpPost("update-visibility")]
        [ValidateJwt(true)]
        [RequiredGrant(900)]
        public async Task<IActionResult> UpdateVisibilityAsync([FromBody] UpdateVisibilityRequest updateVisibilityRequest)
        {
            Request.HttpContext.Items["Parameters"] = updateVisibilityRequest.ToString();
            Request.HttpContext.Items["ProcessName"] = "Actualizar Visibilidad de Empresas";

            var response = await _companyService.UpdateVisibilityAsync(updateVisibilityRequest);
            return StatusCode(response.StatusCode, response);
        }
    }
}
