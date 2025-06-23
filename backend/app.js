require('dotenv').config();
const express = require('express');
const cors = require('cors');
const path = require('path');
const database = require('./config/database');

const app = express();


app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));


const articuloRoutes = require('./routes/articuloRoutes');
app.use('/api', articuloRoutes);


app.use('/public', express.static(path.join(__dirname, 'public')));


console.log('Cloudinary Config:', {
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY?.slice(0, 5) + '...'
});


app.get('/', (req, res) => {
  res.send('Backend funcionando correctamente');
});


app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).send('Algo salió mal!');
});


const PORT = process.env.PORT || 3000;
database.authenticate()
  .then(() => {
    console.log('Conexión a BD establecida');
    return database.sync({ alter: true });
  })
  .then(() => {
    app.listen(PORT, () => {
      console.log(`Servidor corriendo en http://localhost:${PORT}`);
      console.log('Endpoint de artículos: http://localhost:3000/api/articulos');
    });
  })
  .catch(err => {
    console.error('Error de conexión:', err);
    process.exit(1);
  });

module.exports = app;