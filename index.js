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
      console.log(req.params.id);
      const result = await sql.query(`SELECT * FROM InformeDia where IdCaso = ${id} `);
    res.json(result.recordset);
    console.log(result)
  }
}
})
app.post("/casos", async (req, res) => {
  const { Nombre, Localidad, Dni, Prestacion, Telefono, Diagnostico, Direccion, FechaNacimiento, CantDias, CantHorasDias } = req.body;

  if (!Nombre || !Localidad || !Dni || !Prestacion || !Telefono || !Diagnostico || !Direccion || !FechaNacimiento || !CantDias || !CantHorasDias) {
    return res.status(400).json({ error: "Faltan datos" });
  }

  try {
    const pool = await getConnection();

    if (!pool) {
      return res.status(500).json({ error: "No se pudo conectar a la base de datos" });
    }

    // Inserción en la tabla Paciente
    const query1 = `
      INSERT INTO Paciente (Dni, Nombre, Apellido, Direccion, Localidad, Telefono, FechaNacimiento)
      VALUES (@dni, @nombre, @apellido, @direccion, @localidad, @telefono, @fechaNacimiento);
    `;
    await pool.request()
      .input('dni', sql.Int, Dni)
      .input('nombre', sql.NVarChar, Nombre)
      .input('apellido', sql.NVarChar, "Pasquale")
      .input('direccion', sql.NVarChar, Direccion)
      .input('localidad', sql.NVarChar, Localidad)
      .input('telefono', sql.Int, Telefono)
      .input('fechaNacimiento', sql.DateTime, new Date(FechaNacimiento)) // Convertir a objeto Date si es necesario
      .query(query1);

    // Obtener el IdPaciente recién insertado
    const result1 = await pool.request()
      .input('dni', sql.Int, Dni)
      .query(`SELECT IdPaciente FROM Paciente WHERE Dni = @dni`);
    
    const idPaciente = result1.recordset[0].IdPaciente;

    // Inserción en la tabla Caso
    const query2 = `
      INSERT INTO Caso (IdPaciente, FechaSolicitud, Diagnostico, CantDias, CantHorasDias, EnCurso)
      VALUES (@idPaciente, @fechaSolicitud, @diagnostico, @cantDias, @cantHorasDias, @enCurso);
    `;
    const fechaSolicitud = new Date();
    const enCurso = false;
    
    await pool.request()
      .input('idPaciente', sql.Int, idPaciente)
      .input('fechaSolicitud', sql.DateTime, fechaSolicitud)
      .input('diagnostico', sql.NVarChar, Diagnostico)
      .input('cantDias', sql.Int, parseInt(CantDias))
      .input('cantHorasDias', sql.Int, parseInt(CantHorasDias))
      .input('enCurso', sql.Bit, enCurso)
      .query(query2);

    res.status(201).json({ message: "Caso creado exitosamente" });

  } catch (error) {
    console.error("Error en la inserción:", error);
    res.status(500).json({ error: "Error en la inserción" });
  }
});

app.get("/medico/:id", async (req,res)=>{
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

app.get("/medico/:id/devolucion", async (req,res)=>{
  const id = parseInt(req.params.id)
  
  const pool =await getConnection();
  console.log(id)
  if(pool){
    if (pool) {
      console.log("holaaaaaaaaaaa")
      const result = await sql.query( `
      SELECT Caso.Idcaso, InformeDia.Descripcion from Caso INNER JOIN InformeDia ON InformeDia.IdCaso = Caso.IdCaso
      WHERE Caso.IdCaso = ${id}
    `)
    console.log(result.recordset)
    res.json(result);
  }
}
})

app.post("/medico/:id/devolucionn", async (req, res) => { 
  const id = parseInt(req.params.id, 10); // Convertir a número entero
  const { descripcion } = req.body; // Extraer la descripción del cuerpo de la solicitud
  
  console.log("Descripción:", descripcion);

  // Validar el ID y la descripción
  if (isNaN(id)) {
      return res.status(400).json({ error: "ID inválido" });
  }
  if (!descripcion) {
      return res.status(400).json({ error: "Descripción es requerida" });
  }

  try {
      const pool = await getConnection();

      if (!pool) {
          return res.status(500).json({ error: "No se pudo conectar a la base de datos" });
      }

      const fecha = new Date().toISOString();
      const query = `
          INSERT INTO InformeDia (IdCaso, Fecha, Descripcion)
          VALUES (@id, @fecha, @descripcion)
      `;

      const result = await pool.request()
          .input('id', sql.Int, id)
          .input('fecha', sql.DateTime, fecha)
          .input('descripcion', sql.NVarChar, descripcion)
          .query(query);

      console.log(result);

      res.status(201).json(result); // Responder con código de estado 201 para una creación exitosa
  } catch (error) {
      console.error("Error en la inserción:", error);
      res.status(500).json({ error: "Error en la inserción" });
  }
});


// Puerto en el que escucha el servidor
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Servidor backend iniciado en el puerto ${PORT}`);
});