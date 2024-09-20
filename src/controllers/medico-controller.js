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



router.get('', async (req, res) => {
  try {
    const pool = await getConnection();
    if (pool) {
      const result = await sql.query(`
            SELECT 
                P.*,
                E.Nombre AS Especialidad
            FROM 
                Prestador P
                INNER JOIN Especialidad E ON P.IdEspecialidad = E.IdEspecialidad`);
      res.json(result.recordset);
    } else {
      res.status(500).json({ message: "No se pudo establecer conexión con la base de datos" });
    }
  } catch (error) {
    console.error("Error al obtener los casos activos:", error);
    res.status(500).json({ message: "Error interno del servidor" });
  }
});




router.get("/:id", async (req,res)=>{
  const id = parseInt(req.params.id)
  const pool =await getConnection();
  if(pool){
    if (pool) {
      console.log("hola")
      const result = await sql.query( `
      SELECT c.IdCaso, c.FechaOcurrencia, c.FechaSolicitud, c.Diagnostico, c.CantDias, c.CantHorasDias, c.EnCurso, c.Idcaso, pa.IdPaciente, pa.Dni, pa.Nombre, pa.Apellido, pa.Direccion, pa.Localidad, pa.Telefono, pa.FechaNacimiento, pr.Nombre as NombrePrestador
      FROM Caso AS c INNER JOIN Paciente as pa ON pa.IdPaciente = c.IdPaciente
      INNER JOIN Prestador as pr ON pr.IdPrestador = c.IdPrestador
      
      WHERE c.IdPrestador = ${id}
    `)
    console.log(result.recordset)
    res.json(result.recordset);

  }
}
})




export default router;