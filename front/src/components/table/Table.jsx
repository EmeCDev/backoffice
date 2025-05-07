import PropTypes from 'prop-types';
import './table.css';

const Table = ({ headers, columns, objectName }) => {
    return (
        <div className="table-c-container">
            <table>
                <thead>
                    <tr>
                        {headers.map((header, index) => (
                            <th key={index}>{header}</th>
                        ))}
                    </tr>
                </thead>
                <tbody>
                    {columns.length > 0 ? (
                        columns.map((row, rowIndex) => (
                            <tr key={rowIndex}>
                                {row.map((cell, cellIndex) => (
                                    <td key={cellIndex}>{cell}</td>
                                ))}
                            </tr>
                        ))
                    ) : (
                        <tr>
                            <td className='table-c-no-results' colSpan={headers.length}>No hay {objectName} disponible(s).</td>
                        </tr>
                    )}
                </tbody>

            </table>
        </div>
    );
};

Table.propTypes = {
    headers: PropTypes.arrayOf(PropTypes.string).isRequired,
    columns: PropTypes.arrayOf(
        PropTypes.arrayOf(PropTypes.node)
    ).isRequired,
    objectName: PropTypes.string.isRequired
};

export default Table;