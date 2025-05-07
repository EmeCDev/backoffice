using System.Data;
using ClientLicenseApi.Helpers;
using ClientLicenseApi.Models;
using Microsoft.Data.SqlClient;

namespace ClientLicenseApi.Repositories
{
    public class LicenseRepository
    {
        private readonly DbConnectionHelper _dbConnectionHelper;
        public LicenseRepository(DbConnectionHelper dbConnectionHelper) 
        {
            _dbConnectionHelper = dbConnectionHelper;
        }

        public async Task<ClientLicenseData> GetLicenseDetailsAsync(GetLicenseRequest getLicenseRequest)
        {
            try
            {
                var parametros = new SqlParameter[]
                {
                    new SqlParameter("@Server", getLicenseRequest.Server),
                    new SqlParameter("@Database", getLicenseRequest.Database)
                };

                DataTable licenseDataDt = await _dbConnectionHelper.ExecuteWithDataAsync("SP_SEL_CLIENT_LICENSE", parametros);

                if (licenseDataDt.Rows.Count <= 0)
                    return null;

                ClientLicenseData licenseData = new ClientLicenseData(
                        expirationDate: licenseDataDt.Rows[0]["ExpirationDate"]?.ToString(),
                        workersCount: licenseDataDt.Rows[0]["WorkersCount"]?.ToString()
                    );

                return licenseData;
            }
            catch
            {
                throw;
            }
        }

        public async Task<ClientLicenseData> UpdateLicenseDetailsAsync(UpdateLicenseRequest updateLicenseRequest)
        {
            try
            {
                var parametros = new SqlParameter[]
                {
                    new SqlParameter("@Server", updateLicenseRequest.Server),
                    new SqlParameter("@Database", updateLicenseRequest.Database),
                    new SqlParameter("@NewExpirationDate", updateLicenseRequest.NewExpirationDate),
                    new SqlParameter("@NewWorkersCount", updateLicenseRequest.NewWorkersCount)
                };

                DataTable licenseDataDt = await _dbConnectionHelper.ExecuteWithDataAsync("SP_UPD_CLIENT_LICENSE", parametros);

                if (licenseDataDt.Rows.Count <= 0)
                    return null;

                ClientLicenseData licenseData = new ClientLicenseData(
                        expirationDate: licenseDataDt.Rows[0]["ExpirationDate"]?.ToString(),
                        workersCount: licenseDataDt.Rows[0]["WorkersCount"]?.ToString()
                    );

                return licenseData;
            }
            catch
            {
                throw;
            }
        }
    }
}
