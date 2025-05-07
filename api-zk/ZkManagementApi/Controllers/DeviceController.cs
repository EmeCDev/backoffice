using Microsoft.AspNetCore.Mvc;
using ZkManagementApi.Filters;
using ZkManagementApi.Models;
using ZkManagementApi.Services;

namespace ZkManagementApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class DeviceController : ControllerBase
    {
        private readonly DeviceService _deviceService;
        public DeviceController(DeviceService deviceService)
        {
            _deviceService = deviceService;
        }

        [HttpGet("get-zk")]
        [ValidateJwt(true)]
        [RequiredGrant(500)]
        public async Task<IActionResult> GetZkDevicesAsync([FromQuery] GetDeviceRequest getDeviceRequest)
        {
            Request.HttpContext.Items["Parameters"] = getDeviceRequest.ToString();
            Request.HttpContext.Items["ProcessName"] = "Consultar Equipos Zk";

            var response = await _deviceService.GetZkDevicesAsync(getDeviceRequest);
            return StatusCode(response.StatusCode, response);
        }

        [HttpPost("bulk-send")]
        [ValidateJwt(true)]
        [RequiredGrant(501)]
        public async Task<IActionResult> SendProfileAsync([FromBody] SendProfileRequest sendProfileRequest)
        {
            Request.HttpContext.Items["Parameters"] = sendProfileRequest.ToString();
            Request.HttpContext.Items["ProcessName"] = "Carga Masiva Perfiles Acceso";

            var response = await _deviceService.SendProfileAsync(sendProfileRequest);
            return StatusCode(response.StatusCode, response);
        }

        [HttpGet("get-access-profiles")]
        [ValidateJwt(true)]
        [RequiredGrant(501)]
        public async Task<IActionResult> GetAccessProfilesAsync([FromQuery] GetAccessProfilesRequest getAccessProfilesRequest)
        {
            Request.HttpContext.Items["Parameters"] = getAccessProfilesRequest.ToString();
            Request.HttpContext.Items["ProcessName"] = "Consultar Perfiles Acceso";

            var response = await _deviceService.GetAccessProfilesAsync(getAccessProfilesRequest);
            return StatusCode(response.StatusCode, response);
        }

        [HttpGet("get-all")]
        [ValidateJwt(true)]
        [RequiredGrant(300)]
        public async Task<IActionResult> GetDevicesAsync([FromQuery] GetDeviceRequest getDeviceRequest)
        {
            Request.HttpContext.Items["Parameters"] = getDeviceRequest.ToString();
            Request.HttpContext.Items["ProcessName"] = "Consultar Equipos";

            var response = await _deviceService.GetDevicesAsync(getDeviceRequest);
            return StatusCode(response.StatusCode, response);
        }
        
        [HttpPost("send-user")]
        [ValidateJwt(true)]
        [RequiredGrant(500)]
        public async Task<IActionResult> SendUserAsync([FromBody] SendUserRequest sendUserRequest)
        {
            Request.HttpContext.Items["Parameters"] = sendUserRequest.ToString();
            Request.HttpContext.Items["ProcessName"] = "Enviar Usuario Zk";

            var response = await _deviceService.SendUserToDeviceAsync(sendUserRequest);
            return StatusCode(response.StatusCode, response);
        }

        [HttpPost("send-user-ripley")]
        [ValidateJwt(true)]
        [RequiredGrant(500)]
        public async Task<IActionResult> SendUserRpAsync([FromBody] SendUserRequest sendUserRequest)
        {
            Request.HttpContext.Items["Parameters"] = sendUserRequest.ToString();
            Request.HttpContext.Items["ProcessName"] = "Enviar Usuario Zk Ripley";

            var response = await _deviceService.SendUserToDeviceRpAsync(sendUserRequest);
            return StatusCode(response.StatusCode, response);
        }

        [HttpPost("send-user-arcos-dorados")]
        [ValidateJwt(true)]
        [RequiredGrant(500)]
        public async Task<IActionResult> SendUserAdAsync([FromBody] SendUserRequest sendUserRequest)
        {
            Request.HttpContext.Items["Parameters"] = sendUserRequest.ToString();
            Request.HttpContext.Items["ProcessName"] = "Enviar Usuario Zk Arcos Dorados";

            var response = await _deviceService.SendUserToDeviceAdAsync(sendUserRequest);
            return StatusCode(response.StatusCode, response);
        }
    }
}