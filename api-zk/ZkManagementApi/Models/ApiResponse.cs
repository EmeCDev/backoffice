using System.Text.Json.Serialization;

namespace ZkManagementApi.Models
{
    public class ApiResponse<T>
    {
        [JsonIgnore]
        public bool IsSuccess { get; set; }
        public int StatusCode { get; set; }
        public string Message { get; set; }
        public T Data { get; set; }

        public ApiResponse(bool isSuccess, int statusCode, string message, T data = default)
        {
            IsSuccess = isSuccess;
            StatusCode = statusCode;
            Message = message;
            Data = data;
        }

        public override string ToString()
        {
            var dataString = Data != null ? Data.ToString() : "null";
            return $"{{'IsSuccess' : '{IsSuccess}', 'StatusCode' : '{StatusCode}', 'Message' : '{Message}', 'Data' : {dataString}}}";
        }

    }
}