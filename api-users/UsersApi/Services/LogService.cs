using System.Globalization;
using UsersApi.Helpers;
using UsersApi.Models;
using UsersApi.Repositories;

namespace UsersApi.Services
{
    public class LogService
    {
        private readonly LogRepository _logRepository;

        public LogService(LogRepository logRepository) 
        {
            _logRepository = logRepository;
        }

        public async Task<bool> SaveLogAsync(ApplicationLog log) 
        {
            bool isSavedToDb, isSavedToFile;

            try
            {
                isSavedToDb = await _logRepository.SaveLogToDbAsync(log);
            }
            catch (Exception)
            {
                isSavedToDb = false;
            }

            try
            {
                isSavedToFile = await _logRepository.SaveLogToFile(log);
            }
            catch (Exception)
            {
                isSavedToFile = false;
            }
           
            return isSavedToDb || isSavedToFile;
        }

        public async Task<ApiResponse<List<GetLogsResult>>> GetAllLogsDetailsAsync(GetLogsRequest getLogsRequest)
        {
            DateTime? initDateParsed = null;
            DateTime? endDateParsed = null;
            var culture = CultureInfo.InvariantCulture;
            const string dateFormat = "yyyy-MM-dd";

            if (!string.IsNullOrEmpty(getLogsRequest.StartDate))
            {
                bool isInitDateValid = DateTime.TryParseExact(
                    getLogsRequest.StartDate,
                    dateFormat,
                    culture,
                    DateTimeStyles.None,
                    out DateTime initDate);

                if (!isInitDateValid)
                {
                    throw new ArgumentException("La fecha de inicio no tiene un formato válido (yyyy-MM-dd).");
                }
                initDateParsed = initDate;
            }

            if (!string.IsNullOrEmpty(getLogsRequest.EndDate))
            {
                bool isEndDateValid = DateTime.TryParseExact(
                    getLogsRequest.EndDate,
                    dateFormat,
                    culture,
                    DateTimeStyles.None,
                    out DateTime endDate);

                if (!isEndDateValid)
                {
                    throw new ArgumentException("La fecha de fin no tiene un formato válido (yyyy-MM-dd).");
                }
                endDateParsed = endDate;
            }

            if (initDateParsed.HasValue && endDateParsed.HasValue && initDateParsed > endDateParsed)
            {
                throw new ArgumentException("La fecha inicio no puede ser mayor a la fecha de fin.");
            }

            List<GetLogsResult> logs = await _logRepository.GetAllLogsDetailsAsync(getLogsRequest);
            return new ApiResponse<List<GetLogsResult>>(true, 200, $"Se han encontrado {logs.Count} registro(s)", logs);
        }
    }
}