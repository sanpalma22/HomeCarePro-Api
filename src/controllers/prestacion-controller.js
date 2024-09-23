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

router.get('', async(req,res)=>{
    try{
        const pool = await getConnection();
        if(pool){
            const result = await sql.query(`Select * from Prestacion`)
            res.json(result.recordset)
        }else{
            res.status(500).json({ message: "No se pudo establecer conexión con la base de datos" });
        }
    }catch{
        console.error("Error al obtener los casos activos:", error);
        res.status(500).json({ message: "Error interno del servidor" });
    }
})


export default router;