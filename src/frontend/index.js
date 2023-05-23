const express = require('express');
const app = express();
const port = 3001;

const student_model_= require('./models');
const region_model_ = require('./models');
const educator_model_ = require('./models');
app.use(express.json());


app.use(function (req, res, next) {
  res.setHeader('Access-Control-Allow-Origin', 'http://wsl.localhost');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Access-Control-Allow-Headers');
  next();
});

app.get('/student', (req, res) => {
  student_model_.getStudents()
    .then(response => {
      res.status(200).send(response);
    })
    .catch(error => {
      res.status(500).send(error.message);
    });
});

app.get('/educator', (req, res) => {
  educator_model_.getEducators()
    .then(response => {
      res.status(200).send(response);
    })
    .catch(error => {
      res.status(500).send(error.message);
    });
});

app.get('/region', (req, res) => {
  region_model_.getRegion()
    .then(response => {
      res.status(200).send(response);
    })
    .catch(error => {
      res.status(500).send(error.message);
    });
});

app.listen(port, () => {
  console.log(`App running on port ${port}.`);
});