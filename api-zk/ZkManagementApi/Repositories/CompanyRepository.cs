using Microsoft.Data.SqlClient;
using System.Data;
using ZkManagementApi.Helpers;
using ZkManagementApi.Models;

namespace ZkManagementApi.Repositories
{
    public class CompanyRepository
    {
        private readonly DbConnectionHelper _dbConnectionHelper;
        public CompanyRepository(DbConnectionHelper dbConnectionHelper)
        {
            _dbConnectionHelper = dbConnectionHelper;
        }

        public async Task<List<ZkCompany>> GetZkCompaniesAsync(GetCompanyRequest getCompanyRequest)
        {
            try
            {
                SqlParameter[] parameters = [
                    new SqlParameter("@ServerId", SqlDbType.Int) { Value = getCompanyRequest.ServerId },
                    new SqlParameter("@CompanyName", SqlDbType.NVarChar, 255) { Value = getCompanyRequest.CompanyName },
                ];

                DataTable companiesDt = await _dbConnectionHelper.ExecuteWithDataAsync("SP_SEL_EMPRESAS_ZK", parameters);

                List<ZkCompany> companiesList = new List<ZkCompany>();

                foreach (DataRow row in companiesDt.Rows)
                {
                    companiesList.Add(new ZkCompany(
                        companyId: (int)row["EmpresaID"],
                        client: row["EmpresaCliente"].ToString() ?? "Null",
                        databaseName: row["EmpresaNombreBD"].ToString() ?? "Null",
                        entryDate: row["EmpresaFechaIngreso"].ToString() ?? "Null",
                        isActive: (int)row["Activo"]
                    ));
                }

                return companiesList;
            }
            catch
            {
                throw;
            }
        }

        public async Task<List<CompanyInfo>> GetCompaniesAsync(int? companyRut, string? companyName, bool? isVisible = null)
        {
            try
            {
                SqlParameter[] parameters = [
                    new SqlParameter("@CompanyRut", SqlDbType.Int) { Value = companyRut },
                    new SqlParameter("@CompanyName", SqlDbType.NVarChar, 255) { Value = companyName },
                    new SqlParameter("@IsVisible", SqlDbType.Bit) { Value = isVisible }
                ];

                DataTable companiesDt = await _dbConnectionHelper.ExecuteWithDataAsync("SP_SEL_COMPANY_INFO", parameters);

                List<CompanyInfo> companiesList = new List<CompanyInfo>();

                foreach (DataRow row in companiesDt.Rows)
                {
                    companiesList.Add(new CompanyInfo(
                        id: (int)row["id"],
                        servidor: row["servidor"].ToString() ?? "Null",
                        bdGenhoras: row["bd_genhoras"].ToString() ?? "Null",
                        nombreEmpresa: row["nombre_empresa"].ToString() ?? "Null",
                        rutEmpresa: row["rut_empresa"].ToString() ?? "Null",
                        dv: row["dv"].ToString() ?? "Null",
                        tipoCliente: row["tipo_cliente"].ToString() ?? "Null",
                        urlCliente: row["URL_Cliente"].ToString() ?? "Null"
                    ));
                }

                return companiesList;
            }
            catch
            {
                throw;
            }
        }

        public async Task<int> UpdateVisibilityAsync(int companyRut, bool? visibleGeneral, bool? visibleZK, bool? visibleDT)
        {
            try
            {
                SqlParameter[] parameters = 
                {
                    new SqlParameter("@CompanyRut", SqlDbType.Int) { Value = companyRut },
                    new SqlParameter("@VisibleGeneral", SqlDbType.Bit) { Value = visibleGeneral.HasValue ? visibleGeneral.Value : (object)DBNull.Value },
                    new SqlParameter("@VisibleZK", SqlDbType.Bit) { Value = visibleZK.HasValue ? visibleZK.Value : (object)DBNull.Value },
                    new SqlParameter("@VisibleDT", SqlDbType.Bit) { Value = visibleDT.HasValue ? visibleDT.Value : (object)DBNull.Value }
                };

                DataTable result = await _dbConnectionHelper.ExecuteWithDataAsync("SP_UPD_COMPANY_VISIBILITY", parameters);

                if (result.Rows.Count > 0)
                {
                    return Convert.ToInt32(result.Rows[0]["Estado"]);
                }

                return 0;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al actualizar la visibilidad de la empresa.", ex);
            }
        }
    }
}