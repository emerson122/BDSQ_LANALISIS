CREATE PROCEDURE INS_CUENTAS(
   IN PV_NATURALEZA Varchar(255)
  ,IN PV_NOMBRE_CUENTA VARCHAR(255)
  ,IN PV_NUM_CUENTA VARCHAR(255)
  /*,IN PV_OPERACION VARCHAR(1)
  ,IN PB_FILA BIGINT */
)
BEGIN
DECLARE V_CODIGO VARCHAR(255);
DECLARE V_VALIDADORDEEXISTENCIA INT;
/*LLEVA FORANEA CON LA CLASIFICACION*/
/*Valida naturaleza*/
SELECT COD_CLASIFICACION FROM TBL_CLASIFICACIONES WHERE NATURALEZA = PV_NATURALEZA INTO V_CODIGO;
/*Valida existencia*/
select count(*) from tbl_cuentas where NUM_CUENTA = CONCAT(V_CODIGO,'.',PV_NUM_CUENTA) INTO V_VALIDADORDEEXISTENCIA;
/*si NO existe*/
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
END IF;
COMMIT;
END;



CREATE PROCEDURE PRC_LIBDIARIO(

   IN PV_NOM_CUENTA VARCHAR(255)
  ,IN PV_NOM_SUBCUENTA VARCHAR(255)
  ,IN PV_SALDO_DEBE INT
  ,IN PV_SALDO_HABER INT
  ,IN PV_OPERACION VARCHAR(1)
  , IN PB_FILA BIGINT 
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
--------------------MANTENIMIENTO SCARLETH -----------------------------------------
*/

/* 
    PB  = PARAMETRO BIGINT
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
