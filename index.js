const config = require("./src/config/dbConfig");
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
  const { nombre, localidad, dni, prestacion, telefono, diagnostico, direccion, fechaNacimiento, cantDias, horasDia } = req.body;

  if (!nombre || !localidad || !dni || !prestacion || !telefono || !diagnostico || !direccion || !fechaNacimiento || !cantDias || !horasDia) {
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
      .input('dni', sql.Int, parseInt(dni)) // Cambiado a dni
      .input('nombre', sql.NVarChar, nombre)
      .input('apellido', sql.NVarChar, "Pasquale")
      .input('direccion', sql.NVarChar, direccion)
      .input('localidad', sql.NVarChar, localidad)
      .input('telefono', sql.Int, parseInt(telefono))
      .input('fechaNacimiento', sql.DateTime, new Date(fechaNacimiento))
      .query(query1);

    // Obtener el IdPaciente recién insertado
    const result1 = await pool.request()
      .input('dni', sql.Int, parseInt(dni)) // Cambiado a dni
      .query(`SELECT IdPaciente FROM Paciente WHERE Dni = @dni`);

    if (result1.recordset.length === 0) {
      return res.status(500).json({ error: "Paciente no encontrado" });
    }

    const idPaciente = result1.recordset[0].IdPaciente;

    // Inserción en la tabla Caso
    const query2 = `
      INSERT INTO Caso (IdPaciente, IdPrestador, IdPrestacion, FechaSolicitud, Diagnostico, CantDias, CantHorasDias, EnCurso)
      VALUES (@idPaciente, @idPrestador, @idPrestacion, @fechaSolicitud, @diagnostico, @cantDias, @cantHorasDias, @enCurso);
    `;
    const fechaSolicitud = new Date();
    const enCurso = true;

    await pool.request()
      .input('idPaciente', sql.Int, idPaciente)
      .input('idPrestador', sql.Int,1)
      .input('idPrestacion', sql.Int,1)
      .input('fechaSolicitud', sql.DateTime, fechaSolicitud)
      .input('diagnostico', sql.NVarChar, diagnostico)
      .input('cantDias', sql.Int, parseInt(cantDias))
      .input('cantHorasDias', sql.Int, parseInt(horasDia))
      .input('enCurso', sql.Bit, enCurso)
      .query(query2);

    res.status(201).json({ message: "Caso creado exitosamente" });

  } catch (error) {
    console.error("Error en la inserción:", error);
    res.status(500).json({ error: "Error en la inserción", details: error.message });
  }
});

app.get("/medicos", async (req, res) => {
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


app.get("/medicoo/login", async (req, res) => {
  try {
      console.log("entro");
      
      // Obtener el valor del mail del query string (en lugar de req.body)
      const { mail } = req.query;
      console.log("Mail:", mail);
      
      // Obtener la conexión a la base de datos
      const pool = await getConnection();
      
      if (pool) {
          console.log("holaaaaaaaaaaa");
          
          // Consulta SQL usando parámetros
          const result = await pool.request()
              .input('mail', sql.VarChar, mail) // Usar parámetros para evitar problemas
              .query('SELECT IdPrestador, Contraseña FROM Prestador WHERE Email = @mail');
              
          console.log(result.recordset);
          res.json(result.recordset);
      } else {
          res.status(500).json({ error: 'No se pudo establecer conexión con la base de datos' });
      }
  } catch (err) {
      console.error('Error en la solicitud:', err);
      res.status(500).json({ error: 'Error en el servidor' });
  }
});


app.put("/medicooo/contrasena", async (req, res) => {
  try {
      console.log("entro");
      
      // Obtener el valor del mail y la contraseña del cuerpo de la solicitud
      const { email, contraseña } = req.body;

      console.log("Mail:", email);
      console.log("Contraseña:", contraseña);

      // Obtener la conexión a la base de datos
      const pool = await getConnection();

      if (pool) {
          console.log("Conexión a la base de datos establecida");

          // Consulta SQL para actualizar la contraseña
          await pool.request()
              .input('email', sql.VarChar, email)
              .input('contraseña', sql.VarChar, contraseña)
              .query('UPDATE Prestador SET Contraseña = @contraseña WHERE Email = @email');

          console.log("Contraseña cambiada correctamente");

          // Consulta SQL para obtener el IdPrestador
          const result1 = await pool.request()
              .input('email', sql.VarChar, email) // Asegúrate de pasar el parámetro
              .query('SELECT IdPrestador FROM Prestador WHERE Email = @email');

          console.log(result1.recordset);

          // Devolver el IdPrestador en la respuesta
          res.json(result1.recordset);
      } else {
          res.status(500).json({ error: 'No se pudo establecer conexión con la base de datos' });
      }
  } catch (err) {
      console.error('Error en la solicitud:', err);
      res.status(500).json({ error: 'Error en el servidor' });
  }
});

// Puerto en el que escucha el servidor
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Servidor backend iniciado en el puerto ${PORT}`);
});