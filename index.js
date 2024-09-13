import express from "express";
import cors from "cors";
import CasoController from "./src/controllers/caso-controller.js";;
import MedicoController from "./src/controllers/medico-controller.js";;

import config from "./src/config/dbConfig.js";
import { MailerSend } from 'mailersend';

import sql from "mssql";
const app = express();


app.use(cors());
app.use(express.json());

// Configuración de la conexión a la base de datos MSSQL
app.use("/casos", CasoController)
app.use("/medicos", MedicoController)



const getConnection = async () => {
  try {
    const pool = await sql.connect(config); //http://localhost:5000
    return pool;
  } catch (error) {
    console.error("Error al conectar con la base de datos:", error.message, error.code);

  }
}; 

// Ruta para obtener los casos activos desde la base de datos









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

const clave = "mlsn.8ccfddd6d0fd8ada85a73002ee2e0369120101e9eea389aee774d3b2f409a05a"
app.post('/medicoooo/codigo', async (req, res) => {
  process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';

  try {
    console.log("Hola");

    // Crear instancia de MailerSend
    const mailersend = new MailerSend({
      apiKey: clave,
    });

    // Definir parámetros del email
    const response = await mailersend.email.send({
      from: 'info@domain.com',
      fromName: 'Your Name',
      to: [
        {
          email: 'ramirosued07@gmail.com',
          name: 'Recipient',
        },
      ],
      subject: 'Subject',
      html: 'Greetings from the team, you got this message through MailerSend.',
      text: 'Greetings from the team, you got this message through MailerSend.',
    });

    console.log('Correo enviado exitosamente:', response);
    res.send('Correo enviado exitosamente');
  } catch (error) {
    console.error('Error al enviar el correo:', error.response ? error.response.data : error.message);
    res.status(500).send('Error al enviar el correo');
  }
});

//  let RESEND_API_KEY = 're_fctcZJ9e_61GYrPJuR2MVGkNHBdESaZS9'



app.post("/prestadores", async (req, res) => {
  const { dni, nombre, apellido, direccion, localidad, telefono, email, genero, contraseña } = req.body;

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
      .input('idEspecialidad', sql.Int, 1) // Cambiado a dni
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


// Puerto en el que escucha el servidor
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Servidor backend iniciado en el puerto ${PORT}`);
});