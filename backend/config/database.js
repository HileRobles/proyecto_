const { Sequelize } = require('sequelize');

const database = new Sequelize('proyecto_bd', 'root', '', {
  host: 'localhost',
  dialect: 'mysql',
  logging: false,
  define: {
    timestamps: true,
    freezeTableName: true
  }
});

database.authenticate()
  .then(() => console.log('Conexión a MySQL establecida'))
  .catch(err => console.error('Error de conexión a MySQL:', err));

module.exports = database;