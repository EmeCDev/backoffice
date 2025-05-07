using Microsoft.Data.SqlClient;
using System.Data;

namespace UsersApi.Helpers
{
    public class DbConnectionHelper
    {
        private readonly IConfiguration _configuration;

        public DbConnectionHelper(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        private SqlConnection GetConnection()
        {
            SqlConnection connection = new SqlConnection(_configuration.GetConnectionString("Base"));
            return connection;
        }

        public async Task<int> ExecuteWithoutDataAsync(string spName, params SqlParameter[] parameters)
        {
            SqlConnection connection = new SqlConnection();
            SqlCommand command = new SqlCommand();

            try
            {
                connection = GetConnection();
                command = new SqlCommand(spName, connection)
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = 15
                };

                command.Parameters.AddRange(parameters);

                await connection.OpenAsync();
                return await command.ExecuteNonQueryAsync();
            }
            catch (SqlException ex) when (ex.Number == 50001)
            {
                throw new ArgumentException($"{ex.Message}", ex);
            }
            catch (SqlException ex)
            {
                if (ex.Number == 50001)
                    throw new ArgumentException($"{ex.Message}", ex);
                else
                    throw new Exception(ex.Message);
            }
            finally
            {
                if (command != null) command.Dispose();
                if (connection != null) connection.Close();
            }
        }

        public async Task<DataTable> ExecuteWithDataAsync(string spName, params SqlParameter[] parameters)
        {
            SqlConnection connection = new SqlConnection();
            SqlCommand command = new SqlCommand();

            try
            {
                connection = GetConnection();
                command = new SqlCommand(spName, connection)
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = 15
                };

                command.Parameters.AddRange(parameters);

                var dataTable = new DataTable();

                using (var adapter = new SqlDataAdapter(command))
                {
                    await connection.OpenAsync();
                    adapter.Fill(dataTable);
                }

                return dataTable;
            }
            catch (SqlException ex) 
            {
                if (ex.Number == 50001)
                    throw new ArgumentException($"{ex.Message}", ex);
                else
                    throw new Exception(ex.Message);
            }
            catch (Exception ex)
            {
                throw new Exception($"Error al ejecutar el procedimiento almacenado: {spName} - {ex.Message}", ex);
            }
            finally
            {
                if (command != null) command.Dispose();
                if (connection != null) connection.Close();
            }
        }
    }
}
