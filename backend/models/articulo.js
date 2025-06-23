module.exports = (sequelize, DataTypes) => {
  const Articulo = sequelize.define('Articulo', {
    codigo: {
      type: DataTypes.STRING(255),
      allowNull: false,
      unique: true
    },
    nombre: {
      type: DataTypes.STRING(255),
      allowNull: false
    },
    cantidad: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: 0
    },
    precio: {
      type: DataTypes.FLOAT,
      allowNull: false,
      defaultValue: 0
    },
    descripcion: {
      type: DataTypes.TEXT,
      allowNull: true
    },
    categoria: {
      type: DataTypes.ENUM('ropa', 'accesorios', 'cosmeticos', 'calzado', 'otro/a'),
      allowNull: false,
      defaultValue: 'otro/a'
    },
    imagen_url: {
      type: DataTypes.STRING,
      allowNull: true,
      defaultValue: 'assets/images/no-image.jpeg'
    },
    imagen_public_id: {
      type: DataTypes.STRING,
      allowNull: true
    }
  }, {
    tableName: 'articulos',
    timestamps: true,
    paranoid: true
  });

  return Articulo;
};