import axios from "axios";
import { getApiBaseUrl } from './config';

export const fetchLicenseData = (server = null, companyDb = null) => {
    return getApiBaseUrl('LICENSE_API_BASE_URL').then(baseUrl => {

        const url = `${baseUrl}/license/get-data`;

        const params = {
            server: server,
            database: companyDb
        };

        return axios.get(
            url,
            {
                params: params,
                withCredentials: true
            }
        )
            .then((response) => {
                return response.data;
            })
            .catch((error) => {
                throw error;
            });
    });
};

export const fetchUpdateLicenseData = (server = null, companyDb = null, newExpirationDate = null, newWorkersCount = null, oldExpirationDate = null, oldWorkersCount = null) => {
    return getApiBaseUrl('LICENSE_API_BASE_URL').then(baseUrl => {

        const url = `${baseUrl}/license/update`;

        const dateparts = newExpirationDate.split('-')

        const day = dateparts[2]
        const month = dateparts[1]
        const year = dateparts[0]

        const yyyymmdd = `${year}${month}${day}`;

        const body = {
            server: server,
            database: companyDb,
            newExpirationDate: yyyymmdd,
            newWorkersCount: newWorkersCount,
            oldExpirationDate: oldExpirationDate, 
            oldWorkersCount: oldWorkersCount 
        };

        return axios.post(
            url,
            body,
            {
                withCredentials: true
            })
            .then((response) => {
                return response.data;
            })
            .catch((error) => {
                throw error;
            });
    });
};

