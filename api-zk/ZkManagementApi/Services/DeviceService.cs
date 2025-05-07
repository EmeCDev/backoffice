using Microsoft.AspNetCore.Mvc;
using ZkManagementApi.Models;
using ZkManagementApi.Repositories;

namespace ZkManagementApi.Services
{
    public class DeviceService
    {
        private readonly DeviceRepository _deviceRepository;
        public DeviceService(DeviceRepository deviceRepository) 
        {
            _deviceRepository = deviceRepository;
        }

        public async Task<ApiResponse<List<NewDeviceInfo>>> GetDevicesAsync(GetDeviceRequest getDeviceRequest)
        {
            if (getDeviceRequest.Server is null || getDeviceRequest.Server <= 0) 
                throw new ArgumentException("El parámetro Server no es valido.");

            if (getDeviceRequest.Database is null)
                throw new ArgumentException("El parámetro Database no es valido");

            List<NewDeviceInfo> devicesList = await _deviceRepository.GetDevicesAsync(getDeviceRequest);

            if (devicesList == null || !devicesList.Any())
                throw new ArgumentException("No se encontraron equipos con los parametros indicados.");

            return new ApiResponse<List<NewDeviceInfo>>(true, 200, $"Se han encontrado {devicesList.Count} equipo(s).", devicesList);
        }

        public async Task<ApiResponse<List<AccessProfile>>> GetAccessProfilesAsync(GetAccessProfilesRequest getAccessProfilesRequest)
        {
            if (getAccessProfilesRequest.Server is null || getAccessProfilesRequest.Server <= 0)
                throw new ArgumentException("El parámetro Server no es valido.");

            if (getAccessProfilesRequest.Database is null)
                throw new ArgumentException("El parámetro Database no es valido");

            List<AccessProfile> profilesList = await _deviceRepository.GetAccessProfilesAsync(getAccessProfilesRequest);

            if (profilesList == null || !profilesList.Any())
                throw new ArgumentException("No se encontraron perfiles con los parametros indicados.");

            return new ApiResponse<List<AccessProfile>>(true, 200, $"Se han encontrado {profilesList.Count} perfil(es).", profilesList);
        }

        public async Task<ApiResponse<bool>> SendProfileAsync(SendProfileRequest sendProfileRequest)
        {
            if (sendProfileRequest.Server is null || sendProfileRequest.Server <= 0)
                throw new ArgumentException("El parámetro Server no es valido.");

            if (sendProfileRequest.Database is null)
                throw new ArgumentException("El parámetro Database no es valido");

            if (sendProfileRequest.ProfileId is null || sendProfileRequest.ProfileId <= 0)
                throw new ArgumentException("El parámetro ProfileId no es valido");

            bool isProfileSent = await _deviceRepository.SendProfileAsync(sendProfileRequest);

            if (!isProfileSent)
                throw new ArgumentException("No se encontraron perfiles con los parametros indicados.");

            return new ApiResponse<bool>(true, 200, $"Se han enviado los comandos para cargar masivamente el perfil.", true);
        }

        public async Task<ApiResponse<List<NewDeviceInfo>>> GetZkDevicesAsync(GetDeviceRequest getDeviceRequest)
        {
            if (getDeviceRequest.Server is null || getDeviceRequest.Server <= 0)
                throw new ArgumentException("El parámetro Server no es valido.");

            if (getDeviceRequest.Database is null)
                throw new ArgumentException("El parámetro Database no es valido");

            List<NewDeviceInfo> devicesList = await _deviceRepository.GetZkDevicesAsync(getDeviceRequest);

            if (devicesList == null || !devicesList.Any())
                throw new ArgumentException("No se encontraron equipos con los parametros indicados.");

            return new ApiResponse<List<NewDeviceInfo>>(true, 200, $"Se han encontrado {devicesList.Count} equipo(s).", devicesList);
        }

        public async Task<ApiResponse<bool>> SendUserToDeviceAsync([FromBody] SendUserRequest sendUserRequest)
        {
            if (sendUserRequest.ServerId is null || sendUserRequest.ServerId <= 0)
                throw new ArgumentException($"El parámetro {nameof(sendUserRequest.ServerId)} no es válido.");

            if (sendUserRequest.DevicesSerialNumbers is null || !sendUserRequest.DevicesSerialNumbers.Any())
                throw new ArgumentException($"Debe indicar al menos una serie de equipo en {nameof(sendUserRequest.DevicesSerialNumbers)}.");

            if (sendUserRequest.Pin is null || sendUserRequest.ServerId <= 0)
                throw new ArgumentException($"El parámetro {nameof(sendUserRequest.Pin)} no es valido.");

            if (string.IsNullOrEmpty(sendUserRequest.Name))
                throw new ArgumentException($"El parámetro {nameof(sendUserRequest.Name)} es obligatorio.");

            if (sendUserRequest.Privilege is null || sendUserRequest.Privilege < 0)
                throw new ArgumentException($"El parámetro {nameof(sendUserRequest.Privilege)} no es valido.");

            if (string.IsNullOrEmpty(sendUserRequest.Password))
                throw new ArgumentException($"El parámetro {nameof(sendUserRequest.Password)} no es valido.");

            if (sendUserRequest.Card is null || sendUserRequest.Card <= 0)
                throw new ArgumentException($"El parámetro {nameof(sendUserRequest.Card)} no es valido.");

            if (!sendUserRequest.DevicesSerialNumbers.Any())
                throw new ArgumentException($"Al menos una serie de equipo es requerida en {nameof(sendUserRequest.DevicesSerialNumbers)}.");

            var isUserSent = await _deviceRepository.SendUserToDeviceAsync(sendUserRequest);

            if (!isUserSent)
                throw new Exception("Ocurrio un error al enviar el usuario.");

            return new ApiResponse<bool>(true, 200, "Comandos para crear usuario enviado.");
        }

        public async Task<ApiResponse<bool>> SendUserToDeviceRpAsync([FromBody] SendUserRequest sendUserRequest)
        {
            if (sendUserRequest.ServerId is null || sendUserRequest.ServerId <= 0)
                throw new ArgumentException($"El parámetro {nameof(sendUserRequest.ServerId)} no es válido.");

            if (sendUserRequest.DevicesSerialNumbers is null || !sendUserRequest.DevicesSerialNumbers.Any())
                throw new ArgumentException($"Debe indicar al menos una serie de equipo en {nameof(sendUserRequest.DevicesSerialNumbers)}.");

            if (sendUserRequest.Pin is null || sendUserRequest.ServerId <= 0)
                throw new ArgumentException($"El parámetro {nameof(sendUserRequest.Pin)} no es valido.");

            if (string.IsNullOrEmpty(sendUserRequest.Name))
                throw new ArgumentException($"El parámetro {nameof(sendUserRequest.Name)} es obligatorio.");

            if (sendUserRequest.Privilege is null || sendUserRequest.Privilege < 0)
                throw new ArgumentException($"El parámetro {nameof(sendUserRequest.Privilege)} no es valido.");

            if (string.IsNullOrEmpty(sendUserRequest.Password))
                throw new ArgumentException($"El parámetro {nameof(sendUserRequest.Password)} no es valido.");

            if (sendUserRequest.Card is null || sendUserRequest.Card <= 0)
                throw new ArgumentException($"El parámetro {nameof(sendUserRequest.Card)} no es valido.");

            if (!sendUserRequest.DevicesSerialNumbers.Any())
                throw new ArgumentException($"Al menos una serie de equipo es requerida en {nameof(sendUserRequest.DevicesSerialNumbers)}.");

            var isUserSent = await _deviceRepository.SendUserToDeviceRpAsync(sendUserRequest);

            if (!isUserSent)
                throw new Exception("Ocurrio un error al enviar el usuario.");

            return new ApiResponse<bool>(true, 200, "Comandos para crear usuario enviado.");
        }

        public async Task<ApiResponse<bool>> SendUserToDeviceAdAsync([FromBody] SendUserRequest sendUserRequest)
        {
            if (sendUserRequest.ServerId is null || sendUserRequest.ServerId <= 0)
                throw new ArgumentException($"El parámetro {nameof(sendUserRequest.ServerId)} no es válido.");

            if (sendUserRequest.DevicesSerialNumbers is null || !sendUserRequest.DevicesSerialNumbers.Any())
                throw new ArgumentException($"Debe indicar al menos una serie de equipo en {nameof(sendUserRequest.DevicesSerialNumbers)}.");

            if (sendUserRequest.Pin is null || sendUserRequest.ServerId <= 0)
                throw new ArgumentException($"El parámetro {nameof(sendUserRequest.Pin)} no es valido.");

            if (string.IsNullOrEmpty(sendUserRequest.Name))
                throw new ArgumentException($"El parámetro {nameof(sendUserRequest.Name)} es obligatorio.");

            if (sendUserRequest.Privilege is null || sendUserRequest.Privilege < 0)
                throw new ArgumentException($"El parámetro {nameof(sendUserRequest.Privilege)} no es valido.");

            if (string.IsNullOrEmpty(sendUserRequest.Password))
                throw new ArgumentException($"El parámetro {nameof(sendUserRequest.Password)} no es valido.");

            if (sendUserRequest.Card is null || sendUserRequest.Card <= 0)
                throw new ArgumentException($"El parámetro {nameof(sendUserRequest.Card)} no es valido.");

            if (!sendUserRequest.DevicesSerialNumbers.Any())
                throw new ArgumentException($"Al menos una serie de equipo es requerida en {nameof(sendUserRequest.DevicesSerialNumbers)}.");

            var isUserSent = await _deviceRepository.SendUserToDeviceAdAsync(sendUserRequest);

            if (!isUserSent)
                throw new Exception("Ocurrio un error al enviar el usuario.");

            return new ApiResponse<bool>(true, 200, "Comandos para crear usuario enviado.");
        }
    }
}
