import { Router } from "express";
import config from "../config/dbConfig.js";
import sql from "mssql";

let router = Router();
const getConnection = async () => {
  try {
    const pool = await sql.connect(config); //http://localhost:5000
    return pool;
  } catch (error) {
    console.error("Error al conectar con la base de datos:", error.message, error.code);

  }
}; 


router.post('', async (req, res) => {
    const { dni, nombre, apellido, direccion, localidad, telefono, email, genero, contraseña,especialidad } = req.body;
  
    if (!nombre || !localidad || !dni || !apellido || !telefono || !email || !direccion || !genero || !contraseña) {
      return res.status(400).json({ error: "Faltan datos" });
    }
  
    try {
      const pool = await getConnection();
  
      if (!pool) {
        return res.status(500).json({ error: "No se pudo conectar a la base de datos" });
      }
  
      // Inserción en la tabla Paciente
      const query1 = `
        INSERT INTO Prestador (IdEspecialidad, Dni, Nombre, Apellido, Direccion, Localidad, Telefono, Email, Genero, Contraseña)
        VALUES (@idEspecialidad, @dni, @nombre, @apellido, @direccion, @localidad, @telefono, @email, @genero, @contraseña);
      `;
      await pool.request()
        .input('idEspecialidad', sql.Int, especialidad) // Cambiado a dni
        .input('dni', sql.Int, dni) // Cambiado a dni
        .input('nombre', sql.NVarChar, nombre)
        .input('apellido', sql.NVarChar, apellido)
        .input('direccion', sql.NVarChar, direccion)
        .input('localidad', sql.NVarChar, localidad)
        .input('telefono', sql.Int, parseInt(telefono))
        .input('email', sql.NVarChar, email)
        .input('genero', sql.NVarChar, genero)
        .input('contraseña', sql.NVarChar, contraseña)
        .query(query1);
  
  
    
      res.status(201).json({ message: "Prestador creado exitosamente" });
  
    } catch (error) {
      console.error("Error en la inserción:", error);
      res.status(500).json({ error: "Error en la inserción", details: error.message });
    }
  });



export default router;