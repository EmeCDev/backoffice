using System.Security.Authentication;
using Microsoft.AspNetCore.Mvc.Filters;
using UsersApi.Helpers;

namespace UsersApi.Filters
{
    public class ValidateJwtFilter : IActionFilter
    {
        private readonly JwtHelper _jwtHelper;

        public ValidateJwtFilter(JwtHelper jwtHelper)
        {
            _jwtHelper = jwtHelper;
        }

        public void OnActionExecuting(ActionExecutingContext context)
        {
            var validateJwtAttribute = context.ActionDescriptor.EndpointMetadata
                .OfType<ValidateJwtAttribute>()
                .FirstOrDefault();

            if (validateJwtAttribute == null)
            {
                return;
            }

            var validateJwt = validateJwtAttribute.ValidateJwt;

            if (!validateJwt) 
            {
                return;
            }

            var token = context.HttpContext.Request.Cookies["AuthCookie"] ?? string.Empty;

            if (string.IsNullOrWhiteSpace(token))
            {
                throw new AuthenticationException("No se encontró un token de acceso valido.");
            }

            var isValidToken = _jwtHelper.ValidateJwt(token);

            if (!isValidToken)
            {
                throw new AuthenticationException("No se encontró un token de acceso valido.");
            }

            context.HttpContext.Items["User"] = _jwtHelper.GetUserIdFromJwt(token);

            return;
        }

        public void OnActionExecuted(ActionExecutedContext context)
        {
            // Requerido por IActionFilter, no se necesita implementar nada aquí
        }
    }
}