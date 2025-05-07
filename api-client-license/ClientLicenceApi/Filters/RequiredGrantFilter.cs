using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using ClientLicenseApi.Helpers;
using ClientLicenseApi.Models;
using System.Security.Authentication;

namespace ClientLicenseApi.Filters
{
    public class RequiredGrantFilter : IActionFilter
    {
        private readonly JwtHelper _jwtHelper;

        public RequiredGrantFilter(JwtHelper jwtHelper) 
        {
            _jwtHelper = jwtHelper;
        }

        public void OnActionExecuting(ActionExecutingContext context)
        {
            var requiredGrantAttribute = context.ActionDescriptor.EndpointMetadata
                .OfType<RequiredGrantAttribute>()
                .FirstOrDefault();

            if (requiredGrantAttribute == null)
            {
                return;
            }

            var requiredGrant = requiredGrantAttribute.RequiredGrant;
            var token = context.HttpContext.Request.Cookies["AuthCookie"] ?? string.Empty;

            var grants = _jwtHelper.GetGrantsFromJwt(token);

            bool isGrantInGrants = grants.Contains(requiredGrant);

            if (!isGrantInGrants)
            {
                throw new UnauthorizedAccessException("No tiene acceso al recurso solicitado.");
            }
        }

        public void OnActionExecuted(ActionExecutedContext context)
        {
            // Requerido por IActionFilter, no se necesita implementar nada aquí
            }
    }
}
