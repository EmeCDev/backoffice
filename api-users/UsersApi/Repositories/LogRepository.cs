using Microsoft.Data.SqlClient;
using System.Data;
using UsersApi.Models;
using UsersApi.Helpers;

namespace UsersApi.Repositories
{
    public class LogRepository
    {
        private readonly DbConnectionHelper _dbConnection;
        private readonly IHostEnvironment _hostEnvironment;
        public LogRepository(DbConnectionHelper dbConnection, IHostEnvironment hostEnvironment)
        {
            _dbConnection = dbConnection;
            _hostEnvironment = hostEnvironment;
        }

        public async Task<List<GetLogsResult>> GetAllLogsDetailsAsync(GetLogsRequest logsRequest)
        {
            try
            {
                SqlParameter[] parameters =
                [
                    new SqlParameter("@StartDate", SqlDbType.Date) { Value = logsRequest.StartDate },
                    new SqlParameter("@EndDate", SqlDbType.Date) { Value = logsRequest.EndDate },
                    new SqlParameter("@Email", SqlDbType.NVarChar, 255) { Value = logsRequest.Email },
                    new SqlParameter("@ProcessName", SqlDbType.NVarChar, 255) { Value = logsRequest.ProcessName },
                ];

                Console.WriteLine(logsRequest.StartDate);
                Console.WriteLine(logsRequest.EndDate);

                DataTable result = await _dbConnection.ExecuteWithDataAsync("SP_SEL_APPLICATION_LOGS", parameters);

                List<GetLogsResult> logs = new List<GetLogsResult>();

                foreach (DataRow row in result.Rows)
                {
                    GetLogsResult log = new GetLogsResult(
                        email: row["Email"].ToString(),
                        startDate: row["StartDate"] != DBNull.Value ? Convert.ToDateTime(row["StartDate"]) : DateTime.MinValue,
                        endDate: row["EndDate"] != DBNull.Value ? Convert.ToDateTime(row["EndDate"]) : DateTime.MinValue,
                        processName: row["ProcessName"].ToString() ?? string.Empty,
                        parameters: row["Parameters"].ToString() ?? string.Empty,
                        responseData: row["ResponseData"].ToString() ?? string.Empty
                    );

                    logs.Add(log);
                }

                return logs;
            }
            catch (ArgumentException ex)
            {
                throw;
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public async Task<bool> SaveLogToDbAsync(ApplicationLog log)
        {
            
                SqlParameter[] parameters = 
                {
                    new SqlParameter("@UserId", SqlDbType.Int) { Value = (object)log.UserId ?? DBNull.Value },
                    new SqlParameter("@IpAddress", SqlDbType.NVarChar, 50) { Value = log.IpAddress ?? (object)DBNull.Value },
                    new SqlParameter("@StartDate", SqlDbType.DateTime) { Value = log.StartDate },
                    new SqlParameter("@ProcessName", SqlDbType.NVarChar, 255) { Value = log.ProcessName },
                    new SqlParameter("@HttpMethod", SqlDbType.NVarChar, 10) { Value = log.HttpMethod ?? (object)DBNull.Value },
                    new SqlParameter("@Endpoint", SqlDbType.NVarChar, 255) { Value = log.Endpoint ?? (object)DBNull.Value },
                    new SqlParameter("@Parameters", SqlDbType.NVarChar) { Value = log.Parameters ?? (object)DBNull.Value },
                    new SqlParameter("@ResponseData", SqlDbType.NVarChar) { Value = log.ResponseData ?? (object)DBNull.Value },
                    new SqlParameter("@ProcessStatus", SqlDbType.NVarChar, 50) { Value = log.ProcessStatus ?? (object)DBNull.Value },
                    new SqlParameter("@EndDate", SqlDbType.DateTime) { Value = log.EndDate },
                    new SqlParameter("@InnerError", SqlDbType.NVarChar) { Value = log.InnerError ?? (object)DBNull.Value }
                };

                
                int affectedRows = await _dbConnection.ExecuteWithoutDataAsync("SP_INS_APPLICATION_LOG", parameters);

                if (affectedRows <= 0)
                    return false;

                return true;
            
        }

        public async Task<bool> SaveLogToFile(ApplicationLog log) 
        {
           
                string directoryPath = Path.Combine(_hostEnvironment.ContentRootPath, "logs");
                string dateString = DateTime.Now.ToString("yyyyyMMdd");
                string filePath = Path.Combine(directoryPath, $"log_{dateString}.txt");

                Directory.CreateDirectory(directoryPath);

                await File.AppendAllTextAsync(filePath, log.ToString() + Environment.NewLine);

                return true;
        }
    }
}