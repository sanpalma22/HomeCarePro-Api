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


  router.get("/:id", async (req,res)=>{
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


router.get("/:id/devolucion", async (req,res)=>{
  
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


router.post('', async (req, res) => {
  const { nombre, localidad, dni, prestacion, telefono, diagnostico, direccion, fechaNacimiento, cantDias, horasDia, prestador } = req.body;
  console.log(prestador)
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
      .input('dni', sql.Int, parseInt(dni)) 
      .input('nombre', sql.NVarChar, nombre)
      .input('apellido', sql.NVarChar, "Pasquale")
      .input('direccion', sql.NVarChar, direccion)
      .input('localidad', sql.NVarChar, localidad)
      .input('telefono', sql.Int, parseInt(telefono))
      .input('fechaNacimiento', sql.DateTime, new Date(fechaNacimiento))
      .query(query1);

    // Obtener el IdPaciente recién insertado
    const result1 = await pool.request()
      .input('dni', sql.Int, parseInt(dni)) 
      .query(`SELECT IdPaciente FROM Paciente WHERE Dni = @dni`);

    if (result1.recordset.length === 0) {
      return res.status(500).json({ error: "Paciente no encontrado" });
    }
    console.log("prestaciopn " + prestacion)


    const idPaciente = result1.recordset[0].IdPaciente;

    // Inserción en la tabla Caso
    const query4 = `
      INSERT INTO Caso (IdPaciente, IdPrestador, IdPrestacion, FechaSolicitud, Diagnostico, CantDias, CantHorasDias, EnCurso)
      VALUES (@idPaciente, @idPrestador, @idPrestacion, @fechaSolicitud, @diagnostico, @cantDias, @cantHorasDias, @enCurso);
    `;
    const fechaSolicitud = new Date();
    const enCurso = true;

    await pool.request()
      .input('idPaciente', sql.Int, idPaciente)
      .input('idPrestador', sql.Int,prestador)
      .input('idPrestacion', sql.Int,prestacion)
      .input('fechaSolicitud', sql.DateTime, fechaSolicitud)
      .input('diagnostico', sql.NVarChar, diagnostico)
      .input('cantDias', sql.Int, parseInt(cantDias))
      .input('cantHorasDias', sql.Int, parseInt(horasDia))
      .input('enCurso', sql.Bit, enCurso)
      .input('IdSituacion', sql.Int, 2)
      .query(query4);

    res.status(201).json({ message: "Caso creado exitosamente" });

  } catch (error) {
    console.error("Error en la inserción:", error);
    res.status(500).json({ error: "Error en la inserción", details: error.message });
  }
});

router.put("/solicitar/:id", async (req,res)=>{
  const id = req.params.id;
  const pool = await getConnection();
  if(pool){
    console.log("hola")
    const result = await pool.request()
                  .input('IdCaso', sql.Int, id)
                  .input('SolicitarCierre', sql.Bit, true) 
                  .query(`UPDATE Caso SET SolicitarCierre = @SolicitarCierre WHERE IdCaso = @IdCaso`);
    res.status(500).json({ message: "Caso solicitado correctamente"});
  }
  })

  //para marcar el caso como cerrado(lo hace el operador)
  router.put("/confirmar/:id", async (req,res)=>{
    const id = req.params.id;
    const pool = await getConnection();
    if(pool){
      console.log("hola")
      const result = await pool.request()
                    .input('IdCaso', sql.Int, id)
                    .input('SolicitarCierre', sql.Bit, false) 
                    .query(`UPDATE Caso SET EnCurso = @SolicitarCierre WHERE IdCaso = @IdCaso`);
      console.log(result.recordset)
    }
    })

    //en caso de que el operador no acepte cerrar el caso
    router.put("/noaceptarcierre/:id", async (req,res)=>{
      const id = req.params.id;
      const pool = await getConnection();
      if(pool){
        console.log("hola")
        const result = await pool.request()
                      .input('IdCaso', sql.Int, id)
                      .input('SolicitarCierre', sql.Bit, false)
                      .query(`UPDATE Caso SET SolicitarCierre = @SolicitarCierre WHERE IdCaso = @IdCaso`);
        console.log(result.recordset)
      }
      })

  export default router;