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

router.get('/:id', async(req,res)=>{
const prestadorId = parseInt(req.params.id);
try {
  const pool = await getConnection();
if(pool){
  const result = await sql.query(`SELECT 
  P.*,
  E.Nombre AS Especialidad
FROM 
  Prestador P
  INNER JOIN Especialidad E ON P.IdEspecialidad = E.IdEspecialidad where P.IdPrestador = ${prestadorId}`);
  res.json(result.recordset);
  }
  else {
    res.status(500).json({ message: "No se pudo establecer conexión con la base de datos" });
  }
} catch (error) {
  console.error("Error al obtener los casos activos:", error);
  res.status(500).json({ message: "Error interno del servidor" });
}
})

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


  router.put("/baja/:id", async (req,res)=>{
    const id = req.params.id;
    const pool = await getConnection();
    if(pool){
      console.log("entro")
      const result = await pool.request()
                    .input('IdPrestador', sql.Int, id)
                    .input('BajaMedico', sql.Bit, false) 
                    .query(`UPDATE Prestador SET Activo = @BajaMedico WHERE IdPrestador = @IdPrestador`);
      console.log(result.recordset)
    }
    })


export default router;