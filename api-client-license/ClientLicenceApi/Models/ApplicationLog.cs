namespace ClientLicenseApi.Models
{
    public class ApplicationLog
    {
        public int UserId { get; set; }
        public string IpAddress { get; set; }
        public DateTime StartDate { get; set; }
        public string ProcessName { get; set; }
        public string HttpMethod { get; set; }
        public string Endpoint { get; set; }
        public string Parameters { get; set; }
        public string ResponseData { get; set; }
        public string ProcessStatus { get; set; }
        public DateTime EndDate { get; set; }
        public string InnerError { get; set; }

        public ApplicationLog(int userId, string ipAddress, DateTime startDate, string processName, string httpMethod, string endpoint, string parameters, string responseData, string processStatus, DateTime endDate, string innerError)
        {
            UserId = userId;
            IpAddress = ipAddress;
            StartDate = startDate;
            ProcessName = processName;
            HttpMethod = httpMethod;
            Endpoint = endpoint;
            Parameters = parameters;
            ResponseData = responseData;
            ProcessStatus = processStatus;
            EndDate = endDate;
            InnerError = innerError;
        }

        public ApplicationLog() { }

        public override string ToString()
        {
            return $"UserId: {UserId}, " +
                   $"IpAddress: {IpAddress ?? "null"}, " +
                   $"StartDate: {StartDate}, " +
                   $"ProcessName: {ProcessName ?? "null"}, " +
                   $"HttpMethod: {HttpMethod ?? "null"}, " +
                   $"Endpoint: {Endpoint ?? "null"}, " +
                   $"Parameters: {Parameters ?? "null"}, " +
                   $"ResponseData: {ResponseData ?? "null"}, " +
                   $"ProcessStatus: {ProcessStatus ?? "null"}, " +
                   $"EndDate: {EndDate}, " +
                   $"InnerError: {InnerError ?? "null"}";
        }
    }
}