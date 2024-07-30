const config = require("./config/dbConfig");
const express = require("express");
const cors = require("cors");
const sql = require("mssql");
const app = express();

app.use(cors());
app.use(express.json());

// Configuración de la conexión a la base de datos MSSQL

const getConnection = async () => {
  try {
    const pool = await sql.connect(config); //http://localhost:5000
    return pool;
  } catch (error) {
    console.error("Error al conectar con la base de datos:", error.message, error.code);

  }
}; 

// Ruta para obtener los casos activos desde la base de datos
app.get("/casos", async (req, res) => {
  try {
    const pool = await getConnection();
    if (pool) {
      const result = await sql.query(`
            SELECT 
                C.IdCaso,
                C.FechaOcurrencia,
                C.FechaSolicitud,
                C.Diagnostico,
                P.Nombre AS NombrePaciente,
                PR.Nombre AS NombrePrestador,
                PS.Nombre AS NombrePrestacion
            FROM 
                Caso C
                INNER JOIN Paciente P ON C.IdPaciente = P.IdPaciente
                INNER JOIN Prestador PR ON C.IdPrestador = PR.IdPrestador
                INNER JOIN Prestacion PS ON C.IdPrestacion = PS.IdPrestacion`);
      res.json(result.recordset);
    } else {
      res.status(500).json({ message: "No se pudo establecer conexión con la base de datos" });
    }
  } catch (error) {
    console.error("Error al obtener los casos activos:", error);
    res.status(500).json({ message: "Error interno del servidor" });
  }
});

app.get("/casos/:id", async (req,res)=>{
    const id = parseInt(req.params.id)
    const pool =await getConnection();
    if(pool){
      if (pool) {
        const result = await sql.query(`
              SELECT 
                  C.IdCaso,
                  C.FechaOcurrencia,
                  C.FechaSolicitud,
                  C.Diagnostico,
                  P.Nombre AS NombrePaciente,
                  PR.Nombre AS NombrePrestador,
                  PS.Nombre AS NombrePrestacionX
              FROM 
                  Caso C
                  INNER JOIN Paciente P ON C.IdPaciente = P.IdPaciente
                  INNER JOIN Prestador PR ON C.IdPrestador = PR.IdPrestador
                  INNER JOIN Prestacion PS ON C.IdPrestacion = PS.IdPrestacion
              WHERE
                  C.IdCaso = ${id}`);
              
      res.json(result.recordset);
    }
  }
})

app.get("/casos/:id/devolucion", async (req,res)=>{
  const id = parseInt(req.params.id)
  const pool =await getConnection();
  if(pool){
    if (pool) {
      console.log("hola")
      const result = await sql.query(`SELECT * FROM InformeDia`);
    res.json(result.recordset);
    console.log(result)
  }
}
})

app.get("/medico/:id", async (req,res)=>{
  const id = parseInt(req.params.id)
  const pool =await getConnection();
  if(pool){
    if (pool) {
      console.log("hola")
      const result = await sql.query( `
      SELECT c.IdCaso, c.FechaOcurrencia, c.FechaSolicitud, c.Diagnostico, c.CantDias, c.CantHorasDias, c.EnCurso, c.Idcaso, pa.Dni, pa.Nombre, pa.Apellido, pa.Direccion, pa.Localidad, pa.Telefono, pa.FechaNacimiento, pr.Nombre as NombrePrestador
      FROM Caso AS c INNER JOIN Paciente as pa ON pa.IdPaciente = c.IdPaciente
      INNER JOIN Prestador as pr ON pr.IdPrestador = c.IdPrestador
      
      WHERE c.IdPrestador = ${id}
    `)
    console.log(result.recordset)
    res.json(result.recordset);

  }
}
})

app.get("/medico/:id/devolucion", async (req,res)=>{
  const id = parseInt(req.params.id)
  const pool =await getConnection();
  if(pool){
    if (pool) {
      console.log("hola")
      const result = await sql.query( `
      SELECT id.Descripcion from Caso as c INNER JOIN InformeDia as id ON id.IdCaso = c.IdCaso
      WHERE c.IdCaso = ${id}
    `)
    console.log(result.recordset)
    res.json(result.recordset);

  }
}
})

// Puerto en el que escucha el servidor
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Servidor backend iniciado en el puerto ${PORT}`);
});