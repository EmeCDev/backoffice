using Microsoft.Data.SqlClient;
using System.Data;
using System.Text.Json;
using UsersApi.Helpers;
using UsersApi.Models;

namespace UsersApi.Repositories
{
    public class UserRepository
    {
        private readonly DbConnectionHelper _dbConnection;
        public UserRepository(DbConnectionHelper dbConnection)
        {
            _dbConnection = dbConnection;
        }

        public async Task<List<UserDetails>> GetAllUsersDetailsAsync(GetUserRequest getUserRequest)
        {
            try
            {
                SqlParameter[] parameters =
                    [
                        new SqlParameter("@Name", SqlDbType.NVarChar, 255) { Value = getUserRequest.Name },
                        new SqlParameter("@Email", SqlDbType.NVarChar, 255) { Value = getUserRequest.Email },
                        new SqlParameter("@IsActive", SqlDbType.Bit) { Value = getUserRequest.IsActive }
                    ];

                DataTable result = await _dbConnection.ExecuteWithDataAsync("SP_SEL_USERS_DETAILS", parameters);

                List<UserDetails> users = new List<UserDetails>();

                foreach (DataRow row in result.Rows)
                {
                    int id = Convert.ToInt32(row["UserId"]);
                    string name = row["Name"].ToString() ?? string.Empty;
                    string email = row["Email"].ToString() ?? string.Empty;
                    string profileName = row["ProfileName"].ToString() ?? string.Empty;
                    int profileId = Convert.ToInt32(row["ProfileId"]);
                    bool isActive = Convert.ToBoolean(row["IsActive"]);

                    UserDetails user = new UserDetails(
                        id,
                        name,
                        email,
                        profileName,
                        profileId,
                        isActive
                    );

                    users.Add(user);
                }

                return users;
            }
            catch (ArgumentException ex)
            {
                throw new ArgumentException(ex.Message);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message, ex);
            }
        }

        public async Task<string> GetPasswordByEmailAsync(string email)
        {
            try
            {
                SqlParameter[] parameters =
                [
                    new SqlParameter("@Email", SqlDbType.NVarChar, 255) { Value = email }
                ];

                DataTable result = await _dbConnection.ExecuteWithDataAsync("SP_SEL_PASSWORD_BY_EMAIL", parameters);

                string storedHash = result.Rows[0]["PasswordHash"].ToString() ?? string.Empty;

                return storedHash;
            }
            catch (ArgumentException ex)
            {
                throw new ArgumentException(ex.Message);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message, ex);
            }
        }

        public async Task<User> GetUserByEmailAsync(string email)
        {
            try
            {
                SqlParameter[] parameters =
                [
                    new SqlParameter("@Email", SqlDbType.NVarChar, 255) { Value = email }
                ];

                DataTable result = await _dbConnection.ExecuteWithDataAsync("SP_SEL_USER_BY_EMAIL", parameters);

                if (result.Rows.Count <= 0)
                    throw new ArgumentException("Usuario no encontrado");

                DataRow row = result.Rows[0];
                var user = new User(
                    Convert.ToInt32(row["UserId"]),
                    row["Name"].ToString() ?? string.Empty,
                    row["Email"].ToString() ?? string.Empty,
                    Convert.ToInt32(row["ProfileId"]),
                    new List<int>(),
                    Convert.ToBoolean(row["IsActive"])
                );

                return user;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message, ex);
            }
        }

        public async Task<int> CreateUserAsync(CreateUserRequest request, int createdBy)
        {
            try
            {
                SqlParameter[] parameters =
                [
                    new SqlParameter("@Name", SqlDbType.NVarChar, 100) { Value = request.Name },
                    new SqlParameter("@Email", SqlDbType.NVarChar, 255) { Value = request.Email },
                    new SqlParameter("@Password", SqlDbType.NVarChar, 255) { Value = request.Password },
                    new SqlParameter("@ProfileId", SqlDbType.Int) { Value = request.ProfileId },
                    new SqlParameter("@CreatedBy", SqlDbType.Int) { Value = createdBy }
                ];

                DataTable result = await _dbConnection.ExecuteWithDataAsync("SP_INS_USER", parameters);

                if (result.Rows.Count == 0)
                    return -1;

                return Convert.ToInt32(result.Rows[0][0]);
            }
            catch (ArgumentException ex)
            {
                throw new ArgumentException(ex.Message);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message, ex);
            }
        }

        public async Task<User> UpdateUserAsync(UpdateUserRequest request, int updatedBy)
        {
            try
            {
                SqlParameter[] parameters =
                [
                    new SqlParameter("@UserId", SqlDbType.Int) { Value = request.UserId },
                    new SqlParameter("@Name", SqlDbType.NVarChar, 100) { Value = request.Name },
                    new SqlParameter("@Email", SqlDbType.NVarChar, 255) { Value = request.Email },
                    new SqlParameter("@Password", SqlDbType.NVarChar, 255) { Value = request.Password },
                    new SqlParameter("@ProfileId", SqlDbType.Int) { Value = request.ProfileId },
                    new SqlParameter("@IsActive", SqlDbType.Bit) { Value = request.IsActive },
                    new SqlParameter("@UpdatedBy", SqlDbType.Int) { Value = updatedBy }
                ];

                DataTable result = await _dbConnection.ExecuteWithDataAsync("SP_UPD_USER", parameters);

                if (result.Rows.Count == 0)
                    return null;  

                var user = new User(
                    Convert.ToInt32(result.Rows[0]["UserId"]),
                    result.Rows[0]["Name"].ToString() ?? string.Empty,
                    result.Rows[0]["Email"].ToString() ?? string.Empty,
                    Convert.ToInt32(result.Rows[0]["ProfileId"]),
                    new List<int>(),
                    Convert.ToBoolean(result.Rows[0]["IsActive"])
                );

                return user;
            }
            catch (ArgumentException ex)
            {
                throw new ArgumentException(ex.Message);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message, ex);
            }
        }
    }
}