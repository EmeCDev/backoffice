using System;

namespace ZkManagementApi.Filters
{
    [AttributeUsage(AttributeTargets.Method | AttributeTargets.Class, AllowMultiple = false)]
    public class ValidateJwtAttribute : Attribute
    {
        public bool ValidateJwt { get; }

        public ValidateJwtAttribute(bool validateJwt)
        {
            ValidateJwt = validateJwt;
        }
    }
}