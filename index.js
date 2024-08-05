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
    const pool = await sql.connect(config);
    return pool;
  } catch (error) {
    console.error("Error al conectar con la base de datos:", error.message, error.code);
  }
}; 

// Ruta CASOS, para mover al controller
app.get("/casos", async (req, res) => {
  try {
    const pool = await getConnection();
    if (pool) {
      const request = pool.request();
      const result = await request.execute("getCasos")
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
        const request = pool.request();
        request.input("IdCaso",sql.Int,id)
        const result = await request.execute("getCasoById")
              
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
      const result = await sql.query(`SELECT * FROM InformeDia WHERE IdCaso = ${id}`);
    res.json(result.recordset);
    console.log(result)
  }
}
})

// Ruta PRESTADORES, para mover al controller

app.get("/prestadores", async (req, res) => {
  try {
    const pool = await getConnection();
    if (pool) {
      const request = pool.request();
      const result = await request.execute("getPrestadores")
      res.json(result.recordset);
    } else {
      res.status(500).json({ message: "No se pudo establecer conexión con la base de datos" });
    }
  } catch (error) {
    console.error("Error al obtener los casos activos:", error);
    res.status(500).json({ message: "Error interno del servidor" });
  }
});

app.get("/prestadores/:id", async (req,res)=>{
    const id = parseInt(req.params.id)
    const pool =await getConnection();
    if(pool){
      if (pool) {
        const request = pool.request();
        request.input("IdCaso",sql.Int,id)
        const result = await request.execute("getPrestadorById")
              
      res.json(result.recordset);
    }
  }
})

app.post("/casos", async (req,res)=>{
  const pool=await getConnection();
  if(pool){
    if (pool) {
      
    res.json(result.recordset);
    console.log(result)
  }
}
})

// Puerto en el que escucha el servidor
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Servidor backend iniciado en el puerto ${PORT}`);
});