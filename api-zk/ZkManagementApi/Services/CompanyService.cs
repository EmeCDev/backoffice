using ZkManagementApi.Models;
using ZkManagementApi.Repositories;

namespace ZkManagementApi.Services
{
    public class CompanyService
    {
        private readonly CompanyRepository _companyRepository;

        public CompanyService(CompanyRepository companyRepository)
        {
            _companyRepository = companyRepository;
        }

        public async Task<ApiResponse<List<ZkCompany>>> GetZkCompaniesAsync(GetCompanyRequest getCompanyRequest)
        {
            if (getCompanyRequest.ServerId is null || getCompanyRequest.ServerId <= 0)
                throw new ArgumentException("El parámetro ServerId es invalido.");

            List<ZkCompany> companiesList = await _companyRepository.GetZkCompaniesAsync(getCompanyRequest);

            if (!companiesList.Any())
                throw new ArgumentException("No se han encontrado empresas con los parametros indicados.");

            return new ApiResponse<List<ZkCompany>>(true, 200, $"Se han encontrado {companiesList.Count} empresa(s).", companiesList);
        }

        public async Task<ApiResponse<List<CompanyInfo>>> GetCompaniesAsync(GetCompanyInfoRequest getCompanyInfoRequest)
        {
            if (string.IsNullOrWhiteSpace(getCompanyInfoRequest.CompanyName) && getCompanyInfoRequest.CompanyRut is null)
                throw new ArgumentException("Debe indicar algun filtro para la busqueda.");

            int? companyRut = Convert.ToInt32(getCompanyInfoRequest.CompanyRut);
            string? companyName = getCompanyInfoRequest.CompanyName;
            bool? isVisible = getCompanyInfoRequest.IsVisible;

            List<CompanyInfo> companiesInfoList = await _companyRepository.GetCompaniesAsync(companyRut, companyName, isVisible);

            if (!companiesInfoList.Any())
                throw new ArgumentException("No se han encontrado empresas con los parametros indicados.");

            return new ApiResponse<List<CompanyInfo>>(true, 200, $"Se han encontrado {companiesInfoList.Count} empresa(s).", companiesInfoList);
        }

        public async Task<ApiResponse<bool>> UpdateVisibilityAsync(UpdateVisibilityRequest updateVisibilityRequest)
        {
            if (updateVisibilityRequest.CompanyRut is null)
                throw new ArgumentException("Debe proporcionar el RUT de la empresa.");

            bool? visibleGeneral = updateVisibilityRequest.VisibleGeneral;
            bool? visibleZK = updateVisibilityRequest.VisibleZK;
            bool? visibleDT = updateVisibilityRequest.VisibleDT;

            int isUpdated = await _companyRepository.UpdateVisibilityAsync(updateVisibilityRequest.CompanyRut.Value, visibleGeneral, visibleZK, visibleDT);

            if (isUpdated == 0)
                throw new ArgumentException("No se pudo actualizar la visibilidad de la empresa con el RUT proporcionado.");

            return new ApiResponse<bool>(true, 200, "La visibilidad de la empresa se ha actualizado correctamente.", true);
        }

    }
}
