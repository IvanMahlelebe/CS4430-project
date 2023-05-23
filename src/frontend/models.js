const { Pool } = require('pg');

const pool = new Pool({
  user: 'dm-user',
  host: '172.21.0.3',
  database: 'datamine_db',
  password: 'datamine-password',
  port: 5432,
});

const getStudents = () => {
  return new Promise((resolve, reject) => {
    pool.query('SELECT * FROM student LIMIT 10;', (error, results) => {
      if (error) {
        reject(error);
      } else {
        resolve(results.rows);
      }
    });
  });
};

const getEducators = () => {
  return new Promise((resolve, reject) => {
    pool.query('SELECT * FROM educator LIMIT 10', (error, results) => {
      if (error) {
        reject(error);
      } else {
        resolve(results.rows);
      }
    });
  });
};



const getRegion = () => {
  return new Promise((resolve, reject) => {
    pool.query('SELECT * FROM region', (error, results) => {
      if (error) {
        reject(error);
      } else {
        resolve(results.rows);
      }
    });
  });
}



module.exports = {
  getStudents,
  getRegion,
  getEducators
};