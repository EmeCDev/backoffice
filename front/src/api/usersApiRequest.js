import axios from "axios";
import { getApiBaseUrl } from './config';

// Autenticación
export const fetchAuthenticate = (email = null, password = null) => {
  return getApiBaseUrl('USERS_API_BASE_URL').then(baseUrl => {
    return axios.post(
      `${baseUrl}/user/authenticate`,
      { email, password },
      { withCredentials: true }
    )
      .then(response => response.data)
      .catch(error => {
        throw error;
      });
  });
};

export const fetchLogout = () => {
  return getApiBaseUrl('USERS_API_BASE_URL').then(baseUrl => {
    return axios.post(
      `${baseUrl}/user/logout`,
      { withCredentials: true }
    )
      .then(response => response.data)
      .catch(error => {
        throw error;
      });
  });
};

// Gestión de Usuarios
export const fetchUsers = (name = null, email = null, isActive = null) => {
  return getApiBaseUrl('USERS_API_BASE_URL').then(baseUrl => {
    const params = {
      Name: name,
      Email: email,
      IsActive: isActive,
    };

    // Limpiar parámetros vacíos
    Object.keys(params).forEach(key => {
      if (params[key] === null || params[key] === '') {
        delete params[key];
      }
    });

    return axios.get(`${baseUrl}/user/get-all`, {
      params: params,
      withCredentials: true,
    })
      .then(response => response.data)
      .catch(error => {
        console.error('Error fetching users:', error.response?.data || error.message);
        throw error;
      });
  });
};

export const fetchCreateUser = (userData) => {
  return getApiBaseUrl('USERS_API_BASE_URL').then(baseUrl => {
    return axios.post(
      `${baseUrl}/user/create`,
      {
        Name: userData.name,
        Email: userData.email,
        Password: userData.password,
        ProfileId: userData.profileId
      },
      { withCredentials: true }
    )
      .then(response => response.data)
      .catch(error => {
        console.error('Error creating user:', error.response?.data || error.message);
        throw error;
      });
  });
};

export const fetchUpdateUser = (userData) => {
  return getApiBaseUrl('USERS_API_BASE_URL').then(baseUrl => {
    return axios.post(
      `${baseUrl}/user/update`,
      {
        UserId: userData.id,
        Name: userData.name,
        Email: userData.email,
        Password: userData.password,
        IsActive: userData.isActive,
        ProfileId: userData.profileId
      },
      { withCredentials: true }
    )
      .then(response => response.data)
      .catch(error => {
        console.error('Error updating user:', error.response?.data || error.message);
        throw error;
      });
  });
};

export const fetchToggleUserStatus = (userId, isActive) => {
  return getApiBaseUrl('USERS_API_BASE_URL').then(baseUrl => {
    return axios.patch(
      `${baseUrl}/user/toggle-status/${userId}`,
      { IsActive: isActive },
      { withCredentials: true }
    )
      .then(response => response.data)
      .catch(error => {
        console.error('Error toggling user status:', error.response?.data || error.message);
        throw error;
      });
  });
};

// Gestión de Perfiles
export const fetchProfiles = () => {
  return getApiBaseUrl('USERS_API_BASE_URL').then(baseUrl => {
    return axios.get(`${baseUrl}/profile/get-all`, {
      withCredentials: true,
    })
      .then(response => response.data)
      .catch(error => {
        console.error('Error fetching profiles:', error.response?.data || error.message);
        throw error;
      });
  });
};

export const fetchProfile = (profileId = null) => {
  return getApiBaseUrl('USERS_API_BASE_URL').then(baseUrl => {
    return axios.get(`${baseUrl}/profile/get`, {
      params: { ProfileId: profileId },
      withCredentials: true,
    })
      .then(response => response.data)
      .catch(error => {
        console.error('Error fetching profile:', error.response?.data || error.message);
        throw error;
      });
  });
};

export const fetchCreateProfile = (name, grantsList) => {
  return getApiBaseUrl('USERS_API_BASE_URL').then(baseUrl => {
    return axios.post(
      `${baseUrl}/profile/create`,
      {
        Name: name,
        GrantsList: grantsList
      },
      { withCredentials: true }
    )
      .then(response => response.data)
      .catch(error => {
        console.error('Error creating profile:', error.response?.data || error.message);
        throw error;
      });
  });
};

export const fetchUpdateProfile = (profileId, name, grantsList) => {
  return getApiBaseUrl('USERS_API_BASE_URL').then(baseUrl => {
    return axios.post(
      `${baseUrl}/profile/update`,
      {
        ProfileId: profileId,
        Name: name,
        GrantsList: grantsList
      },
      { withCredentials: true }
    )
      .then(response => response.data)
      .catch(error => {
        throw error;
      });
  });
};

export const fetchDeleteProfile = (profileId) => {
  return getApiBaseUrl('USERS_API_BASE_URL').then(baseUrl => {
    return axios.post(
      `${baseUrl}/profile/delete`,
      {
        ProfileId: profileId
      },
      { withCredentials: true }
    )
      .then(response => response.data)
      .catch(error => {
        throw error;
      });
  });
};

// Gestión de Logs
export const fetchLogs = (startDate = null, endDate = null, email = null, processName = null) => {
  return getApiBaseUrl('USERS_API_BASE_URL').then(baseUrl => {

    const params = {
      startDate: startDate,
      endDate: endDate,
      email: email,
      processName: processName
    };

    return axios.get(`${baseUrl}/log/get-all`, {
      params: params,
      withCredentials: true,
    })
      .then(response => response.data)
      .catch(error => {
        throw error;
      });
  });
};