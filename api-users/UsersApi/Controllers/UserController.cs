using Azure;
using Microsoft.AspNetCore.Mvc;
using UsersApi.Filters;
using UsersApi.Helpers;
using UsersApi.Models;
using UsersApi.Services;

namespace UsersApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly UserService _userService;
        private readonly JwtHelper _jwtHelper;

        public UserController(UserService userService, JwtHelper jwtHelper) 
        {
            _userService = userService;
            _jwtHelper = jwtHelper;
        }

        [HttpPost("authenticate")]
        public async Task<IActionResult> AuthenticateAsync([FromBody] AuthenticationRequest authenticationRequest) 
        {
            Request.HttpContext.Items["ProcessName"] = "Iniciar Sesión";
            Request.HttpContext.Items["Parameters"] = authenticationRequest.ToString();
            var response = await _userService.AuthenticateAsync(authenticationRequest.Email, authenticationRequest.Password);

            if (response.IsSuccess)
            {
                var token = _userService.GetJwtToken(response.Data);

                var cookieOptions = new CookieOptions
                {
                    HttpOnly = true, 
                    Secure = true,   
                    SameSite = SameSiteMode.None,
                    Expires = DateTime.Now.AddMinutes(30),
                    Path = "/"
                };

                Response.Cookies.Append("AuthCookie", token, cookieOptions);
                
                HttpContext.Items["User"] = response.Data.Id;
            }

            return StatusCode(response.StatusCode, response);
        }

        [HttpPost("logout")]
        public async Task<IActionResult> Logout()
        {
            Request.HttpContext.Items["ProcessName"] = "Cerrar Sesión";
            Request.HttpContext.Items["User"] = _jwtHelper.GetUserIdFromJwt(Request.Cookies["AuthCookie"]?.ToString());
            Request.HttpContext.Items["Parameters"] = Request.Cookies["AuthCookie"]?.ToString();         

            var cookieOptions = new CookieOptions
            {
                HttpOnly = true,
                Secure = true,
                SameSite = SameSiteMode.None,
                Expires = DateTime.Now.AddDays(-30),
                Path = "/"
            };

            Response.Cookies.Append("AuthCookie", "", cookieOptions);

            var response = await _userService.LogoutAsync(Request.Cookies["AuthCookie"]?.ToString());

            return StatusCode(response.StatusCode, response);
        }


        [HttpGet("get-all")]
        [ValidateJwt(true)]
        [RequiredGrant(600)]
        public async Task<IActionResult> GetAllUserDetailsAsync([FromQuery] GetUserRequest getUserRequest)
        {
            Request.HttpContext.Items["Parameters"] = getUserRequest.ToString();
            Request.HttpContext.Items["ProcessName"] = "Consultar Usuarios";

            var response = await _userService.GetAllUsersDetailsAsync(getUserRequest);
            return StatusCode(response.StatusCode, response);
        }

        [HttpPost("create")]
        [ValidateJwt(true)]
        [RequiredGrant(601)]
        public async Task<IActionResult> CreateAsync([FromBody] CreateUserRequest createUserRequest)
        {
            Request.HttpContext.Items["Parameters"] = createUserRequest.ToString();
            Request.HttpContext.Items["ProcessName"] = "Crear Usuario";
            int user = Request.HttpContext.Items["User"] as int? ?? 0;

            var response = await _userService.CreateUserAsync(createUserRequest, user);
            return StatusCode(response.StatusCode, response);
        }

        [HttpPost("update")]
        [ValidateJwt(true)]
        [RequiredGrant(602)]
        public async Task<IActionResult> UpdateAsync([FromBody] UpdateUserRequest updateUserRequest)
        {
            Request.HttpContext.Items["Parameters"] = updateUserRequest.ToString();
            Request.HttpContext.Items["ProcessName"] = "Actualizar Usuario";
            var user = Request.HttpContext.Items["User"] as int? ?? 0;

            var response = await _userService.UpdateUserAsync(updateUserRequest, user);
            return StatusCode(response.StatusCode, response);
        }
    }
}