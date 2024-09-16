import express from "express";
import cors from "cors";
import CasoController from "./src/controllers/caso-controller.js";;
import MedicoController from "./src/controllers/medico-controller.js";
import PrestadorController from "./src/controllers/prestador-controller.js";
import Especialidadcontroller from "./src/controllers/especialidad-contrroller.js";;
import PrestacionController from "./src/controllers/prestacion-controller.js";
import config from "./src/config/dbConfig.js";
import { MailerSend } from 'mailersend';

import sql from "mssql";
const app = express();


app.use(cors());
app.use(express.json());


app.use("/casos", CasoController)

app.use("/medicos", MedicoController)

app.use("/prestadores", PrestadorController)

app.use("/prestadores", PrestadorController)

app.use("/especialidad", Especialidadcontroller)

app.use("/prestacion", PrestacionController)


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
  const id = parseInt(req.params.id, 10); 
  const { descripcion } = req.body; 
  
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

      res.status(201).json(result); 
  } catch (error) {
      console.error("Error en la inserción:", error);
      res.status(500).json({ error: "Error en la inserción" });
  }
});


app.get("/medicoo/login", async (req, res) => {
  try {
      console.log("entro");
      
      const { mail } = req.query;
      console.log("Mail:", mail);
      
      const pool = await getConnection();
      
      if (pool) {
          console.log("holaaaaaaaaaaa");
          
          const result = await pool.request()
              .input('mail', sql.VarChar, mail)
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
      
      const { email, contraseña } = req.body;

      console.log("Mail:", email);
      console.log("Contraseña:", contraseña);

      const pool = await getConnection();

      if (pool) {
          console.log("Conexión a la base de datos establecida");

          await pool.request()
              .input('email', sql.VarChar, email)
              .input('contraseña', sql.VarChar, contraseña)
              .query('UPDATE Prestador SET Contraseña = @contraseña WHERE Email = @email');

          console.log("Contraseña cambiada correctamente");

          const result1 = await pool.request()
              .input('email', sql.VarChar, email) 
              .query('SELECT IdPrestador FROM Prestador WHERE Email = @email');

          console.log(result1.recordset);

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





// Puerto en el que escucha el servidor
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Servidor backend iniciado en el puerto ${PORT}`);
});