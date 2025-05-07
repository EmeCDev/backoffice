using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using System.Net;
using ClientLicenseApi.Models;
using System.Security.Authentication;

namespace ClientLicenseApi.Filters
{
    public class ExceptionFilter : IExceptionFilter
    {
        public void OnException(ExceptionContext context)
        {
            var exception = context.Exception;
            int statusCode;
            string message;

            switch (exception)
            {
                case AuthenticationException:
                    statusCode = (int)HttpStatusCode.Unauthorized;
                    message = exception.InnerException?.Message ?? exception.Message;
                    context.HttpContext.Items["ProcessStatus"] = "No se ha encontrado un token valido";
                    break;

                case UnauthorizedAccessException:
                    statusCode = (int)HttpStatusCode.Forbidden;
                    message = exception.InnerException?.Message ?? exception.Message;
                    context.HttpContext.Items["ProcessStatus"] = "Acceso a recurso no autorizado";
                    break;

                case ArgumentException:
                    statusCode = (int)HttpStatusCode.BadRequest;
                    message = exception.InnerException?.Message ?? exception.Message;
                    context.HttpContext.Items["ProcessStatus"] = "Error de usuario";
                    break;

                default:
                    statusCode = (int)HttpStatusCode.InternalServerError;
                    message = "Ha ocurrido un error interno en el servidor. " + exception.Message;
                    context.HttpContext.Items["ProcessStatus"] = "Error interno";
                    context.HttpContext.Items["InnerError"] = exception.Message;
                    break;
            }

            var response = new ApiResponse<string>(false, statusCode, message);

            context.Result = new JsonResult(response)
            {
                StatusCode = statusCode
            };
        }
    }
}