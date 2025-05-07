using System;

namespace ZkManagementApi.Filters
{
    [AttributeUsage(AttributeTargets.Method | AttributeTargets.Class, AllowMultiple = false)]
    public class RequiredGrantAttribute : Attribute
    {
        public int RequiredGrant { get; }

        public RequiredGrantAttribute(int requiredGrant)
        {
            RequiredGrant = requiredGrant;
        }
    }
}
