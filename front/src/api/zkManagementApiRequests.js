import axios from "axios";
import { getApiBaseUrl } from './config';
import { data } from "react-router-dom";

export const fetchZkCompanies = (serverId = null, companyName = null) => {
    return getApiBaseUrl('ZK_API_BASE_URL').then(baseUrl => {
        const params = {
            serverId: serverId,
            companyName: companyName
        };

        return axios.get(
            `${baseUrl}/company/get-all`,
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

export const fetchAllDevices = (serverId = null, companyId = null, serialNumber = null) => {
    return getApiBaseUrl('ZK_API_BASE_URL').then(baseUrl => {

        const url = `${baseUrl}/device/get-all?`;

        const params = {
            server: serverId,
            database: companyId,
            serialNumber: serialNumber
        }

        return axios.get(url,
            {
                params: params,
                withCredentials: true
            })
            .then((response) => response.data)
            .catch((error) => {
                throw error;
            });
    });
};

export const fetchDevices = (serverId = null, companyId = null, serialNumber = null) => {
    return getApiBaseUrl('ZK_API_BASE_URL').then(baseUrl => {

        const url = `${baseUrl}/device/get-all`;

        const params = {
            server: serverId,
            database: companyId,
            serialNumber: serialNumber
        }

        return axios.get(url,
            {
                params: params,
                withCredentials: true
            })
            .then((response) => response.data)
            .catch((error) => {
                throw error;
            });
    });
};

export const fetchZkDevices = (serverId = null, companyId = null, serialNumber = null) => {
    return getApiBaseUrl('ZK_API_BASE_URL').then(baseUrl => {

        const url = `${baseUrl}/device/get-zk`;

        const params = {
            server: serverId,
            database: companyId,
            serialNumber: serialNumber
        }

        return axios.get(url,
            {
                params: params,
                withCredentials: true
            })
            .then((response) => response.data)
            .catch((error) => {
                throw error;
            });
    });
};

export const sendUserToDevices = (payload) => {
    return getApiBaseUrl('ZK_API_BASE_URL').then(baseUrl => {
        return axios.post(
            `${baseUrl}/device/send-user`,
            payload,
            {
                headers: {
                    'Content-Type': 'application/json'
                },
                withCredentials: true
            }
        )
            .then((response) => response.data)
            .catch((error) => {
                throw error;
            });
    });
};


export const sendUserToDevicesAd = (payload) => {
    return getApiBaseUrl('ZK_API_BASE_URL').then(baseUrl => {
        return axios.post(
            `${baseUrl}/device/send-user-arcos-dorados`,
            payload,
            {
                headers: {
                    'Content-Type': 'application/json'
                },
                withCredentials: true
            }
        )
            .then((response) => response.data)
            .catch((error) => {
                throw error;
            });
    });
};


export const sendUserToDevicesRp = (payload) => {
    return getApiBaseUrl('ZK_API_BASE_URL').then(baseUrl => {
        return axios.post(
            `${baseUrl}/device/send-user-ripley`,
            payload,
            {
                headers: {
                    'Content-Type': 'application/json'
                },
                withCredentials: true
            }
        )
            .then((response) => response.data)
            .catch((error) => {
                throw error;
            });
    });
};

export const fetchCompanyConfigurationsByServer = (companyName = null, companyRut = null) => {
    return getApiBaseUrl('ZK_API_BASE_URL').then(baseUrl => {
        let url = `${baseUrl}/device/get-all?`;

        if (companyName) url += `CompanyName=${companyName}&`;
        if (companyRut !== null) url += `CompanyRut=${companyRut}&`;

        url = url.slice(0, -1);

        return axios.get(url, { withCredentials: true })
            .then((response) => {
                response.data
            })
            .catch((error) => {
                throw error;
            });
    });
};

export const fetchCompaniesInfo = (companyRut = null, companyName = null, role = null) => {
    return getApiBaseUrl('ZK_API_BASE_URL').then(baseUrl => {

        if (role == true)
            role = null
        else
            role = true

        const params = {
            companyRut: companyRut,
            companyName: companyName,
            isVisible: role
        };

        Object.keys(params).forEach(key => {
            if (params[key] === null || params[key] === '') {
                delete params[key];
            }
        });

        return axios.get(`${baseUrl}/company/get-info`, {
            params: params,
            withCredentials: true,
        })
            .then((response) => {
                return response.data;
            })
            .catch((error) => {
                console.error('Error fetching logs:', error.response?.data || error.message);
                throw error;
            });
    });
};

export const fetchAccessProfiles = (server = null, database = null) => {
    return getApiBaseUrl('ZK_API_BASE_URL').then(baseUrl => {
        let url = `${baseUrl}/device/get-access-profiles`;

        const params = {
            server: server,
            database: database
        }

        return axios.get(url,
            {
                params: params,
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

export const fetchSendAccessProfiles = (server = null, database = null, profileId = null) => {
    return getApiBaseUrl('ZK_API_BASE_URL').then(baseUrl => {
        let url = `${baseUrl}/device/bulk-send`;

        const params = {
            server: server,
            database: database,
            profileId: profileId
        }

        return axios.post(
            url,
            params,
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

export const updateCompanyVisibility = (companyRut, visibleGeneral, visibleZK, visibleDT) => {
    return getApiBaseUrl('ZK_API_BASE_URL').then(baseUrl => {

        const payload = {
            companyRut: companyRut,
            visibleGeneral: visibleGeneral,
            visibleZK: visibleZK,
            visibleDT: visibleDT
        };

        return axios.post(
            `${baseUrl}/company/update-visibility`,
            payload,
            {
                headers: {
                    'Content-Type': 'application/json'
                },
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
