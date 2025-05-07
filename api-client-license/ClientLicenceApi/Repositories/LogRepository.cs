using Microsoft.Data.SqlClient;
using System.Data;
using ClientLicenseApi.Helpers;
using ClientLicenseApi.Models;

namespace ClientLicenseApi.Repositories
{
    public class LogRepository
    {
        private readonly DbConnectionHelper _dbConnection;
        public LogRepository(DbConnectionHelper dbConnection)
        {
            _dbConnection = dbConnection;
        }

        public async Task<bool> InsertLogAsync(ApplicationLog log)
        {
            try
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

                return affectedRows <= 0;
            }
            catch
            {
                throw;
            }
        }
    }
}