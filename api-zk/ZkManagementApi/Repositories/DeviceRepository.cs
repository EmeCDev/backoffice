using Microsoft.Data.SqlClient;
using System.Data;
using ZkManagementApi.Helpers;
using ZkManagementApi.Models;

namespace ZkManagementApi.Repositories
{
    public class DeviceRepository
    {
        private readonly DbConnectionHelper _dbConnectionHelper;
        public DeviceRepository(DbConnectionHelper dbConnectionHelper)
        {
            _dbConnectionHelper = dbConnectionHelper;
        }

        public async Task<List<NewDeviceInfo>> GetDevicesAsync(GetDeviceRequest getDeviceRequest)
        {
            try
            {
                var parametros = new SqlParameter[]
                {
                    new SqlParameter("@Server", getDeviceRequest.Server),
                    new SqlParameter("@Database", getDeviceRequest.Database),
                    new SqlParameter("@SerialNumber", getDeviceRequest.SerialNumber)
                };

                List<NewDeviceInfo> devicesList = new List<NewDeviceInfo>();

                DataTable devicesDt = await _dbConnectionHelper.ExecuteWithDataAsync("SP_SEL_DEVICE_INFO", parametros);

                foreach (DataRow row in devicesDt.Rows)
                {

                    NewDeviceInfo device = new NewDeviceInfo(
                        description: string.IsNullOrWhiteSpace(row["Description"]?.ToString()) ? null : row["Description"].ToString(),
                        location: string.IsNullOrWhiteSpace(row["Location"]?.ToString()) ? null : row["Location"].ToString(),
                        model: string.IsNullOrWhiteSpace(row["Model"]?.ToString()) ? null : row["Model"].ToString(),
                        function: string.IsNullOrWhiteSpace(row["Function"]?.ToString()) ? null : row["Function"].ToString(),
                        serialNumber: string.IsNullOrWhiteSpace(row["SerialNumber"]?.ToString()) ? null : row["SerialNumber"].ToString(),
                        active: string.IsNullOrWhiteSpace(row["Active"]?.ToString()) ? null : row["Active"].ToString(),
                        lastConnectionDate: string.IsNullOrWhiteSpace(row["LastConnection"]?.ToString()) ? null : row["LastConnection"].ToString(),
                        disconnectionTime: Convert.ToInt32(row["DisconnectionTimeHrs"]?.ToString()) 
                    );


                    devicesList.Add(device);
                }

                return devicesList;
            }
            catch
            {
                throw;
            }
        }

        public async Task<List<AccessProfile>> GetAccessProfilesAsync(GetAccessProfilesRequest getAccessProfilesRequest)
        {
            try
            {
                var parametros = new SqlParameter[]
                {
                    new SqlParameter("@Server", getAccessProfilesRequest.Server),
                    new SqlParameter("@Database", getAccessProfilesRequest.Database)
                };

                List<AccessProfile> accessProfilesList = new List<AccessProfile>();

                DataTable profilesDt = await _dbConnectionHelper.ExecuteWithDataAsync("SP_SEL_ACCESS_PROFILES", parametros);

                foreach (DataRow row in profilesDt.Rows)
                {

                    AccessProfile accessProfile = new AccessProfile(
                        id: Convert.ToInt32(row["id_perf"]),
                        description: string.IsNullOrWhiteSpace(row["descripcion_perf"]?.ToString()) ? null : row["descripcion_perf"].ToString()
                    );


                    accessProfilesList.Add(accessProfile);
                }

                return accessProfilesList;
            }
            catch
            {
                throw;
            }
        }

        public async Task<bool> SendProfileAsync(SendProfileRequest sendProfileRequest)
        {
            try
            {
                var parametros = new SqlParameter[]
                {
                    new SqlParameter("@Server", sendProfileRequest.Server),
                    new SqlParameter("@Database", sendProfileRequest.Database),
                    new SqlParameter("@ProfileId", sendProfileRequest.ProfileId),
                };

                DataTable sendResultDt = await _dbConnectionHelper.ExecuteWithDataAsync("SP_INS_ACCESS_PROFILES", parametros);

                if (sendResultDt.Rows.Count <= 0)
                    return false;


                bool sendResult = Convert.ToBoolean(sendResultDt.Rows[0]["Result"]);

                return sendResult;
            }
            catch
            {
                throw;
            }
        }

        public async Task<List<NewDeviceInfo>> GetZkDevicesAsync(GetDeviceRequest getDeviceRequest)
        {
            try
            {
                var parametros = new SqlParameter[]
                {
                    new SqlParameter("@Server", getDeviceRequest.Server),
                    new SqlParameter("@Database", getDeviceRequest.Database),
                    new SqlParameter("@SerialNumber", getDeviceRequest.SerialNumber)
                };

                List<NewDeviceInfo> devicesList = new List<NewDeviceInfo>();

                DataTable devicesDt = await _dbConnectionHelper.ExecuteWithDataAsync("SP_SEL_ZK_DEVICE_INFO", parametros);

                foreach (DataRow row in devicesDt.Rows)
                {

                    NewDeviceInfo device = new NewDeviceInfo(
                        description: string.IsNullOrWhiteSpace(row["Description"]?.ToString()) ? null : row["Description"].ToString(),
                        location: string.IsNullOrWhiteSpace(row["Location"]?.ToString()) ? null : row["Location"].ToString(),
                        model: string.IsNullOrWhiteSpace(row["Model"]?.ToString()) ? null : row["Model"].ToString(),
                        function: string.IsNullOrWhiteSpace(row["Function"]?.ToString()) ? null : row["Function"].ToString(),
                        serialNumber: string.IsNullOrWhiteSpace(row["SerialNumber"]?.ToString()) ? null : row["SerialNumber"].ToString(),
                        active: string.IsNullOrWhiteSpace(row["Active"]?.ToString()) ? null : row["Active"].ToString(),
                        lastConnectionDate: string.IsNullOrWhiteSpace(row["LastConnection"]?.ToString()) ? null : row["LastConnection"].ToString()
                    );


                    devicesList.Add(device);
                }

                return devicesList;
            }
            catch
            {
                throw;
            }
        }

        public async Task<bool> SendUserToDeviceAsync(SendUserRequest sendUserRequest)
        {
            try
            {
                var parametros = new[]
                {
                    new SqlParameter("@ServerId", SqlDbType.Int) { Value = sendUserRequest.ServerId },
                    new SqlParameter("@Pin", SqlDbType.Int) { Value = sendUserRequest.Pin },
                    new SqlParameter("@Name", SqlDbType.NVarChar, 255) { Value = sendUserRequest.Name },
                    new SqlParameter("@Privilege", SqlDbType.Int) { Value = sendUserRequest.Privilege },
                    new SqlParameter("@Password", SqlDbType.NVarChar, 255) { Value = sendUserRequest.Password },
                    new SqlParameter("@Card", SqlDbType.Int) { Value = sendUserRequest.Card },
                    new SqlParameter("@DevicesSerialNumbers", SqlDbType.NVarChar) { Value = sendUserRequest.SerialNumbersToString() }
                };

                int rowsAffected = await _dbConnectionHelper.ExecuteWithoutDataAsync("SP_INS_USER_IN_ZK_DEVICES", parametros);

                return rowsAffected <= 0;
            }
            catch
            {
                throw;
            }
        }

        public async Task<bool> SendUserToDeviceAdAsync(SendUserRequest sendUserRequest)
        {
            try
            {
                var parametros = new[]
                {
                    new SqlParameter("@ServerId", SqlDbType.Int) { Value = sendUserRequest.ServerId },
                    new SqlParameter("@Pin", SqlDbType.Int) { Value = sendUserRequest.Pin },
                    new SqlParameter("@Name", SqlDbType.NVarChar, 255) { Value = sendUserRequest.Name },
                    new SqlParameter("@Privilege", SqlDbType.Int) { Value = sendUserRequest.Privilege },
                    new SqlParameter("@Password", SqlDbType.NVarChar, 255) { Value = sendUserRequest.Password },
                    new SqlParameter("@Card", SqlDbType.Int) { Value = sendUserRequest.Card },
                    new SqlParameter("@DevicesSerialNumbers", SqlDbType.NVarChar) { Value = sendUserRequest.SerialNumbersToString() }
                };

                int rowsAffected = await _dbConnectionHelper.ExecuteWithoutDataAsync("SP_INS_USER_IN_ZK_DEVICES_ARCOS_DORADOS", parametros);

                return rowsAffected <= 0;
            }
            catch
            {
                throw;
            }
        }

        public async Task<bool> SendUserToDeviceRpAsync(SendUserRequest sendUserRequest)
        {
            try
            {
                var parametros = new[]
                {
                    new SqlParameter("@ServerId", SqlDbType.Int) { Value = sendUserRequest.ServerId },
                    new SqlParameter("@Pin", SqlDbType.Int) { Value = sendUserRequest.Pin },
                    new SqlParameter("@Name", SqlDbType.NVarChar, 255) { Value = sendUserRequest.Name },
                    new SqlParameter("@Privilege", SqlDbType.Int) { Value = sendUserRequest.Privilege },
                    new SqlParameter("@Password", SqlDbType.NVarChar, 255) { Value = sendUserRequest.Password },
                    new SqlParameter("@Card", SqlDbType.Int) { Value = sendUserRequest.Card },
                    new SqlParameter("@DevicesSerialNumbers", SqlDbType.NVarChar) { Value = sendUserRequest.SerialNumbersToString() }
                };

                int rowsAffected = await _dbConnectionHelper.ExecuteWithoutDataAsync("SP_INS_USER_IN_ZK_DEVICES_RIPLEY", parametros);

                return rowsAffected <= 0;
            }
            catch
            {
                throw;
            }
        }
    }
}