const { Pool } = require('pg');

const pool = new Pool({
  user: 'dm-user',
  host: '172.28.171.137',
  database: 'datamine_db',
  password: 'datamine-password',
  port: 5432,
});

const getStudents = () => {
  return new Promise((resolve, reject) => {
    pool.query('SELECT * FROM student', (error, results) => {
      if (error) {
        reject(error);
      } else {
        resolve(results.rows);
      }
    });
  });
};

const tableBody = document.querySelector('.table-body');

getStudents()
  .then((queryResult) => {
    queryResult.forEach((row) => {
      const tableRow = document.createElement('tr');
      tableRow.innerHTML = `
        <td>${row.studentid}</td>
        <td>${row.studentname}</td>
        <td>${row.studentlastname}</td>
        <td>${row.regionid}</td>
      `;
      tableBody.appendChild(tableRow);
    });
  })
  .catch((error) => {
    console.error('Error retrieving students:', error);
  });
