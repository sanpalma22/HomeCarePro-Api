import { Router } from "express";
import config from "../config/dbConfig.js";
import sql from "mssql";
import Mail from "nodemailer/lib/mailer/index.js";

let router = Router();
const getConnection = async () => {
  try {
    const pool = await sql.connect(config); //http://localhost:5000
    return pool;
  } catch (error) {
    console.error(
      "Error al conectar con la base de datos:",
      error.message,
      error.code
    );
  }
};

router.get("", async (req, res) => {
  try {
    const pool = await getConnection();
    if (pool) {
      const result = await sql.query(`
              SELECT 
                  C.IdCaso,
                  C.FechaOcurrencia,
                  C.FechaSolicitud,
                  C.Diagnostico,
                  C.IdSituacion,
                  S.Nombre AS NombreSituacion,
                  P.Nombre AS NombrePaciente,
                  PR.Nombre AS NombrePrestador,
                  PS.Nombre AS NombrePrestacion
              FROM 
                  Caso C
                  INNER JOIN Paciente P ON C.IdPaciente = P.IdPaciente
                  INNER JOIN Prestador PR ON C.IdPrestador = PR.IdPrestador
                  INNER JOIN Prestacion PS ON C.IdPrestacion = PS.IdPrestacion
                  INNER JOIN Situacion S ON C.IdSituacion = S.IdSituacion`);
      res.json(result.recordset);
    } else {
      res
        .status(500)
        .json({
          message: "No se pudo establecer conexión con la base de datos",
        });
    }
  } catch (error) {
    console.error("Error al obtener los casos activos:", error);
    res.status(500).json({ message: "Error interno del servidor" });
  }
});

router.get("/:id", async (req, res) => {
  const id = parseInt(req.params.id);
  const pool = await getConnection();
  if (pool) {
    if (pool) {
      const result = await sql.query(`
              SELECT 
                  C.IdCaso,
                  C.FechaOcurrencia,
                  C.FechaSolicitud,
                  C.Diagnostico,
                  C.IdSituacion,
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
});

router.get("/:id/devolucion", async (req, res) => {
  const id = parseInt(req.params.id);
  const pool = await getConnection();
  if (pool) {
    if (pool) {
      console.log("hola");
      console.log(req.params.id);
      const result =
        await sql.query(`SELECT InformeDia.*, Caso.IdSituacion, Caso.IdPrestador
      FROM InformeDia
      INNER JOIN Caso ON Caso.IdCaso = InformeDia.IdCaso
      WHERE Caso.IdCaso = ${id} `);
      res.json(result.recordset);
      console.log(result);
    }
  }
});

router.post("", async (req, res) => {
  const {
    nombre,
    localidad,
    dni,
    prestacion,
    telefono,
    diagnostico,
    direccion,
    fechaNacimiento,
    cantDias,
    horasDia,
    prestador,
    mail
  } = req.body;

  // Validar datos
  if (
    !nombre ||
    !localidad ||
    !dni ||
    !prestacion ||
    !telefono ||
    !diagnostico ||
    !direccion ||
    !fechaNacimiento ||
    !cantDias ||
    !horasDia ||
    !prestador ||
    !mail
  ) {
    return res.status(400).json({ error: "Faltan datos" });
  }

  try {
    const pool = await getConnection();
    if (!pool) {
      return res
        .status(500)
        .json({ error: "No se pudo conectar a la base de datos" });
    }

    // Insertar en tabla Paciente
    const queryPaciente = `
      INSERT INTO Paciente (Dni, Nombre, Direccion, Localidad, Telefono, FechaNacimiento, mail)
      VALUES (@dni, @nombre, @direccion, @localidad, @telefono, @fechaNacimiento, @mail);
    `;
    await pool
      .request()
      .input("dni", sql.Int, parseInt(dni))
      .input("nombre", sql.NVarChar, nombre)
      .input("direccion", sql.NVarChar, direccion)
      .input("localidad", sql.NVarChar, localidad)
      .input("telefono", sql.NVarChar, telefono)
      .input("fechaNacimiento", sql.DateTime, new Date(fechaNacimiento))
      .input("mail", sql.NVarChar, mail)

      .query(queryPaciente);

    // Obtener IdPaciente
    const result = await pool
      .request()
      .input("dni", sql.Int, parseInt(dni))
      .query("SELECT IdPaciente FROM Paciente WHERE Dni = @dni");
    const idPaciente = result.recordset[0]?.IdPaciente;

    if (!idPaciente) {
      return res
        .status(500)
        .json({ error: "Paciente no encontrado tras la inserción" });
    }

    // Insertar en tabla Caso
    const queryCaso = `
      INSERT INTO Caso (IdPaciente, IdPrestador, IdPrestacion, FechaSolicitud, Diagnostico, CantDias, CantHorasDias, IdSituacion)
      VALUES (@idPaciente, @idPrestador, @idPrestacion, @fechaSolicitud, @diagnostico, @cantDias, @cantHorasDias, 2);
    `;
    await pool
      .request()
      .input("idPaciente", sql.Int, idPaciente)
      .input("idPrestador", sql.Int, prestador)
      .input("idPrestacion", sql.Int, prestacion)
      .input("fechaSolicitud", sql.DateTime, new Date())
      .input("diagnostico", sql.NVarChar, diagnostico)
      .input("cantDias", sql.Int, parseInt(cantDias))
      .input("cantHorasDias", sql.Int, parseInt(horasDia))
      .query(queryCaso);

    res.status(201).json({ message: "Caso creado exitosamente" });
  } catch (error) {
    console.error("Error al crear caso:", error);
    res
      .status(500)
      .json({ error: "Error en la inserción", details: error.message });
  }
});

router.put("/solicitar/:id", async (req, res) => {
  const id = req.params.id;
  console.log(id);
  const pool = await getConnection();
  if (pool) {
    console.log("hola");
    const result = await pool
      .request()
      .input("IdCaso", sql.Int, id)
      .input("SolicitarCierre", sql.Int, 3)
      .query(
        `UPDATE Caso SET IdSituacion = @SolicitarCierre WHERE IdCaso = @IdCaso`
      );
    res.status(500).json({ message: "Caso solicitado correctamente" });
  }
});

//para marcar el caso como cerrado(lo hace el operador)
router.put("/confirmar/:id", async (req, res) => {
  const id = req.params.id;
  const pool = await getConnection();
  if (pool) {
    console.log("entro");
    const result = await pool
      .request()
      .input("IdCaso", sql.Int, id)
      .input("SolicitarCierre", sql.Int, 1)
      .query(
        `UPDATE Caso SET IdSituacion = @SolicitarCierre WHERE IdCaso = @IdCaso`
      );
    console.log(result.recordset);
  }
});

//en caso de que el operador no acepte cerrar el caso
router.put("/noaceptarcierre/:id", async (req, res) => {
  const id = req.params.id;
  const pool = await getConnection();
  if (pool) {
    console.log("hola");
    const result = await pool
      .request()
      .input("IdCaso", sql.Int, id)
      .input("SolicitarCierre", sql.Int, 2)
      .query(
        `UPDATE Caso SET IdSituacion = @SolicitarCierre WHERE IdCaso = @IdCaso`
      );
    console.log(result.recordset);
  }
});

export default router;
