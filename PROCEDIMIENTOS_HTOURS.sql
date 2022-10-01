/*----------------------------------------------------------------------------------------------------------------------------------------
--                            PROCEDIMIENTOS ALMACENADOS PARA SYSTEM HTOURS                                                             --
--                                        TECNOBOT
-----------------------------------------------------------------------------------------------------------------------------------------
*/


/*-----------------------------------------------------------MODULO DE CUENTAS-------------------------------------------------*/
/*
NOMBRE: INS_CUENTAS
DESCRIPCION: PROCEDIMIENTO PARA INSERTAR LOS DATOS DE LA CUENTA
AUTOR: ALEXANDRA MOYA
VERSION: 1.0


  -- PB  = PARAMETRO BIGINT
 -- PV  = PARAMETRO VARCHAR
 -- PC  = PARAMETRO CHAR
 -- PEM = PARAMETRO ENUM
 -- PF  = PARAMETRO FECHA
 -- PMI = PARAMETRO MEDIUMINT 
 -- PMT = PARAMETRO MEDIUMTEXT
 -- PI  = PARAMETRO INT
 -- PD  = PARAMETRO DECIMAL
 -- PDB = PARAMETRO DOUBLE
 -- PMB = PARAMETRO MEDIUMBLOB
*/
CREATE PROCEDURE INS_CUENTAS(
   IN PV_NATURALEZA Varchar(255)
  ,IN PV_NOMBRE_CUENTA VARCHAR(255)
  ,IN PV_NUM_CUENTA VARCHAR(255)
  /* ,IN PV_OPERACION VARCHAR(1)
  ,IN PB_FILA BIGINT  */
)
BEGIN
DECLARE V_CODIGO VARCHAR(255);
DECLARE V_VALIDADORDEEXISTENCIA INT;
/*LLEVA FORANEA CON LA CLASIFICACION*/
/*Valida naturaleza*/
SELECT COD_CLASIFICACION FROM TBL_CLASIFICACIONES WHERE NATURALEZA = PV_NATURALEZA INTO V_CODIGO;
/*Valida existencia*/
select count(*) from tbl_cuentas where NUM_CUENTA = CONCAT(V_CODIGO,'.',PV_NUM_CUENTA) INTO V_VALIDADORDEEXISTENCIA;
/*
si NO existe*/
IF V_VALIDADORDEEXISTENCIA = 0 THEN

INSERT INTO tbl_cuentas
(COD_CLASIFICACION, NUM_CUENTA, NOM_CUENTA) 
VALUES (V_CODIGO, CONCAT(V_CODIGO,'.',PV_NUM_CUENTA), PV_NOMBRE_CUENTA);
/* Si existe despliega mensaje que esta duplicado */
ELSE
SELECT 'NUMERO DE CUENTA DUPLICADA';
END IF;
COMMIT;
END;

/*
NOMBRE: PRC_CUENTAS
DESCRIPCION: PROCEDIMIENTO PARA ACTUALIZAR Y ELIMINAR LOS DATOS DE LAS CUENTAS
AUTOR: ALEXANDRA MOYA
VERSION: 1.0


  -- PB  = PARAMETRO BIGINT
 -- PV  = PARAMETRO VARCHAR
 -- PC  = PARAMETRO CHAR
 -- PEM = PARAMETRO ENUM
 -- PF  = PARAMETRO FECHA
 -- PMI = PARAMETRO MEDIUMINT 
 -- PMT = PARAMETRO MEDIUMTEXT
 -- PI  = PARAMETRO INT
 -- PD  = PARAMETRO DECIMAL
 -- PDB = PARAMETRO DOUBLE
 -- PMB = PARAMETRO MEDIUMBLOB
*/

CREATE PROCEDURE PRC_CUENTAS(
   IN PV_NATURALEZA BIGINT
  ,IN PV_NOMBRE_CUENTA VARCHAR(255)
  ,IN PV_NUM_CUENTA VARCHAR(255)
  ,IN PV_OPERACION VARCHAR(1)
  ,IN PB_FILA BIGINT 
)
BEGIN 
START TRANSACTION;
IF PV_OPERACION = 1 THEN

UPDATE tbl_cuentas 
SET COD_CLASIFICACION = PV_NATURALEZA , NUM_CUENTA = PV_NUM_CUENTA, NOM_CUENTA = PV_NOMBRE_CUENTA 
WHERE COD_CUENTA = PB_FILA;
ELSEIF PV_OPERACION = 2 THEN
DELETE FROM TBL_CUENTAS WHERE COD_CUENTA = PB_FILA;
ELSEIF PV_OPERACION = 3 THEN
SELECT * FROM TBL_CUENTAS;
ELSEIF PV_OPERACION = 4 THEN
SELECT * FROM TBL_CUENTAS WHERE COD_CUENTA = PB_FILA;
ELSEIF PV_OPERACION = 5 THEN
SELECT NUM_CUENTA FROM TBL_CUENTAS WHERE  COD_CUENTA =  PB_FILA;
END IF;
COMMIT;
END;

/*
NOMBRE: PRC_SUBCUENTAS
DESCRIPCION: PROCEDIMIENTO PARA ACTUALIZAR Y ELIMINAR LOS DATOS DE LAS CUENTAS
AUTOR: ALEXANDRA MOYA
VERSION: 1.0


  -- PB  = PARAMETRO BIGINT
 -- PV  = PARAMETRO VARCHAR
 -- PC  = PARAMETRO CHAR
 -- PEM = PARAMETRO ENUM
 -- PF  = PARAMETRO FECHA
 -- PMI = PARAMETRO MEDIUMINT 
 -- PMT = PARAMETRO MEDIUMTEXT
 -- PI  = PARAMETRO INT
 -- PD  = PARAMETRO DECIMAL
 -- PDB = PARAMETRO DOUBLE
 -- PMB = PARAMETRO MEDIUMBLOB
*/
DROP PROCEDURE IF EXISTS PRC_SUBCUENTAS;
CREATE PROCEDURE PRC_SUBCUENTAS(
  PB_COD_CLASIFICACION BIGINT                             
, PV_NUM_SUBCUENTA VARCHAR(255)                   
, PV_NOM_SUBCUENTA VARCHAR(255)                  
, PB_COD_CUENTA    BIGINT  
, PV_OPERACION  VARCHAR(1)
, PB_FILA       BIGINT
)
BEGIN
DECLARE V_NUM VARCHAR(255);
DECLARE V_VALIDADORDEEXISTENCIA BIGINT;
START TRANSACTION;
SELECT NUM_CUENTA FROM TBL_CUENTAS WHERE COD_CUENTA = PB_COD_CUENTA INTO V_NUM;
IF PV_OPERACION = 1 THEN

/*Valida existencia*/
select count(*) from tbl_subcuentas where NUM_SUBCUENTA = CONCAT(V_NUM,'.',PV_NUM_SUBCUENTA) INTO V_VALIDADORDEEXISTENCIA;
/*
si NO existe*/
IF V_VALIDADORDEEXISTENCIA = 0 THEN
INSERT INTO tbl_subcuentas
(COD_CLASIFICACION, NUM_SUBCUENTA, NOM_SUBCUENTA, COD_CUENTA) 
VALUES (PB_COD_CLASIFICACION,  CONCAT(V_NUM,'.',PV_NUM_SUBCUENTA), PV_NOM_SUBCUENTA, PB_COD_CUENTA);
ELSE 
SELECT 'NUMERO DE SUBCUENTA DUPLICADA';
END IF;
ELSEIF  PV_OPERACION = 2 THEN
UPDATE tbl_subcuentas 
SET COD_CLASIFICACION = PB_COD_CLASIFICACION , NUM_SUBCUENTA = PV_NUM_SUBCUENTA, NOM_SUBCUENTA = PV_NOM_SUBCUENTA, COD_CUENTA = PB_COD_CUENTA 
WHERE COD_SUBCUENTA = PB_FILA
;
ELSEIF  PV_OPERACION = 3 THEN
DELETE FROM TBL_SUBCUENTAS WHERE  COD_SUBCUENTA = PB_FILA;
ELSEIF  PV_OPERACION = 4 THEN
SELECT * FROM TBL_SUBCUENTAS;
ELSEIF  PV_OPERACION = 5 THEN
SELECT * FROM TBL_SUBCUENTAS WHERE  COD_SUBCUENTA = PB_FILA;
ELSEIF PV_OPERACION = 6 THEN
SELECT NUM_SUBCUENTA FROM TBL_SUBCUENTAS WHERE  COD_SUBCUENTA = PB_FILA;
END IF;
COMMIT;
END;



/*------------------------------------------------------MODULO CONTABLE---------------------------------------*/
/*
NOMBRE: PRC_LIBDIARIO
DESCRIPCION: PROCEDIMIENTO PARA ACTUALIZAR Y ELIMINAR LOS DATOS DE LIBRO DIARIO
AUTOR: ZOILA MARGARITA LICONA 
VERSION: 1.0


 -- PB  = PARAMETRO BIGINT
 -- PV  = PARAMETRO VARCHAR
 -- PC  = PARAMETRO CHAR
 -- PEM = PARAMETRO ENUM
 -- PF  = PARAMETRO FECHA
 -- PMI = PARAMETRO MEDIUMINT 
 -- PMT = PARAMETRO MEDIUMTEXT
 -- PI  = PARAMETRO INT
 -- PD  = PARAMETRO DECIMAL
 -- PDB = PARAMETRO DOUBLE
 -- PMB = PARAMETRO MEDIUMBLOB
*/
CREATE PROCEDURE PRC_LIBDIARIO(

   IN PV_NOM_CUENTA VARCHAR(255)
  ,IN PV_NOM_SUBCUENTA VARCHAR(255)
  ,IN PV_SALDO_DEBE INT
  ,IN PV_SALDO_HABER INT
  ,IN PV_OPERACION VARCHAR(1)
  ,IN PB_FILA BIGINT 
)
BEGIN
DECLARE V_CODCUENTA,V_CODSUBCUENTA,V_CODESTCUENTA BIGINT;
DECLARE V_SUBCUENTA VARCHAR(255);
START TRANSACTION;

/* Trae los datos de las cuentas disponibles */
IF PV_OPERACION = 1 THEN
SELECT NUM_CUENTA,NOM_CUENTA FROM TBL_CUENTAS ORDER BY NUM_CUENTA Asc;


/*Trae los datos de las subcuentas disponibles*/
ELSEIF PV_OPERACION = 2 THEN
SELECT NUM_SUBCUENTA, NOM_SUBCUENTA FROM TBL_SUBCUENTAS WHERE COD_CUENTA =  PB_FILA ;

/*Insertar Libro Diario CUENTA Y SUBCUENTA  */
ELSEIF PV_OPERACION = 3 THEN

/*---------------------------------------------------------------------------------------------------------*/
SELECT COD_CUENTA FROM TBL_CUENTAS WHERE NOM_CUENTA =  PV_NOM_CUENTA INTO V_CODCUENTA; 
SELECT COD_SUBCUENTA, NUM_SUBCUENTA  FROM TBL_SUBCUENTAS WHERE NOM_SUBCUENTA = PV_NOM_SUBCUENTA INTO V_CODSUBCUENTA,V_SUBCUENTA; 
SELECT COD_ESTADO from tbl_estados_subcuentas where cod_subcuenta = V_CODSUBCUENTA INTO V_CODESTCUENTA;

INSERT INTO tbl_libros_diarios
(COD_CUENTA, COD_SUBCUENTA, COD_ESTADO, NUM_SUBCUENTA, NOM_SUBCUENTA, SAL_DEBE, SAL_HABER, FEC_LIBDIARIO) 
VALUES (V_CODCUENTA, V_CODSUBCUENTA, V_CODESTCUENTA, V_SUBCUENTA, PV_NOM_SUBCUENTA, PV_SALDO_DEBE, PV_SALDO_HABER, now());
ELSEIF PV_OPERACION = 4 THEN
/* INSERT SOLO PARA CUENTAS */
SELECT COD_CUENTA,NUM_CUENTA FROM TBL_CUENTAS WHERE NOM_CUENTA =  PV_NOM_CUENTA INTO V_CODCUENTA,V_SUBCUENTA;  -- v_SUBCUENTA = GUARDA EL NOMBRE DE LA CUENTA


SELECT COD_ESTADO from tbl_estados_cuentas where cod_cuenta = V_CODCUENTA INTO V_CODESTCUENTA;

INSERT INTO tbl_libros_diarios
(COD_CUENTA, COD_SUBCUENTA, COD_ESTADO, NUM_SUBCUENTA, NOM_SUBCUENTA, SAL_DEBE, SAL_HABER, FEC_LIBDIARIO) 
VALUES (V_CODCUENTA, 1, V_CODESTCUENTA, V_SUBCUENTA, PV_NOM_SUBCUENTA, PV_SALDO_DEBE, PV_SALDO_HABER, now());

ELSEIF PV_OPERACION = 5 THEN
SELECT * FROM TBL_LIBROS_DIARIOS;

ELSEIF PV_OPERACION = 6 THEN
SELECT * FROM TBL_LIBROS_DIARIOS WHERE COD_LIBDIARIO = PB_FILA;
END IF;
COMMIT;
END;

/*
NOMBRE: SEL_CATALAGO_CUENTAS
DESCRIPCION: PROCEDIMIENTO PARA SELECCIONAR LAS CUENTAS DE LIBRO DIARIO
AUTOR: EMERSON EXEQUIEL RAMOS VELASQUEZ
VERSION: 1.0


 -- PB  = PARAMETRO BIGINT
 -- PV  = PARAMETRO VARCHAR
 -- PC  = PARAMETRO CHAR
 -- PEM = PARAMETRO ENUM
 -- PF  = PARAMETRO FECHA
 -- PMI = PARAMETRO MEDIUMINT 
 -- PMT = PARAMETRO MEDIUMTEXT
 -- PI  = PARAMETRO INT
 -- PD  = PARAMETRO DECIMAL
 -- PDB = PARAMETRO DOUBLE
 -- PMB = PARAMETRO MEDIUMBLOB
*/

CREATE PROCEDURE SEL_CATALAGO_CUENTAS(
   IN PV_NATURALEZA VARCHAR(255)
)
BEGIN
DECLARE V_CODCUENTA BIGINT;
SELECT COD_CLASIFICACION FROM TBL_CLASIFICACIONES WHERE NATURALEZA = PV_NATURALEZA INTO V_CODCUENTA;
START TRANSACTION;
SELECT NUM_CUENTA,NOM_CUENTA FROM tbl_cuentas WHERE COD_CLASIFICACION =  V_CODCUENTA order by NUM_CUENTA Asc;
COMMIT;
END;


/*
NOMBRE: UPD_LIBDIARIO
DESCRIPCION: PROCEDIMIENTO PARA ACTUALIZAR Y ELIMINAR LOS DATOS DE LIBRO DIARIO
AUTOR: ZOILA MARGARITA LICONA 
VERSION: 1.0


 -- PB  = PARAMETRO BIGINT
 -- PV  = PARAMETRO VARCHAR
 -- PC  = PARAMETRO CHAR
 -- PEM = PARAMETRO ENUM
 -- PF  = PARAMETRO FECHA
 -- PMI = PARAMETRO MEDIUMINT 
 -- PMT = PARAMETRO MEDIUMTEXT
 -- PI  = PARAMETRO INT
 -- PD  = PARAMETRO DECIMAL
 -- PDB = PARAMETRO DOUBLE
 -- PMB = PARAMETRO MEDIUMBLOB
*/

CREATE PROCEDURE UPD_LIBDIARIO(
 IN PB_COD_CUENTA    BIGINT                               
,IN PB_COD_SUBCUENTA BIGINT                                                        
,IN PB_COD_ESTADO    BIGINT                                  
,IN PB_NUM_SUBCUENTA VARCHAR(255)                    
,IN PB_NOM_SUBCUENTA VARCHAR(255)                    
,IN PB_SAL_DEBE    DECIMAL (8,2)                    
,IN PB_SAL_HABER   DECIMAL (8,2)                     
,IN PB_FEC_LIBDIARIO DATETIME    
,IN PB_FILA BIGINT
)
BEGIN
START TRANSACTION;
UPDATE tbl_libros_diarios 
SET COD_CUENTA = PB_COD_CUENTA , COD_SUBCUENTA = PB_COD_SUBCUENTA, COD_ESTADO = PB_COD_ESTADO, NUM_SUBCUENTA = PB_NUM_SUBCUENTA, NOM_SUBCUENTA = PB_NOM_SUBCUENTA, SAL_DEBE = PB_SAL_DEBE, SAL_HABER = PB_SAL_HABER, FEC_LIBDIARIO = NOW() 
WHERE COD_LIBDIARIO = PB_FILA;
COMMIT;
END;

CREATE PROCEDURE DEL_LIBDIARIO(
PB_CODLIBDIARIO BIGINT
)
BEGIN
START TRANSACTION;
DELETE FROM tbl_libros_diarios 
WHERE COD_LIBDIARIO = PB_CODLIBDIARIO;
COMMIT;
END;








/* BALANCE GENERAL */

/*
NOMBRE: INS_BAL_GENERAL
DESCRIPCION: PROCEDIMIENTO PARA ACTUALIZAR Y ELIMINAR LOS DATOS
AUTOR: ZOILA MARGARITA LICONA 
VERSION: 1.0


 -- PB  = PARAMETRO BIGINT
 -- PV  = PARAMETRO VARCHAR
 -- PC  = PARAMETRO CHAR
 -- PEM = PARAMETRO ENUM
 -- PF  = PARAMETRO FECHA
 -- PMI = PARAMETRO MEDIUMINT 
 -- PMT = PARAMETRO MEDIUMTEXT
 -- PI  = PARAMETRO INT
 -- PD  = PARAMETRO DECIMAL
 -- PDB = PARAMETRO DOUBLE
 -- PMB = PARAMETRO MEDIUMBLOB
*/
CREATE PROCEDURE `INS_BAL_GENERAL`(
 IN PV_NOMBRE_EMPRESA VARCHAR(255)
,IN PV_NATURALEZA VARCHAR(255)
,IN PV_OPCION VARCHAR(1)
)
BEGIN
DECLARE DEBE,HABER INT;
DECLARE V_NUMCUENTA VARCHAR(255);
DECLARE V_NOMCUENTA VARCHAR(255);
DECLARE CODIGO BIGINT;
DECLARE TOTAL BIGINT;
DECLARE V_NUM,V_CLASIFICACION,I BIGINT;

IF PV_OPCION = 1 THEN

/*Trea saldo debe y haber de activo*/
SELECT COD_CLASIFICACION FROM TBL_CLASIFICACIONES  WHERE NATURALEZA =  PV_NATURALEZA INTO V_CLASIFICACION;
SELECT COUNT(*) FROM  TBL_LIBROS_MAYORES WHERE COD_CLASIFICACION = V_CLASIFICACION INTO V_NUM;
SET I=0;

WHILE I<V_NUM do 

  SELECT COD_LIBMAYOR,NUM_CUENTA,NOM_CUENTA,SAL_DEBE,SAL_HABER FROM TBL_LIBROS_MAYORES WHERE COD_CLASIFICACION = V_CLASIFICACION LIMIT I,1 INTO CODIGO,V_NUMCUENTA,V_NOMCUENTA,DEBE,HABER;

    IF DEBE > HABER THEN
      SET TOTAL:=DEBE-HABER;
      SELECT "SALDO DEUDOR";
     ELSE  
      SET TOTAL:= DEBE - HABER;   
      SET TOTAL:= TOTAL * -1;
      SELECT "SALDO ACREEDOR";
    END IF;
 SET I = I + 1;
 

SELECT CODIGO,V_NUMCUENTA,V_NOMCUENTA,DEBE,HABER;

 INSERT INTO tbl_balances_generales
(COD_LIBMAYOR, EMPRESA, FEC_BALANCE, TOT_ACTIVO, TOT_PASIVO, TOT_PATRIMONIO) 
VALUES (CODIGO, PV_NOMBRE_EMPRESA, NOW(), TOTAL,  0, 0);


END WHILE;

ELSEIF PV_OPCION = 2 THEN
/*Trea saldo debe y haber de PasIvo*/
SELECT COD_CLASIFICACION FROM TBL_CLASIFICACIONES  WHERE NATURALEZA = PV_NATURALEZA INTO V_CLASIFICACION;
SELECT COUNT(*) FROM  TBL_LIBROS_MAYORES WHERE COD_CLASIFICACION = V_CLASIFICACION INTO V_NUM;
SET I=0;

WHILE I<V_NUM do 
  SELECT COD_LIBMAYOR,NUM_CUENTA,NOM_CUENTA,SAL_DEBE,SAL_HABER FROM TBL_LIBROS_MAYORES WHERE COD_CLASIFICACION = V_CLASIFICACION LIMIT I,1 INTO CODIGO,V_NUMCUENTA,V_NOMCUENTA,DEBE,HABER;
    IF DEBE > HABER THEN
      SET TOTAL:=DEBE-HABER;
      SELECT "SALDO DEUDOR";
     ELSE  
      SET TOTAL:= DEBE - HABER;   
      SET TOTAL:= TOTAL * -1;
      SELECT "SALDO ACREEDOR";
    END IF;
 SET I = I + 1;
 INSERT INTO tbl_balances_generales
(COD_LIBMAYOR, EMPRESA, FEC_BALANCE, TOT_ACTIVO, TOT_PASIVO, TOT_PATRIMONIO) 
VALUES (CODIGO, PV_NOMBRE_EMPRESA, NOW(), 0,  TOTAL, 0);
END WHILE;
ELSEIF PV_OPCION = 3 THEN
/*Trea saldo debe y haber de Pasovo*/
SELECT COD_CLASIFICACION FROM TBL_CLASIFICACIONES  WHERE NATURALEZA = PV_NATURALEZA INTO V_CLASIFICACION;
SELECT COUNT(*) FROM  TBL_LIBROS_MAYORES WHERE COD_CLASIFICACION = V_CLASIFICACION INTO V_NUM;
SET I=0;

WHILE I<V_NUM do 
  SELECT COD_LIBMAYOR,NUM_CUENTA,NOM_CUENTA,SAL_DEBE,SAL_HABER FROM TBL_LIBROS_MAYORES WHERE COD_CLASIFICACION = V_CLASIFICACION LIMIT I,1 INTO CODIGO,V_NUMCUENTA,V_NOMCUENTA,DEBE,HABER;
    IF DEBE > HABER THEN
      SET TOTAL:=DEBE-HABER;
      SELECT "SALDO DEUDOR";
     ELSE  
      SET TOTAL:= DEBE - HABER;   
      SET TOTAL:= TOTAL * -1;
      SELECT "SALDO ACREEDOR";
    END IF;
 SET I = I + 1;
 INSERT INTO tbl_balances_generales
(COD_LIBMAYOR, EMPRESA, FEC_BALANCE, TOT_ACTIVO, TOT_PASIVO, TOT_PATRIMONIO) 
VALUES (CODIGO, PV_NOMBRE_EMPRESA, NOW(), 0,  0, TOTAL);
END WHILE;
END IF;
COMMIT;
END;

/*
NOMBRE: PRC_CONTROL
DESCRIPCION: PROCEDIMIENTO PARA ACTUALIZAR SELECCIONAR Y ELIMINAR LOS DATOS
AUTOR: EMERSON EXEQUIEL RAMOS VELASQUEZ
VERSION: 1.0


 -- PB  = PARAMETRO BIGINT
 -- PV  = PARAMETRO VARCHAR
 -- PC  = PARAMETRO CHAR
 -- PEM = PARAMETRO ENUM
 -- PF  = PARAMETRO FECHA
 -- PMI = PARAMETRO MEDIUMINT 
 -- PMT = PARAMETRO MEDIUMTEXT
 -- PI  = PARAMETRO INT
 -- PD  = PARAMETRO DECIMAL
 -- PDB = PARAMETRO DOUBLE
 -- PMB = PARAMETRO MEDIUMBLOB
*/

DROP PROCEDURE IF EXISTS PRC_CONTROL;
CREATE PROCEDURE PRC_CONTROL(
   OUT USUARIO BIGINT
  ,OUT CUENTAS BIGINT
  ,OUT SUBCUENT BIGINT
  ,OUT PERIODO BIGINT
)
BEGIN

START TRANSACTION;
SELECT COUNT(COD_USR) FROM tbl_ms_usr INTO USUARIO;
SELECT COUNT(COD_CUENTA) FROM TBL_CUENTAS INTO CUENTAS;
SELECT COUNT(COD_SUBCUENTA) FROM TBL_SUBCUENTAS INTO SUBCUENT;
SELECT COUNT(COD_PERIODO) FROM TBL_PERIODOS INTO PERIODO;
COMMIT;
END;




/*
NOMBRE: PRC_BLG
DESCRIPCION: PROCEDIMIENTO PARA ACTUALIZAR SELECCIONAR Y ELIMINAR LOS DATOS
AUTOR: EMERSON EXEQUIEL RAMOS VELASQUEZ
VERSION: 1.0


 -- PB  = PARAMETRO BIGINT
 -- PV  = PARAMETRO VARCHAR
 -- PC  = PARAMETRO CHAR
 -- PEM = PARAMETRO ENUM
 -- PF  = PARAMETRO FECHA
 -- PMI = PARAMETRO MEDIUMINT 
 -- PMT = PARAMETRO MEDIUMTEXT
 -- PI  = PARAMETRO INT
 -- PD  = PARAMETRO DECIMAL
 -- PDB = PARAMETRO DOUBLE
 -- PMB = PARAMETRO MEDIUMBLOB
*/
CREATE PROCEDURE PRC_BLG(
     IN PB_COD_LIBMAYOR bigint 
    ,IN PV_EMPRESA varchar(50)
    ,IN PB_TOT_ACTIVO BIGINT 
    ,IN PB_TOT_PASIVO BIGINT 
    ,IN PB_TOT_PATRIMONIO BIGINT   
    ,IN PV_OPERACION VARCHAR(1)
    , IN PB_FILA BIGINT
)

BEGIN

START TRANSACTION;
IF PV_OPERACION = 1 THEN
UPDATE tbl_balances_generales 
SET COD_LIBMAYOR = PB_COD_LIBMAYOR , EMPRESA = PV_EMPRESA, FEC_BALANCE = NOW(), TOT_ACTIVO = PB_TOT_ACTIVO, TOT_PASIVO = PB_TOT_PASIVO, TOT_PATRIMONIO = PB_TOT_PATRIMONIO 
WHERE COD_BALANCE = PB_FILA;

ELSEIF  PV_OPERACION = 2 THEN 
DELETE FROM TBL_BALANCES_GENERALES WHERE COD_BALANCE = PB_FILA;
ELSEIF  PV_OPERACION = 3 THEN
SELECT * FROM TBL_BALACNES_GENERALES;
ELSEIF  PV_OPERACION = 4 THEN
SELECT * FROM TBL_BALACNES_GENERALES WHERE COD_BALANCE = PB_FILA;
END IF;
COMMIT;
END;


CREATE PROCEDURE PRC_SALDOS_BALANCES(
        IN PB_COD_BALANCE  BIGINT 
      , IN PI_TOT_ACTIVO   INT 
      , IN PI_TOT_PASPAT   INT 
      , IN PV_OPERACION VARCHAR(1)
      , IN PB_FILA   BIGINT 
)
BEGIN
START TRANSACTION;
IF PV_OPERACION = 1 THEN

INSERT INTO tbl_saldos_balances
(COD_BALANCE, FEC_SALDOS, TOT_ACTIVO, TOT_PASPAT) 
VALUES (PB_COD_BALANCE, NOW(), PI_TOT_ACTIVO, PI_TOT_PASPAT);


ELSEIF PV_OPERACION = 2 THEN

UPDATE tbl_saldos_balances 
SET COD_BALANCE = PB_COD_BALANCE , FEC_SALDOS = NOW(), TOT_ACTIVO = PI_TOT_ACTIVO, TOT_PASPAT = PI_TOT_PASPAT 
WHERE COD_SALDO = PB_FILA;

ELSEIF PV_OPERACION = 3 THEN

DELETE FROM tbl_saldos_balances 
WHERE COD_SALDO = PB_FILA; 

ELSEIF PV_OPERACION = 4 THEN

SELECT * FROM TBL_SALDOS_BALANCES;

ELSEIF PV_OPERACION = 5 THEN
SELECT * FROM TBL_SALDOS_BALANCES WHERE COD_SALDO = PB_FILA;

END IF;
COMMIT;
END;


/*
NOMBRE: PROC_ESTADOS_RESULTADOS
DESCRIPCION: PROCEDIMIENTO PARA INSERTAR ELIMINAR ACTUALIZAR Y SELECIONAR LOS DATOS 
AUTOR: ZOILA MARGARITA LICONA
VERSION: 1.0


  -- PB  = PARAMETRO BIGINT
 -- PV  = PARAMETRO VARCHAR
 -- PC  = PARAMETRO CHAR
 -- PEM = PARAMETRO ENUM
 -- PF  = PARAMETRO FECHA
 -- PMI = PARAMETRO MEDIUMINT 
 -- PMT = PARAMETRO MEDIUMTEXT
 -- PI  = PARAMETRO INT
 -- PD  = PARAMETRO DECIMAL
 -- PDB = PARAMETRO DOUBLE
 -- PMB = PARAMETRO MEDIUMBLOB
*/

CREATE PROCEDURE PROC_ESTADOS_RESULTADOS(
     IN PV_NATURALEZA VARCHAR(255)
    ,IN PB_PERIODO BIGINT
    ,IN PB_PARAMETRO BIGINT
    ,IN PB_COD_LIBMAYOR BIGINT
    ,IN PV_NOMBRE_EMPRESA VARCHAR(255)
    ,IN PV_VEN_NETAS VARCHAR(255)
    ,IN PV_COS_VENTAS VARCHAR(255)
    ,IN PV_UTI_BRUTA VARCHAR(255)
    ,IN PV_TOT_GASTOS VARCHAR(255)
    ,IN PV_UTI_ANTIMP VARCHAR(255)
    ,IN PV_IMP_UTILIDAD VARCHAR(255)
    ,IN PV_UTI_NETA VARCHAR(255)
    ,IN PV_OPCION VARCHAR(1)
    ,IN PB_FILA BIGINT
)BEGIN
 START TRANSACTION;
  
  IF PV_OPCION = 1 THEN

  INSERT INTO tbl_estados_resultados
  (COD_LIBMAYOR, COD_PERIODO, COD_PARAMETRO, EMPRESA, FEC_ESTADO, VEN_NETAS, COS_VENTAS, UTI_BRUTA, TOT_GASTOS, UTI_ANTIMP, IMP_UTILIDAD, UTI_NETA) 
  VALUES (PB_COD_LIBMAYOR, PB_PERIODO, PB_PARAMETRO, PV_NOMBRE_EMPRESA, NOW(), PV_VEN_NETAS, PV_COS_VENTAS, PV_UTI_BRUTA, PV_TOT_GASTOS, PV_UTI_ANTIMP, PV_IMP_UTILIDAD,PV_UTI_NETA );
  ELSEIF PV_OPCION = 2 THEN
  UPDATE tbl_estados_resultados 
SET COD_LIBMAYOR = PB_COD_LIBMAYOR , COD_PERIODO = PB_PERIODO, COD_PARAMETRO = PB_PARAMETRO, EMPRESA = PV_NOMBRE_EMPRESA, FEC_ESTADO = NOW(), VEN_NETAS = PV_VEN_NETAS, COS_VENTAS = PV_COS_VENTAS, UTI_BRUTA = PV_UTI_BRUTA, TOT_GASTOS = PV_TOT_GASTOS, UTI_ANTIMP = PV_UTI_ANTIMP, IMP_UTILIDAD = PV_IMP_UTILIDAD, UTI_NETA = PV_UTI_NETA 
WHERE COD_ESTRESULTADO = PB_FILA;

  ELSEIF PV_OPCION = 3 THEN
  DELETE FROM stbl_estados_resultados 
WHERE COD_ESTRESULTADO  = PB_FILA;
  ELSEIF PV_OPCION = 4 THEN
  SELECT * FROM TBL_ESTADOS_RESULTADOS ;  
    ELSEIF PV_OPCION = 5 THEN
     SELECT * FROM TBL_ESTADOS_RESULTADOS WHERE COD_ESTRESULTADO  = PB_FILA; 
  END IF;
COMMIT;
END;




/*
NOMBRE: PRC_COMPROBANTES
DESCRIPCION: PROCEDIMIENTO PARA INSERTAR ELIMINAR ACTUALIZAR Y SELECIONAR LOS DATOS 
AUTOR: EMERSON EXEQUIEL RAMOS VELASQUEZ
VERSION: 1.0


  -- PB  = PARAMETRO BIGINT
 -- PV  = PARAMETRO VARCHAR
 -- PC  = PARAMETRO CHAR
 -- PEM = PARAMETRO ENUM
 -- PF  = PARAMETRO FECHA
 -- PMI = PARAMETRO MEDIUMINT 
 -- PMT = PARAMETRO MEDIUMTEXT
 -- PI  = PARAMETRO INT
 -- PD  = PARAMETRO DECIMAL
 -- PDB = PARAMETRO DOUBLE
 -- PMB = PARAMETRO MEDIUMBLOB
*/


/*COMPROBANTES*/

CREATE PROCEDURE PRC_COMPROBANTES(
   IN PB_COD_LIBDIARIO   BIGINT 
  ,IN PV_COMPROBANTE     VARCHAR(255)  
  ,IN PV_DES_COMPROBANTE VARCHAR(100) 
  ,IN PV_OPCION          VARCHAR(255)
  ,IN PB_FILA            BIGINT
)
BEGIN
START TRANSACTION;
IF PV_OPCION = 1 THEN
INSERT INTO tbl_comprobantes
(COD_LIBDIARIO, FEC_COMPROBANTE, COMPROBANTE, DES_COMPROBANTE) 
VALUES (PB_COD_LIBDIARIO, NOW(), PV_COMPROBANTE, PV_DES_COMPROBANTE);
ELSEIF PV_OPCION = 2 THEN 
UPDATE tbl_comprobantes 
SET COD_LIBDIARIO = PB_COD_LIBDIARIO , FEC_COMPROBANTE = NOW(), COMPROBANTE = PV_COMPROBANTE, DES_COMPROBANTE = PV_DES_COMPROBANTE
WHERE COD_COMPROBANTE = PB_FILA;
ELSEIF PV_OPCION = 3 THEN 
DELETE FROM TBL_COMPROBANTES WHERE COD_COMPROBANTE = PB_FILA;
ELSEIF PV_OPCION = 4 THEN 
SELECT * FROM TBL_COMPROBANTES;
ELSEIF PV_OPCION = 5 THEN 
SELECT * FROM TBL_COMPROBANTES WHERE COD_COMPROBANTE = PB_FILA;
END IF ;
COMMIT;
END;




/*
NOMBRE: PRC_LIBROS_MAYORES
DESCRIPCION: PROCEDIMIENTO PARA INSERTAR ELIMINAR ACTUALIZAR Y SELECIONAR LOS DATOS 
AUTOR: KEVIN ALVARADO BUEZO
VERSION: 1.0


  -- PB  = PARAMETRO BIGINT
 -- PV  = PARAMETRO VARCHAR
 -- PC  = PARAMETRO CHAR
 -- PEM = PARAMETRO ENUM
 -- PF  = PARAMETRO FECHA
 -- PMI = PARAMETRO MEDIUMINT 
 -- PMT = PARAMETRO MEDIUMTEXT
 -- PI  = PARAMETRO INT
 -- PD  = PARAMETRO DECIMAL
 -- PDB = PARAMETRO DOUBLE
 -- PMB = PARAMETRO MEDIUMBLOB
*/



CREATE PROCEDURE PRC_LIBROS_MAYORES(
  
  IN PB_COD_CLASIFICACION BIGINT                         
, IN PB_COD_PERIODO BIGINT                               
, IN PB_COD_ESTCUENTA BIGINT                             
, IN PV_NUM_CUENTA   VARCHAR(255)               
, IN PV_NOM_CUENTA   VARCHAR(255) 
, IN PD_SAL_DEBE   DECIMAL (8,2) 
, IN PD_SAL_HABER  DECIMAL (8,2)
, IN PF_FEC        DATE
  ,IN PV_OPERACION VARCHAR (1)
  ,IN PB_FILA BIGINT 
)

BEGIN
DECLARE V_TOTDEBE, V_TOTHABER,V_CODCUENTA INT;
DECLARE V_NOMBRE,V_NUMSUB VARCHAR(255);
START TRANSACTION;
IF PV_OPERACION = 1 THEN
SELECT COD_CUENTA,NUM_CUENTA FROM TBL_CUENTAS WHERE NOM_CUENTA = PV_NOM_CUENTA INTO V_CODCUENTA,V_NUMSUB;
SELECT  SUM(SAL_DEBE),SUM(SAL_HABER)  FROM TBL_LIBROS_DIARIOS where COD_CUENTA = V_CODCUENTA AND FEC_LIBDIARIO BETWEEN PF_FEC AND DATE_ADD(PF_FEC,INTERVAL 1 month) INTO  V_TOTDEBE, V_TOTHABER ;

INSERT INTO TBL_LIBROS_MAYORES
(COD_CUENTA,COD_CLASIFICACION,COD_PERIODO,COD_ESTCUENTA,NUM_CUENTA,NOM_CUENTA,SAL_DEBE,SAL_HABER, FEC_LIBMAYOR)
VALUES (V_CODCUENTA,  PB_COD_CLASIFICACION, PB_COD_PERIODO, PB_COD_ESTCUENTA, V_NUMSUB, PV_NOM_CUENTA , V_TOTDEBE, V_TOTHABER, NOW());

ELSEIF PV_OPERACION = 2 THEN

UPDATE TBL_LIBROS_MAYORES
SET COD_CUENTA = PB_COD_CUENTA , COD_PERIODO = PB_COD_PERIODO,COD_ESTCUENTA =PB_COD_ESTCUENTA, NUM_CUENTA = PV_NUM_CUENTA,NOM_CUENTA = PV_NOM_CUENTA, SAL_DEBE = PD_SAL_DEBE, SAL_HABER = PD_SAL_HABER, FEC_LIBMAYOR=NOW()
WHERE COD_LIBMAYOR = PB_FILA;

ELSEIF PV_OPERACION = 3 THEN

DELETE FROM TBL_LIBROS_MAYORES 
WHERE COD_LIBMAYOR = PB_FILA; 

ELSEIF PV_OPERACION = 4 THEN

SELECT * FROM TBL_LIBROS_MAYORES;

ELSEIF PV_OPERACION = 5 THEN
SELECT * FROM TBL_LIBROS_MAYORES WHERE COD_LIBMAYOR = PB_FILA;

END IF;
COMMIT;
END;





/*
--------------------MODUOO DE MANTENIMIENTO -----------------------------------------
*/

/*
NOMBRE: PRC_OBJETOS
DESCRIPCION: PROCEDIMIENTO PARA INSERTAR ELIMINAR ACTUALIZAR Y SELECIONAR LOS DATOS 
AUTOR: SCARLETH CANALES
VERSION: 1.0


  -- PB  = PARAMETRO BIGINT
 -- PV  = PARAMETRO VARCHAR
 -- PC  = PARAMETRO CHAR
 -- PEM = PARAMETRO ENUM
 -- PF  = PARAMETRO FECHA
 -- PMI = PARAMETRO MEDIUMINT 
 -- PMT = PARAMETRO MEDIUMTEXT
 -- PI  = PARAMETRO INT
 -- PD  = PARAMETRO DECIMAL
 -- PDB = PARAMETRO DOUBLE
 -- PMB = PARAMETRO MEDIUMBLOB
*/


CREATE PROCEDURE PRC_OBJETOS(
        IN PV_OBJETO   VARCHAR(100) 
      , IN PV_DES_OBJETO VARCHAR(100)
      , IN PV_TIP_OBJETO   VARCHAR(15) 
      , IN PV_OPERACION VARCHAR(1)
      , IN PB_FILA   BIGINT  
)
BEGIN
START TRANSACTION;
IF PV_OPERACION = 1 THEN

INSERT INTO tbl_objetos
( OBJETO, DES_OBJETO, TIP_OBJETO) 
VALUES ( PV_OBJETO, PV_DES_OBJETO, PV_TIP_OBJETO);


ELSEIF PV_OPERACION = 2 THEN

UPDATE tbl_objetos
SET OBJETO = PV_OBJETO, DES_OBJETO = PV_DES_OBJETO, TIP_OBJETO = PV_TIP_OBJETO 
WHERE COD_OBJETO = PB_FILA;

ELSEIF PV_OPERACION = 3 THEN

DELETE FROM tbl_objetos
WHERE COD_OBJETO = PB_FILA; 

ELSEIF PV_OPERACION = 4 THEN

SELECT * FROM TBL_OBJETOS;

ELSEIF PV_OPERACION = 5 THEN
SELECT * FROM TBL_OBJETOS WHERE COD_OBJETO = PB_FILA;

END IF;
COMMIT;
END;

/*
--------------------MODUOO DE MANTENIMIENTO -----------------------------------------
*/

/*
NOMBRE: PRC_CLASIFICACIONES
DESCRIPCION: PROCEDIMIENTO PARA INSERTAR ELIMINAR ACTUALIZAR Y SELECIONAR LOS DATOS 
AUTOR: SCARLETH CANALES
VERSION: 1.0


  -- PB  = PARAMETRO BIGINT
 -- PV  = PARAMETRO VARCHAR
 -- PC  = PARAMETRO CHAR
 -- PEM = PARAMETRO ENUM
 -- PF  = PARAMETRO FECHA
 -- PMI = PARAMETRO MEDIUMINT 
 -- PMT = PARAMETRO MEDIUMTEXT
 -- PI  = PARAMETRO INT
 -- PD  = PARAMETRO DECIMAL
 -- PDB = PARAMETRO DOUBLE
 -- PMB = PARAMETRO MEDIUMBLOB
*/

CREATE PROCEDURE PRC_CLASIFICACIONES(
        IN PV_NATURALEZA   VARCHAR(255)
      , IN PV_OPERACION VARCHAR(1)
      , IN PB_FILA   BIGINT  
)
BEGIN
START TRANSACTION;
IF PV_OPERACION = 1 THEN

INSERT INTO tbl_clasificaciones
( NATURALEZA) 
VALUES ( PV_NATURALEZA);


ELSEIF PV_OPERACION = 2 THEN

UPDATE tbl_clasificaciones
SET  NATURALEZA = PV_NATURALEZA 
WHERE COD_CLASIFICACION = PB_FILA;

ELSEIF PV_OPERACION = 3 THEN

DELETE FROM tbl_clasificaciones
WHERE COD_CLASIFICACION = PB_FILA; 

ELSEIF PV_OPERACION = 4 THEN

SELECT * FROM TBL_CLASIFICACIONES;

ELSEIF PV_OPERACION = 5 THEN
SELECT * FROM TBL_CLASIFICACIONES WHERE COD_CLASIFICACION = PB_FILA;

END IF;
COMMIT;
END;

/*
--------------------MODUOO DE MANTENIMIENTO -----------------------------------------
*/

/*
NOMBRE: PRC_PERIODOS
DESCRIPCION: PROCEDIMIENTO PARA INSERTAR ELIMINAR ACTUALIZAR Y SELECIONAR LOS DATOS 
AUTOR: SCARLETH CANALES
VERSION: 1.0


  -- PB  = PARAMETRO BIGINT
 -- PV  = PARAMETRO VARCHAR
 -- PC  = PARAMETRO CHAR
 -- PEM = PARAMETRO ENUM
 -- PF  = PARAMETRO FECHA
 -- PMI = PARAMETRO MEDIUMINT 
 -- PMT = PARAMETRO MEDIUMTEXT
 -- PI  = PARAMETRO INT
 -- PD  = PARAMETRO DECIMAL
 -- PDB = PARAMETRO DOUBLE
 -- PMB = PARAMETRO MEDIUMBLOB
*/

CREATE PROCEDURE PRC_PERIODOS(
        IN PB_COD_USUARIO   BIGINT
      , IN PV_NOM_PERIODO VARCHAR(100)
      , IN PF_FEC_INI  DATETIME 
      , IN PF_FEC_FIN DATETIME
      , IN PV_ESTADO  VARCHAR(255)
      , IN PV_OPERACION VARCHAR(1)
      , IN PB_FILA   BIGINT  
)
BEGIN
START TRANSACTION;
IF PV_OPERACION = 1 THEN



INSERT INTO tbl_periodos
( COD_USUARIO,FEC_PERIODO, NOM_PERIODO, FEC_INI, FEC_FIN,ESTADO) 
VALUES ( PB_COD_USUARIO,NOW(),PV_NOM_PERIODO , PF_FEC_INI, PF_FEC_FIN,PV_ESTADO);


ELSEIF PV_OPERACION = 2 THEN

UPDATE tbl_periodos
SET  COD_USUARIO = PB_COD_USUARIO, FEC_PERIODO = NOW(), NOM_PERIODO = PV_NOM_PERIODO, FEC_INI = PF_FEC_INI, FEC_FIN = PF_FEC_FIN
,ESTADO =PV_ESTADO WHERE COD_PERIODO = PB_FILA;

ELSEIF PV_OPERACION = 3 THEN

DELETE FROM tbl_periodos
WHERE COD_PERIODO = PB_FILA; 

ELSEIF PV_OPERACION = 4 THEN

SELECT * FROM TBL_PERIODOS;

ELSEIF PV_OPERACION = 5 THEN
SELECT * FROM TBL_PERIODOS WHERE COD_PERIODO = PB_FILA;

END IF;
COMMIT;
END;

/*--------------------------------MODULO DE SEGURIDAD----------------------------------------------------*/
/*--------------PROC ROLES-------------------*/
/*
NOMBRE: PRC_MS_ROLES
DESCRIPCION: PROCEDIMIENTO PARA INSERTAR ELIMINAR ACTUALIZAR Y SELECIONAR LOS DATOS 
AUTOR: NOE GARCIA
VERSION: 1.0


  -- PB  = PARAMETRO BIGINT
 -- PV  = PARAMETRO VARCHAR
 -- PC  = PARAMETRO CHAR
 -- PEM = PARAMETRO ENUM
 -- PF  = PARAMETRO FECHA
 -- PMI = PARAMETRO MEDIUMINT 
 -- PMT = PARAMETRO MEDIUMTEXT
 -- PI  = PARAMETRO INT
 -- PD  = PARAMETRO DECIMAL
 -- PDB = PARAMETRO DOUBLE
 -- PMB = PARAMETRO MEDIUMBLOB
*/

CREATE PROCEDURE PRC_MS_ROLES(
        IN PB_COD_ROL  BIGINT 
      , IN PV_TIP_ROL  VARCHAR(30) 
      , IN PV_DES_ROL  VARCHAR(50)
      , IN PV_OPERACION VARCHAR(1)
      , IN PB_FILA   BIGINT 
)
BEGIN
START TRANSACTION;
IF PV_OPERACION = 1 THEN

INSERT INTO tbl_ms_roles
(ROL, DES_ROL) 
VALUES (PV_TIP_ROL, PV_DES_ROL);


ELSEIF PV_OPERACION = 2 THEN

UPDATE tbl_ms_roles 
SET COD_ROL = PB_COD_ROL , ROL = PV_TIP_ROL, DES_ROL = PV_DES_ROL 
WHERE COD_ROL = PB_FILA;

ELSEIF PV_OPERACION = 3 THEN

DELETE FROM tbl_ms_roles 
WHERE COD_ROL = PB_FILA; 

ELSEIF PV_OPERACION = 4 THEN

SELECT * FROM TBL_MS_ROLES;

ELSEIF PV_OPERACION = 5 THEN
SELECT * FROM TBL_MS_ROLES WHERE COD_ROL = PB_FILA;

END IF;
COMMIT;
END;
/*---------------------------------------------------------*/
/*
NOMBRE: PRC_ROLES_OBJETOS
DESCRIPCION: PROCEDIMIENTO PARA INSERTAR ELIMINAR ACTUALIZAR Y SELECIONAR LOS DATOS 
AUTOR: NOE GARCIA
VERSION: 1.0


  -- PB  = PARAMETRO BIGINT
 -- PV  = PARAMETRO VARCHAR
 -- PC  = PARAMETRO CHAR
 -- PEM = PARAMETRO ENUM
 -- PF  = PARAMETRO FECHA
 -- PMI = PARAMETRO MEDIUMINT 
 -- PMT = PARAMETRO MEDIUMTEXT
 -- PI  = PARAMETRO INT
 -- PD  = PARAMETRO DECIMAL
 -- PDB = PARAMETRO DOUBLE
 -- PMB = PARAMETRO MEDIUMBLOB
*/

/*--------------PROCEDIMIENTOS DE ROLES OBJETOS------------*/
CREATE PROCEDURE PRC_ROLES_OBJETOS(
        IN PB_COD_ROL  BIGINT 
      , IN PB_COD_OBJETO  BIGINT 
      , IN PV_PER_EDICION  VARCHAR(1)
      , IN PV_PER_ELIMINAR  VARCHAR(1)
      , IN PV_PER_ACTUALIZAR  VARCHAR(1)
      , IN PF_FEC_CREACION  DATE
      , IN PV_CRERADO_POR  VARCHAR(100)
      , IN PF_FEC_MODIFICACION  DATE
      , IN PV_MOD_POR  VARCHAR(100)
      , IN PV_OPERACION VARCHAR(1)
      , IN PB_FILA   BIGINT 
)
BEGIN
START TRANSACTION;
IF PV_OPERACION = 1 THEN

INSERT INTO tbl_roles_objetos
(COD_ROL, COD_OBJETO, PER_EDICION, PER_ELIMINAR, PER_ACTUALIZAR, FEC_CREACION, CREADO_POR, FEC_MODIFICACION, MOD_POR) 
VALUES (PB_COD_ROL, PB_COD_OBJETO, PV_PER_EDICION, PV_PER_ELIMINAR, PV_PER_ACTUALIZAR, PF_FEC_CREACION, PV_CREADO_POR, PF_FEC_MODIFICACION, PV_MOD_POR);


ELSEIF PV_OPERACION = 2 THEN

UPDATE tbl_ms_roles 
SET COD_ROL=PB_COD_ROL, COD_OBJETO=PB_COD_OBJETO, PER_EDICION=PV_PER_EDICION, 
PER_ELIMINAR=PV_PER_ELIMINAR, PER_ACTUALIZAR=PV_PER_ACTUALIZAR, FEC_CREACION=PF_FEC_CREACION, 
CREADO_POR=PV_CREADO_POR, FEC_MODIFICACION=PF_FEC_MODIFICACION, MOD_POR=PV_MOD_POR 
WHERE COD_ROL = PB_FILA;

ELSEIF PV_OPERACION = 3 THEN

DELETE FROM tbl_roles_objetos 
WHERE COD_ROL = PB_FILA; 

ELSEIF PV_OPERACION = 4 THEN

SELECT * FROM TBL_MS_ROLES;

ELSEIF PV_OPERACION = 5 THEN
SELECT * FROM TBL_ROLES_OBJETOS WHERE COD_ROL = PB_FILA;

END IF;
COMMIT;
END;
/*------------------------------------------------------------*/
/*
NOMBRE: PRC_PERMISOS
DESCRIPCION: PROCEDIMIENTO PARA INSERTAR ELIMINAR ACTUALIZAR Y SELECIONAR LOS DATOS 
AUTOR: NOE GARCIA
VERSION: 1.0


  -- PB  = PARAMETRO BIGINT
 -- PV  = PARAMETRO VARCHAR
 -- PC  = PARAMETRO CHAR
 -- PEM = PARAMETRO ENUM
 -- PF  = PARAMETRO FECHA
 -- PMI = PARAMETRO MEDIUMINT 
 -- PMT = PARAMETRO MEDIUMTEXT
 -- PI  = PARAMETRO INT
 -- PD  = PARAMETRO DECIMAL
 -- PDB = PARAMETRO DOUBLE
 -- PMB = PARAMETRO MEDIUMBLOB
*/
/*--------------PROC PERMISOS-----------------*/
CREATE PROCEDURE PRC_PERMISOS(
        IN PB_COD_ROL  BIGINT 
      , IN PB_COD_OBJETO  BIGINT 
      , IN PV_PER_INSERCION  VARCHAR(1)
      , IN PV_PER_ELIMINAR  VARCHAR(1)
      , IN PV_PER_ACTUALIZAR  VARCHAR(1)
      , IN PV_PER_CONSULTAR  VARCHAR(1)
      , IN PV_OPERACION VARCHAR(1)
      , IN PB_FILA   BIGINT 
)
BEGIN
START TRANSACTION;
IF PV_OPERACION = 1 THEN

INSERT INTO tbl_permisos
(COD_ROL, COD_OBJETO, PER_INSERCION, PER_ELIMINAR, PER_ACTUALIZAR, PER_CONSULTAR) 
VALUES (PB_COD_ROL, PB_COD_OBJETO, PV_PER_INSERCION, PV_PER_ELIMINAR, PV_PER_ACTUALIZAR, PV_PER_CONSULTAR);


ELSEIF PV_OPERACION = 2 THEN

UPDATE tbl_permisos 
SET COD_ROL=PB_COD_ROL, COD_OBJETO=PB_COD_OBJETO, PER_INSERCION=PV_PER_INSERCION, 
PER_ELIMINAR=PV_PER_ELIMINAR, PER_ACTUALIZAR=PV_PER_ACTUALIZAR, PER_CONSULTAR=PV_PER_CONSULTAR 
WHERE COD_ROL = PB_FILA;

ELSEIF PV_OPERACION = 3 THEN

DELETE FROM tbl_permisos
WHERE COD_ROL = PB_FILA; 

ELSEIF PV_OPERACION = 4 THEN

SELECT * FROM TBL_PERMISOS;

ELSEIF PV_OPERACION = 5 THEN
SELECT * FROM TBL_PERMISOS WHERE COD_ROL = PB_FILA;

END IF;
COMMIT;
END;
/*---------------------------------------------------------*/
/*
NOMBRE: TRG_BITACORA
DESCRIPCION: TRIGGER PARA REGISTRAS LAS ACCIONES DEL SISTEMA
AUTOR: NOE GARCIA
VERSION: 1.0


  -- PB  = PARAMETRO BIGINT
 -- PV  = PARAMETRO VARCHAR
 -- PC  = PARAMETRO CHAR
 -- PEM = PARAMETRO ENUM
 -- PF  = PARAMETRO FECHA
 -- PMI = PARAMETRO MEDIUMINT 
 -- PMT = PARAMETRO MEDIUMTEXT
 -- PI  = PARAMETRO INT
 -- PD  = PARAMETRO DECIMAL
 -- PDB = PARAMETRO DOUBLE
 -- PMB = PARAMETRO MEDIUMBLOB
*/
/*---------------TRIGGER BITACORA--------------------------*/
CREATE TRIGGER Bitacora after insert on TBL_MS_USR
for each row
BEGIN 
declare cont BIGINT;
set cont = (SELECT COUNT(*) FROM TBL_OBJETOS);
insert into TBL_MS_BITACORAS (FEC_REGISTRO, USR_REGISTRA, COD_USR, ACC_SISTEMA, DES_BITACORA,COD_OBJETO)
values (now(),current_user(), new.COD_USR, new.PRIMER_ACC,new.CORREO,cont);
END;
/*----------------------------------------------------------*/






-- /////////////////// SELECCIONAR MS USR ////////////////////////////////


CREATE  PROCEDURE `PROC_MS_USR_SELECCIONAR`(
/*
 * NOMBRE : SELECCIONAR TABLAS MS USR
 * DESCRIPCIÓN : PROCEDIMIENTOS SELECCIONAR TBL_MS_USR
 * AUTOR: JEYSON MÓRAN
 * VERSION : 1.0  
 * */)
BEGIN
	START TRANSACTION;
SELECT 
COD_USR AS CODIGO_USUARIO,
USR AS USUARIO,
NOM_USR AS NOMBRE_USUARIO,
EST_USR AS ESTADO_USUARIO,
FEC_ULT_CONN AS FECHA_ULTIMO_ACCESO,
PREG_RES AS PREGUNTA_RESPONDIDA,
PRIMER_ACC AS PRIMER_ACCESO,
CORREO AS CORREO_ELECTRONICO
FROM TBL_MS_USR;

SELECT
COD_PREG AS CODIGO_PREGUNTA,
PREGUNTA AS PREGUNTA
FROM TBL_MS_PREG;

SELECT 
COD_PREG AS CODIGO_RESPUESTA,
RESPUESTA AS RESPUESTA
FROM TBL_MS_PREG_USR;

COMMIT;
END;

-- /////////////////// ELIMINAR POR NUMERO CODIGO ////////////////////////////////

CREATE  PROCEDURE `PROC_MS_USR_ELIMINAR`(
  /*
 * NOMBRE : ELIMINAR TABLAS NUMERO CODIGO
 * DESCRIPCIÓN : PROCEDIMIENTOS ELIMINAR TBL_MS_USR
 * AUTOR: JEYSON MÓRAN
 * VERSION : 1.0  
 * */
  IN `PB_COD` BIGINT(20)
)
BEGIN
	START TRANSACTION;
DELETE FROM TBL_MS_USR WHERE COD_USR = PB_COD;
DELETE FROM TBL_MS_PREG WHERE COD_PREG  = PB_COD;
DELETE FROM TBL_MS_PREG_USR WHERE COD_PREG = PB_COD;
DELETE FROM TBL_MS_HIST_CONTRASEGNA WHERE COD_HIST_CONTRA = PB_COD;
DELETE FROM TBL_MS_BITACORA_USR  WHERE COD_BITACORA_USR  = PB_COD;
COMMIT;
END;

-- /////////////////// INSERTAR USUARIO ////////////////////////////////


CREATE  PROCEDURE `PROC_MS_USR_INSERTAR`(
/*
 * NOMBRE : INSERTAR TABLAS MS USUARIOS
 * DESCRIPCIÓN : PROCEDIMIENTOS INSERTAR TBL_MS_USR
 * AUTOR: JEYSON MÓRAN
 * VERSION : 1.0  
 * */
 -- PB  = PARAMETRO BIGINT
 -- PV  = PARAMETRO VARCHAR
 -- PC  = PARAMETRO CHAR
 -- PEM = PARAMETRO ENUM
 -- PF  = PARAMETRO FECHA
 -- PMI = PARAMETRO MEDIUMINT 
 -- PMT = PARAMETRO MEDIUMTEXT
 -- PI  = PARAMETRO INT
 -- PTI = PARAMETRO TYNINT
 -- PD  = PARAMETRO DECIMAL
 -- PDB = PARAMETRO DOUBLE
 -- PMB = PARAMETRO MEDIUMBLOB
 -- PARAMETROS:

IN `PV_USR` 			VARCHAR(50), 
IN `PV_NOM_USR` 		VARCHAR(100), 
IN `PF_FEC_ULT_CONN` 	DATE, 
IN `PB_PREG_RES`		BIGINT(20), 
IN `PB_PRIMER_ACC` 		BIGINT(20), 
IN `PV_CORREO` 			VARCHAR(100), 
IN `PV_PREGUNTA` 		VARCHAR(100), 
IN `PV_RESPUESTA` 		VARCHAR(100), 
IN `PV_CONTRASEGNA` 	VARCHAR(32)

)
BEGIN
	START TRANSACTION;

SELECT  @USR := COUNT(COD_USR) FROM TBL_MS_USR;

IF @USR = 0 THEN 
	ALTER TABLE TBL_MS_USR  AUTO_INCREMENT = 0;
	ALTER TABLE TBL_MS_PREG  AUTO_INCREMENT = 0;
	ALTER TABLE TBL_MS_PREG_USR  AUTO_INCREMENT = 0;
	ALTER TABLE TBL_MS_HIST_CONTRASEGNA  AUTO_INCREMENT = 0;
	ALTER TABLE TBL_MS_BITACORA_USR AUTO_INCREMENT = 0;
END IF;

-- INSERTAR TABLA MS USUARIOS
INSERT INTO TBL_MS_USR(
USR,
NOM_USR,
FEC_ULT_CONN,	 		
PREG_RES,				
PRIMER_ACC, 				
CORREO)
VALUES(
PV_USR,
PV_NOM_USR,
PF_FEC_ULT_CONN,	 		
PB_PREG_RES,				
PB_PRIMER_ACC, 				
PV_CORREO
);


-- INSERTAR TABLA MS PREGUNTAS
INSERT INTO TBL_MS_PREG(
PREGUNTA)
VALUES(
PV_PREGUNTA
);

SELECT @COD_USR := MAX(COD_USR) FROM TBL_MS_USR;

-- INSERTAR TABLA MS PREGUNTAS USUARIOS
INSERT INTO TBL_MS_PREG_USR(
COD_USR,
RESPUESTA)
VALUES(
@COD_USR,
PV_RESPUESTA
);

-- INSERTAR TABLA HISTORIAL CONTRASEÑA
INSERT INTO TBL_MS_HIST_CONTRASEGNA(
COD_USR,
CONTRASEGNA)
VALUES(
@COD_USR,
PV_CONTRASEGNA
);

-- INSERTAR TABLA BITACORA USUARIOS
INSERT INTO TBL_MS_BITACORA_USR (
COD_USR,
COD_CONTRA,
USR_CREA_POR,
USR_MODF_POR,
USR_FEC_CREA,
USR_FEC_MODF, 
CONTRA_CREA_POR, 
CONTRA_MODF_POR, 
CONTRA_FEC_CREA, 
CONTRA_FEC_MODF)
VALUES(
@COD_USR,
@COD_USR,
CURRENT_USER(),
CURRENT_USER(),
NOW(),
NOW(),
CURRENT_USER(),
CURRENT_USER(),
NOW(),
NOW()
);


COMMIT;
END;

-- /////////////////// ACTUALIZAR USUARIO ////////////////////////////////

CREATE PROCEDURE `PROC_MS_USR_ACTUALIZAR`(
/*
 * NOMBRE : ACTUALIZAR TABLAS MS USUARIOS
 * DESCRIPCIÓN : PROCEDIMIENTOS ACTUALIZAR TBL_MS_USR
 * AUTOR: JEYSON MÓRAN
 * VERSION : 1.0  
 * */
 -- PB  = PARAMETRO BIGINT
 -- PV  = PARAMETRO VARCHAR
 -- PC  = PARAMETRO CHAR
 -- PEM = PARAMETRO ENUM
 -- PF  = PARAMETRO FECHA
 -- PMI = PARAMETRO MEDIUMINT 
 -- PMT = PARAMETRO MEDIUMTEXT
 -- PI  = PARAMETRO INT
 -- PTI = PARAMETRO TYNINT
 -- PD  = PARAMETRO DECIMAL
 -- PDB = PARAMETRO DOUBLE
 -- PMB = PARAMETRO MEDIUMBLOB
 -- PARAMETROS:

 IN PV_USR             		VARCHAR(50),
 IN PV_NOM_USR		    	VARCHAR(100),
 IN PEM_EST_USR       		ENUM('BLOQUEADO', 'ACTIVO','INACTIVO','NUEVO'), 
 IN PF_FEC_ULT_CONN	 		DATE,
 IN PB_PREG_RES				BIGINT(20),
 IN PB_PRIMER_ACC 			BIGINT(20),
 IN PV_CORREO 				VARCHAR(100),
 IN PV_PREGUNTA 			VARCHAR(100),
 IN PV_RESPUESTA 			VARCHAR(100),
 IN PB_FILA 				BIGINT(20)
 
)
BEGIN
	START TRANSACTION;

SELECT  @USR := COUNT(COD_USR) FROM TBL_MS_USR;

IF @USR = 0 THEN 
	ALTER TABLE TBL_MS_USR  AUTO_INCREMENT = 0;
	ALTER TABLE TBL_MS_PREG  AUTO_INCREMENT = 0;
	ALTER TABLE TBL_MS_PREG_USR  AUTO_INCREMENT = 0;
	ALTER TABLE TBL_MS_HIST_CONTRASEGNA  AUTO_INCREMENT = 0;
END IF;

-- ACTUALIZAR TABLA MS USUARIOS
	UPDATE TBL_MS_USR 
	SET USR			 = PV_USR,
		NOM_USR		 = PV_USR,
		EST_USR 	 = PEM_EST_USR,
		FEC_ULT_CONN = PF_FEC_ULT_CONN, 				
		CORREO		 = PV_CORREO
	WHERE COD_USR = PB_FILA;

-- ACTUALIZAR TABLA MS PREGUNTAS
	UPDATE TBL_MS_PREG  
	SET PREGUNTA = PV_PREGUNTA
	WHERE COD_PREG = PB_FILA;

-- ACTUALIZAR TABLA MS PREGUNTAS USUARIOS
	UPDATE TBL_MS_PREG_USR  
	SET RESPUESTA = PV_RESPUESTA
	WHERE COD_PREG = PB_FILA;
  
-- ACTUALIZAR TABLA MS BITACORA USUARIOS
 	UPDATE TBL_MS_BITACORA_USR  
	SET USR_MODF_POR = CURRENT_USER(),
		USR_FEC_MODF = NOW()
	WHERE COD_BITACORA_USR = PB_FILA;

	
COMMIT;
END;

-- /////////////////// MODIFICAR CONTRASEÑA ////////////////////////////////

CREATE PROCEDURE `PROC_MS_USR_MODF_CONTRA`(
  /*
 * NOMBRE : MODIFICAR TABLAS MS USR CONTRSEÑA
 * DESCRIPCIÓN : PROCEDIMIENTOS MODIFICAR TBL_MS_USR CONTRASEÑA
 * AUTOR: JEYSON MÓRAN
 * VERSION : 1.0  
 * */
 	IN PV_CONTRASEGNA VARCHAR(32),
 	IN PB_COD BIGINT(20)
 	
)
BEGIN
	START TRANSACTION;
-- ACTUALIZAR TABLA HISTORIAL CONTRASEÑA
	UPDATE TBL_MS_HIST_CONTRASEGNA 
	SET CONTRASEGNA = PV_CONTRASEGNA
	WHERE COD_HIST_CONTRA = PB_COD;

-- ACTUALIZAR TABLA BITACORA USR
 	UPDATE TBL_MS_BITACORA_USR  
	SET CONTRA_MODF_POR = CURRENT_USER(),
		CONTRA_FEC_MODF = CURRENT_TIMESTAMP()
	WHERE COD_BITACORA_USR = PB_COD;
COMMIT;
END



