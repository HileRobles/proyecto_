const database = require('../config/database');
const Articulo = require('../models/articulo')(database, database.Sequelize.DataTypes);
const { cloudinary } = require('../config/cloudinary');
const { Op } = database.Sequelize;

exports.crear = async (req, res) => {
  try {
    const { codigo, nombre, cantidad, precio, descripcion, categoria } = req.body;
    
    if (!codigo || !nombre) {
      return res.status(400).json({ error: 'Código y nombre son obligatorios' });
    }

    const imagenData = req.file ? {
      imagen_url: req.file.path,
      imagen_public_id: req.file.filename
    } : {
      imagen_url: 'assets/images/no-image.jpeg',
      imagen_public_id: null
    };

    const articulo = await Articulo.create({
      codigo,
      nombre,
      cantidad: parseInt(cantidad) || 0,
      precio: parseFloat(precio) || 0,
      descripcion: descripcion || null,
      categoria: categoria || 'otro/a',
      ...imagenData
    });

    res.status(201).json({
      mensaje: 'Artículo creado exitosamente',
      articulo
    });
  } catch (error) {
    console.error('Error en crear artículo:', error.stack);
    
    if (req.file?.filename) {
      await cloudinary.uploader.destroy(req.file.filename).catch(e => console.error('Error al borrar imagen fallida:', e));
    }

    res.status(500).json({
      error: 'Error al crear artículo',
      detalle: process.env.NODE_ENV === 'development' ? error.message : 'Error interno'
    });
  }
};

exports.listar = async (req, res) => {
  try {
    const articulos = await Articulo.findAll({
      order: [['createdAt', 'DESC']]
    });
    res.json(articulos);
  } catch (error) {
    console.error('Error al listar artículos:', error);
    res.status(500).json({ error: 'Error al obtener artículos' });
  }
};

exports.buscarPorId = async (req, res) => {
  try {
    const articulo = await Articulo.findByPk(req.params.id);
    if (!articulo) {
      return res.status(404).json({ error: 'Artículo no encontrado' });
    }
    res.json(articulo);
  } catch (error) {
    console.error('Error al buscar artículo por ID:', error);
    res.status(500).json({ error: 'Error en la búsqueda' });
  }
};

exports.buscar = async (req, res) => {
  try {
    const { q: query } = req.query;
    
    if (!query || query.trim() === '') {
      return res.status(400).json({ error: 'Debe proporcionar un término de búsqueda' });
    }

    const articulos = await Articulo.findAll({
      where: {
        [Op.or]: [
          { nombre: { [Op.like]: `%${query}%` } },
          { codigo: { [Op.like]: `%${query}%` } }
        ]
      },
      order: [['nombre', 'ASC']]
    });
    
    res.json(articulos);
  } catch (error) {
    console.error('Error en búsqueda:', error);
    res.status(500).json({ 
      error: 'Error en la búsqueda',
      detalle: process.env.NODE_ENV === 'development' ? error.message : null
    });
  }
};

exports.actualizar = async (req, res) => {
  try {
    const { id } = req.params;
    const { codigo, nombre, cantidad, precio, descripcion, categoria } = req.body;
    
    const articulo = await Articulo.findByPk(id);
    if (!articulo) {
      return res.status(404).json({ error: 'Artículo no encontrado' });
    }

    let imagenData = {};
    if (req.file) {
      if (articulo.imagen_public_id) {
        await cloudinary.uploader.destroy(articulo.imagen_public_id);
      }
      imagenData = {
        imagen_url: req.file.path,
        imagen_public_id: req.file.filename
      };
    }

    await articulo.update({
      codigo: codigo || articulo.codigo,
      nombre: nombre || articulo.nombre,
      cantidad: cantidad ? parseInt(cantidad) : articulo.cantidad,
      precio: precio ? parseFloat(precio) : articulo.precio,
      descripcion: descripcion || articulo.descripcion,
      categoria: categoria || articulo.categoria,
      ...imagenData
    });

    res.json(articulo);
  } catch (error) {
    console.error('Error al actualizar artículo:', error);
    
    if (req.file?.filename) {
      await cloudinary.uploader.destroy(req.file.filename).catch(console.error);
    }

    res.status(500).json({ 
      error: 'Error al actualizar artículo',
      detalle: process.env.NODE_ENV === 'development' ? error.message : null
    });
  }
};

exports.eliminar = async (req, res) => {
  try {
    const articulo = await Articulo.findByPk(req.params.id);
    if (!articulo) {
      return res.status(404).json({ error: 'Artículo no encontrado' });
    }

    if (articulo.imagen_public_id) {
      await cloudinary.uploader.destroy(articulo.imagen_public_id);
    }

    await articulo.destroy();
    res.json({ mensaje: 'Artículo eliminado correctamente' });
  } catch (error) {
    console.error('Error al eliminar artículo:', error);
    res.status(500).json({ error: 'Error al eliminar artículo' });
  }
};

exports.buscarPorNombre = async (req, res) => {
  try {
    const articulos = await Articulo.findAll({ 
      where: { nombre: { [Op.like]: `%${req.params.nombre}%` } }
    });
    res.json(articulos);
  } catch (error) {
    console.error('Error en búsqueda por nombre:', error);
    res.status(500).json({ error: 'Error en la búsqueda' });
  }
};

exports.buscarPorCodigo = async (req, res) => {
  try {
    const articulo = await Articulo.findOne({ where: { codigo: req.params.codigo } });
    if (!articulo) return res.status(404).json({ error: 'Artículo no encontrado' });
    res.json(articulo);
  } catch (error) {
    console.error('Error en búsqueda por código:', error);
    res.status(500).json({ error: 'Error en la búsqueda' });
  }
};