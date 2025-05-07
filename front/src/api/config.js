let config = null;

export const loadConfig = () => {
  if (config) return Promise.resolve();

  return fetch('/portal-backoffice/config.json')
    .then(response => {
      if (!response.ok) {
        throw new Error('Error cargando config.json');
      }
      return response.json();
    })
    .then(loadedConfig => {
      config = loadedConfig;
    })
    .catch(error => {
      throw error;
    });
};

export const getApiBaseUrl = (apiType) => {
  if (!config) {
    return loadConfig()
      .then(() => {
        return config ? config[apiType] : null;
      });
  }
  return Promise.resolve(config[apiType]);
};