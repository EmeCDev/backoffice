using ClientLicenseApi.Models;
using ClientLicenseApi.Repositories;

namespace ClientLicenseApi.Services
{
    public class LicenseService
    {
        private readonly LicenseRepository _licenseRepository;

        public LicenseService(LicenseRepository licenceRepository) 
        {
            _licenseRepository = licenceRepository;
        }

        public async Task<ApiResponse<ClientLicenseData>> GetLicenceDetailsAsync(GetLicenseRequest getLicenseRequest)
        {
            if (getLicenseRequest.Server is null)
                throw new ArgumentException("Debe indicar un servidor valido.");

            if (getLicenseRequest.Database is null)
                throw new ArgumentException("Debe indicar una base de datos valida.");

            ClientLicenseData? clientLicenseData = await _licenseRepository.GetLicenseDetailsAsync(getLicenseRequest);

            if (clientLicenseData is null)
                throw new ArgumentException("Ocurrio un error al obtener los datos de la licencia del cliente.");

            return new ApiResponse<ClientLicenseData>(true, 200, "Se encontro la licencia.", clientLicenseData);
        }

        public async Task<ApiResponse<ClientLicenseData>> UpdateClientLicenseAsync(UpdateLicenseRequest updateLicenseRequest)
        {
            if (updateLicenseRequest.Server is null)
                throw new ArgumentException("Debe indicar un servidor valido.");

            if (updateLicenseRequest.Database is null)
                throw new ArgumentException("Debe indicar una base de datos valida.");

            ClientLicenseData? clientLicenseData = await _licenseRepository.UpdateLicenseDetailsAsync(updateLicenseRequest);

            if (clientLicenseData is null)
                throw new ArgumentException("Ocurrio un error al actualizar los datos de la licencia del cliente.");

            return new ApiResponse<ClientLicenseData>(true, 200, "Se actualizó la licencia.", clientLicenseData);
        }
    }
}
