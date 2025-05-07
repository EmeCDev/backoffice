namespace UsersApi.Models
{
    public class GetLogsResult
    {
        public string? Email { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public string? ProcessName { get; set; }
        public string? Parameters { get; set; }
        public string? ResponseData { get; set; }

        public GetLogsResult() { }
        
        public GetLogsResult(string? email, DateTime? startDate, DateTime? endDate, string? processName, string? parameters, string? responseData)
        {
            Email = email;
            StartDate = startDate;
            EndDate = endDate;
            ProcessName = processName;
            Parameters = parameters;
            ResponseData = responseData;
        }
    }
}
