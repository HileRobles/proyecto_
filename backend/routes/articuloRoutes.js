const express = require('express');
const router = express.Router();
const articuloController = require('../controllers/articuloController');
const { upload } = require('../config/cloudinary');


router.get('/articulos/buscar', articuloController.buscar); 
router.post('/articulos', upload.single('imagen'), articuloController.crear);
router.get('/articulos', articuloController.listar);
router.get('/articulos/:id', articuloController.buscarPorId);
router.put('/articulos/:id', upload.single('imagen'), articuloController.actualizar);
router.delete('/articulos/:id', articuloController.eliminar);


router.get('/articulos/buscar/nombre/:nombre', articuloController.buscarPorNombre);
router.get('/articulos/buscar/codigo/:codigo', articuloController.buscarPorCodigo);


module.exports = router;