using Microsoft.Data.SqlClient;
using System.Data;
using UsersApi.Helpers;
using UsersApi.Models;

namespace UsersApi.Repositories
{
    public class ProfileRepository
    {
        private readonly DbConnectionHelper _dbConnection;
        public ProfileRepository(DbConnectionHelper dbConnection)
        {
            _dbConnection = dbConnection;
        }

        public async Task<List<int>> GetGrantsByProfileAsync(int? profileId)
        {
            try
            {
                SqlParameter[] parameters =
                [
                    new SqlParameter("@ProfileId", SqlDbType.Int) { Value = profileId }
                ];

                DataTable result = await _dbConnection.ExecuteWithDataAsync("SP_SEL_GRANT_IDS_BY_PROFILE", parameters);

                if (result.Rows.Count <= 0)
                    return new List<int>();

                return result.AsEnumerable()
                             .Select(row => Convert.ToInt32(row[0]))
                             .ToList();
            }
            catch (ArgumentException ex)
            {
                throw new ArgumentException(ex.Message);
            }
            catch (Exception ex)
            {
                throw new Exception("Error interno del servidor " + ex.Message, ex);
            }
        }

        public async Task<Profile> GetProfileAsync(GetProfileRequest getProfileRequest)
        {
            try
            {

                SqlParameter[] parameters =
                {
                    new SqlParameter("ProfileId", SqlDbType.Int) { Value = getProfileRequest.ProfileId }
                };

                DataTable result = await _dbConnection.ExecuteWithDataAsync("SP_SEL_PROFILE_BY_ID", parameters);

                if (result == null || result.Rows.Count == 0)
                {
                    return null;
                }

                Profile profile = new Profile(
                    profileId: Convert.ToInt32(result.Rows[0]["ProfileId"]),
                    name: result.Rows[0]["Name"].ToString() ?? string.Empty,
                    isActive: Convert.ToBoolean(result.Rows[0]["IsActive"])
                );

                return profile;
            }
            catch (ArgumentException)
            {
                throw;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public async Task<List<Profile>> GetAllProfilesAsync()
        {
            try
            {
                SqlParameter[] parameters =
                [
                ];

                DataTable result = await _dbConnection.ExecuteWithDataAsync("SP_SEL_PROFILES", parameters);

                List<Profile> profiles = new List<Profile>();

                foreach (DataRow row in result.Rows)
                {
                    Profile profile = new Profile(
                        profileId: Convert.ToInt32(row["ProfileId"]),
                        name: row["Name"].ToString(),
                        isActive: Convert.ToBoolean(row["IsActive"])
                    );

                    profiles.Add(profile);
                }

                return profiles;
            }
            catch (ArgumentException)
            {
                throw;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public async Task<int> CreateProfileAsync(CreateProfileRequest createProfileRequest, int createdBy)
        {
            try
            {
                SqlParameter[] parameters =
                [
                    new SqlParameter("@Name", SqlDbType.NVarChar, 100) { Value = createProfileRequest.Name },
                    new SqlParameter("@GrantsList", SqlDbType.NVarChar, 255) { Value = createProfileRequest.GrantsListToString() },
                    new SqlParameter("@CreatedBy", SqlDbType.Int) { Value = createdBy }
                ];

                DataTable result = await _dbConnection.ExecuteWithDataAsync("SP_INS_PROFILE", parameters);

                return Convert.ToInt32(result.Rows[0][0]);
            }
            catch (ArgumentException)
            {
                throw;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public async Task<bool> UpdateProfileAsync(UpdateProfileRequest updateProfileRequest, int createdBy)
        {
            try
            {
                SqlParameter[] parameters =
                [
                    new SqlParameter("@ProfileId", SqlDbType.Int) { Value = updateProfileRequest.ProfileId },
                    new SqlParameter("@Name", SqlDbType.NVarChar, 100) { Value = updateProfileRequest.Name },
                    new SqlParameter("@GrantsList", SqlDbType.NVarChar, 255) { Value = updateProfileRequest.GrantsListToString() },
                    new SqlParameter("@UpdatedBy", SqlDbType.Int) { Value = createdBy }
                ];

                int affectedRows = await _dbConnection.ExecuteWithoutDataAsync("SP_UPD_PROFILE", parameters);

                return (affectedRows <= 0);
            }
            catch (ArgumentException)
            {
                throw;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public async Task<bool> DeleteProfileAsync(DeleteProfileRequest deleteProfileRequest)
        {
            try
            {
                SqlParameter[] parameters =
                [
                    new SqlParameter("@ProfileId", SqlDbType.Int) { Value = deleteProfileRequest.ProfileId }
                ];

                int affectedRows = await _dbConnection.ExecuteWithoutDataAsync("SP_DROP_PROFILE", parameters);

                return (affectedRows <= 0);
            }
            catch (ArgumentException)
            {
                throw;
            }
            catch (Exception)
            {
                throw;
            }
        }
    }
}
