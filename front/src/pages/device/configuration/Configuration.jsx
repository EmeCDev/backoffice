import { useState } from 'react';
import { toast } from 'react-toastify';
import { useNavigate } from 'react-router-dom';
import { fetchCompaniesInfo } from '../../../api/zkManagementApiRequests';
import { PUBLIC_ROUTES } from '../../../routes';
import urlIcon from '../../../assets/icons/url.png';
import './configuration.css';

const Configuration = () => {
  const [rutEmpresa, setRutEmpresa] = useState('');
  const [nombreEmpresa, setNombreEmpresa] = useState('');
  const [resultados, setResultados] = useState([]);
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  const servers = [
    {
      id: 1,
      name: 'Servidor 1 (www2)',
      ip: '20.65.46.237',
      configuraciones: {
        linea_h: {
          nombre: 'LINEA H',
          puerto: 8085,
          tempoh_webservices: {
            Asistencia: 'WS_TEMPOH_SUFIJO',
            Accesso: 'WS_ACCESOH_SUFIJO',
            Casino: 'WS_SNACKH_SUFIJO',
            Presencia: 'WS_PRESENCIAH_SUFIJO'
          }
        },
        injes_a8: {
          nombre: 'INJES A8',
          puerto: 8086
        },
        injes_a9_a35_a36_dt20: {
          nombre: 'INJES A9/A35/A36/DT20',
          puerto: 8088
        },
        zk: {
          nombre: 'CONFIGURACIÓN ZK',
          dns: 'clghz0xp1sl02.genera.cl'
        }
      }
    },
    {
      id: 2,
      name: 'Servidor 2 (www3)',
      ip: '20.65.46.237',
      configuraciones: {
        linea_h: {
          nombre: 'LINEA H',
          puerto: 8085,
          tempoh_webservices: {
            Asistencia: 'WS_TEMPOH_SUFIJO',
            Accesso: 'WS_ACCESOH_SUFIJO',
            Casino: 'WS_SNACKH_SUFIJO',
            Presencia: 'WS_PRESENCIAH_SUFIJO'
          }
        },
        injes_a8: {
          nombre: 'INJES A8',
          puerto: 8087
        },
        injes_a9_a35_a36_dt20: {
          nombre: 'INJES A9/A35/A36/DT20',
          puerto: 8089
        },
        zk: {
          nombre: 'CONFIGURACIÓN ZK',
          dns: 'clghz0xp2sl02.genera.cl'
        }
      }
    },
    {
      id: 3,
      name: 'Servidor 3 (www6)',
      ip: '20.65.46.237',
      configuraciones: {
        linea_h: {
          nombre: 'LINEA H',
          puerto: 8085,
          tempoh_webservices: {
            Asistencia: 'WS_TEMPOH_SUFIJO',
            Accesso: 'WS_ACCESOH_SUFIJO',
            Casino: 'WS_SNACKH_SUFIJO',
            Presencia: 'WS_PRESENCIAH_SUFIJO'
          }
        },
        injes_a8: {
          nombre: 'INJES A8',
          puerto: 8089
        },
        injes_a9_a35_a36_dt20: {
          nombre: 'INJES A9/A35/A36/DT20',
          puerto: 8090
        },
        zk: {
          nombre: 'CONFIGURACIÓN ZK',
          dns: 'clghz0xp3sl02.genera.cl'
        }
      }
    }
  ];

  const fetchClientConfig = async () => {
    if (loading) return;

    setLoading(true);

    fetchCompaniesInfo(rutEmpresa, nombreEmpresa)
      .then(response => {
        if (response) {
          toast.success(response.message);
          setResultados(response.data);
        }
      })
      .catch(error => {
        if (error.code === "ERR_NETWORK") {
          toast.error("No se pudo conectar al servidor");
        } else if (error.response?.data) {
          const { statusCode, message } = error.response.data;
          if (statusCode === 401) {
            toast.warning("Su sesión ha expirado.");
            navigate(PUBLIC_ROUTES.LOGIN.FULL_PATH, { replace: true });
          } else {
            toast.warning(message);
            setResultados([]);
          }
        }
      })
      .finally(() => {
        setLoading(false);
      })
  };

  const handleBuscar = (e) => {
    e.preventDefault();
    fetchClientConfig();
  };

  const handleReset = () => {
    setRutEmpresa('');
    setNombreEmpresa('');
    setResultados([]);
  };

  return (
    <div className="zk-config-container">
      <form onSubmit={handleBuscar} className="zk-search-section">
        <h3 className="zk-section-subtitle">Filtros de búsqueda:</h3>
        <div className="zk-search-fields">
          <div className="zk-input-group">
            <label>Nombre:</label>
            <input
              type="text"
              value={nombreEmpresa}
              onChange={(e) => setNombreEmpresa(e.target.value)}
              placeholder="Empresa . . ."
              disabled={loading}
            />
          </div>
          <div className="zk-input-group">
            <label>RUT empresa (sin dv):</label>
            <input
              type="text"
              value={rutEmpresa}
              onChange={(e) => setRutEmpresa(e.target.value)}
              placeholder="12345678 . . ."
              disabled={loading}
            />
          </div>
        </div>
        <div className="zk-action-buttons">
          <button
            type='submit'
            className="zk-btn zk-btn-primary"
            disabled={loading}
          >
            {loading ? 'Buscando...' : 'Buscar'}
          </button>
          <button
            className="zk-btn zk-btn-secondary"
            onClick={handleReset}
            disabled={loading}
          >
            Borrar Filtros
          </button>
        </div>
      </form>

      {resultados && (
        <div className="zk-results-section">
          <h3 className="zk-section-subtitle">Resultados:</h3>
          {loading ? (
            <div className="zk-loading">Cargando resultados...</div>
          ) : resultados.length > 0 ? (
            <div className="zk-table-container">
              <table className="zk-results-table">
                <thead className="sticky-header">
                  <tr>
                    <th>RUT</th>
                    <th>Nombre Empresa</th>
                    <th>Servidor</th>
                    <th>Tipo Cliente</th>
                    <th>BD</th>
                    <th>URL</th>
                  </tr>
                </thead>
                <tbody>
                  {resultados.map(item => (
                    <tr key={item.id}>
                      <td>{`${item.rutEmpresa}-${item.dv}`}</td>
                      <td>{item.nombreEmpresa}</td>
                      <td>
                        {item.servidor === 'BD1' ? 'Servidor 1' :
                          item.servidor === 'BD2' ? 'Servidor 2' :
                            item.servidor === 'BD3' ? 'Servidor 3' :
                              item.servidor}
                      </td>
                      <td>{item.tipoCliente}</td>
                      <td>{item.bdGenhoras}</td>
                      <td>
                        <a href={item.urlCliente} target="_blank" rel="noopener noreferrer">
                          <img className='urlcliente-img' src={urlIcon} alt="URL Cliente" />
                        </a>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          ) : (
            <div className="zk-no-results">
              No se encontraron resultados. Realice una búsqueda para ver los datos.
            </div>
          )}
        </div>
      )}

      <div className="zk-servers-section">
        <h3 className="zk-section-subtitle">Configuraciones de equipo por servidor</h3>
        <div className="zk-servers-grid">
          {servers.map((server) => (
            <div key={server.id} className="zk-server-card">
              <div className="zk-card-header">
                <h3>{server.name}</h3>
                <div className="zk-server-meta">
                  <div className="zk-meta-item">
                    <span>IP:</span>
                    <span>{server.ip}</span>
                  </div>
                </div>
              </div>
              <div className="zk-card-body">
                {Object.entries(server.configuraciones).map(([key, config]) => (
                  <div key={key} className="zk-config-section">
                    <h4>{config.nombre}</h4>
                    <div className="zk-config-details">
                      {config.puerto && (
                        <div className="zk-detail-row">
                          <span>Puerto:</span>
                          <span>{config.puerto}</span>
                        </div>
                      )}
                      {config.dns && (
                        <div className="zk-detail-row">
                          <span>DNS:</span>
                          <span>{config.dns}</span>
                        </div>
                      )}
                      {key === 'linea_h' && config.tempoh_webservices && (
                        <div className="zk-webservices">
                          <h5>Webservices:</h5>
                          {Object.entries(config.tempoh_webservices).map(([wsKey, wsValue]) => (
                            <div key={wsKey} className="zk-detail-row">
                              <span>{wsKey}:</span>
                              <span>{wsValue}</span>
                            </div>
                          ))}
                        </div>
                      )}
                    </div>
                  </div>
                ))}
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default Configuration;