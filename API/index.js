const express = require('express');
const app = express();
const mysql = require('mysql');

const conexion = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "",
    database: "systemhtours",
    multipleStatements: true,
})

// Para verificar si la conexión es exitosa para Falló mientras se ejecuta el proyecto en la consola.
conexion.connect((err) => {
    if (!err) {
      console.log("Conexión Exitosa A la base de datos");
    } else {
      console.log(
        "Conexión fallida en la base de datos twot \n Error :" + JSON.stringify(err, undefined, 2)
      );
    }
  });

app.set('port',process.env.PORT || 3000);

app.get('/',(req,res)=>{
    res.send('HOLA MUNDO')
})

// leer 
app.get(["/balance", "/Leer"],(req, res)=>{
    const sql = `call INS_BAL_GENERAL('', 1, '', 5)`
    conexion.query(sql,(error,results)=>{
        if(error) throw error;
        if(results.length>0){
            res.json(results[0]);
        }else{
            res.send('No se pudo obtener resultados')
        }
    });  
    console.log('Datos leidos correctamente');
});
// leer 
app.get(["/estado", "/Leer"],(req, res)=>{
  const sql = `CALL PRC_ESTADOS_RESULTADOS(1)`
  conexion.query(sql,(error,results)=>{
      if(error) throw error;
      if(results.length>0){
          res.json(results[0]);
      }else{
          res.send('No se pudo obtener resultados')
      }
  });  
  console.log('Datos leidos correctamente');
});


app.listen(app.set('port'),()=>{
    console.log('servidor encendido');
})