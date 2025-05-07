using Microsoft.AspNetCore.Mvc;
using UsersApi.Filters;
using UsersApi.Models;
using UsersApi.Services;

namespace UsersApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProfileController : ControllerBase
    {
        private readonly ProfileService _profileService;
        public ProfileController(ProfileService profileService)
        {
            _profileService = profileService;
        }

        [HttpGet("get-all")]
        [ValidateJwt(true)]
        [RequiredGrant(700)]
        public async Task<IActionResult> GetAllProfilesAsync()
        {
            Request.HttpContext.Items["ProcessName"] = "Consultar Perfiles";
            var response = await _profileService.GetAllProfilesAsync();
            return StatusCode(response.StatusCode, response);
        }

        [HttpGet("get")]
        [ValidateJwt(true)]
        [RequiredGrant(700)]
        public async Task<IActionResult> GetProfileByIDAsync([FromQuery] GetProfileRequest getProfileRequest)
        {
            Request.HttpContext.Items["ProcessName"] = "Consultar Perfil";
            Request.HttpContext.Items["Parameters"] = getProfileRequest.ToString();
            var response = await _profileService.GetProfileAsync(getProfileRequest);
            return StatusCode(response.StatusCode, response);
        }

        [HttpPost("create")]
        [ValidateJwt(true)]
        [RequiredGrant(701)]
        public async Task<IActionResult> CreateProfileAsync([FromBody] CreateProfileRequest createProfileRequest)
        {
            Request.HttpContext.Items["ProcessName"] = "Crear Perfil";
            Request.HttpContext.Items["Parameters"] = createProfileRequest.ToString();

            var user = Request.HttpContext.Items["User"] as int? ?? 0;

            var response = await _profileService.CreateProfileAsync(createProfileRequest, user);
            return StatusCode(response.StatusCode, response);
        }

        [HttpPost("update")]
        [ValidateJwt(true)]
        [RequiredGrant(702)]
        public async Task<IActionResult> UpdateProfileAsync([FromBody] UpdateProfileRequest updateProfileRequest)
        {
            Request.HttpContext.Items["ProcessName"] = "Actualizar Perfil";
            Request.HttpContext.Items["Parameters"] = updateProfileRequest.ToString();

            var user = Request.HttpContext.Items["User"] as int? ?? 0;

            var response = await _profileService.UpdateProfileAsync(updateProfileRequest, user);
            return StatusCode(response.StatusCode, response);
        }

        [HttpPost("delete")]
        [ValidateJwt(true)]
        [RequiredGrant(703)]
        public async Task<IActionResult> DropProfileAsync([FromBody] DeleteProfileRequest deleteProfileRequest)
        {
            Request.HttpContext.Items["ProcessName"] = "Eliminar Perfil";
            Request.HttpContext.Items["Parameters"] = deleteProfileRequest.ToString();

            var user = Request.HttpContext.Items["User"] as int? ?? 0;

            var response = await _profileService.DeleteProfileAsync(deleteProfileRequest);
            return StatusCode(response.StatusCode, response);
        }
    }
}
