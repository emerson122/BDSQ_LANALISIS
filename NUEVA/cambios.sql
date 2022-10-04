DROP PROCEDURE IF EXISTS PRC_LIBROS_MAYORES;
CREATE PROCEDURE PRC_LIBROS_MAYORES(
  
  IN PB_COD_PERIODO BIGINT                               
, IN PB_COD_ESTCUENTA BIGINT                             
, IN PV_NUM_CUENTA   VARCHAR(255)               
, IN PV_NOM_CUENTA   VARCHAR(255) 
, IN PD_SAL_DEBE   DECIMAL (8,2) 
, IN PD_SAL_HABER  DECIMAL (8,2)
, IN PF_FEC        DATE
, IN PV_OPERACION VARCHAR (1)
, IN PB_FILA BIGINT 
)

BEGIN
DECLARE V_TOTDEBE, V_TOTHABER,V_CODCUENTA,V_CLASIFICACION INT;
DECLARE V_NOMBRE,V_NUMSUB VARCHAR(255);
START TRANSACTION;
IF PV_OPERACION = 1 THEN
SELECT COD_CLASIFICACION, COD_CUENTA,NUM_CUENTA FROM TBL_CUENTAS WHERE NOM_CUENTA = PV_NOM_CUENTA INTO V_CLASIFICACION,V_CODCUENTA,V_NUMSUB;
SELECT  SUM(SAL_DEBE),SUM(SAL_HABER)  FROM TBL_LIBROS_DIARIOS where COD_CUENTA = V_CODCUENTA AND FEC_LIBDIARIO BETWEEN PF_FEC AND DATE_ADD(PF_FEC,INTERVAL 1 month) INTO  V_TOTDEBE, V_TOTHABER ;

INSERT INTO TBL_LIBROS_MAYORES
(COD_CUENTA,COD_CLASIFICACION,COD_PERIODO,COD_ESTCUENTA,NUM_CUENTA,NOM_CUENTA,SAL_DEBE,SAL_HABER, FEC_LIBMAYOR)
VALUES (V_CODCUENTA,  V_CLASIFICACION, PB_COD_PERIODO, PB_COD_ESTCUENTA, V_NUMSUB, PV_NOM_CUENTA , V_TOTDEBE, V_TOTHABER, NOW());

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



DROP PROCEDURE IF EXISTS PRC_SALDOS_BALANCES;

CREATE PROCEDURE PRC_SALDOS_BALANCES(
        IN PB_COD_BALANCE  BIGINT 
      , IN PI_TOT_ACTIVO   INT 
      , IN PI_TOT_PASPAT   INT 
      , IN PV_OPERACION VARCHAR(1)
      , IN PB_FILA   BIGINT 
)
BEGIN
DECLARE V_ACTIVO,V_PASIVO,V_PATRIMONIO,V_TOTAL BIGINT;
START TRANSACTION;
IF PV_OPERACION = 1 THEN

SELECT SUM(TOT_ACTIVO),SUM(TOT_PASIVO),SUM(TOT_PATRIMONIO) FROM TBL_BALANCES_GENERALES INTO V_ACTIVO,V_PASIVO,V_PATRIMONIO ;

SET V_TOTAL := V_PASIVO + V_PATRIMONIO;

INSERT INTO tbl_saldos_balances
( FEC_SALDOS, TOT_ACTIVO, TOT_PASPAT) 
VALUES ( NOW(), V_ACTIVO, V_TOTAL);


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







DROP PROCEDURE IF EXISTS PRC_LIBDIARIO;
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


/*Insertar Libro Diario CUENTA Y SUBCUENTA  */
IF PV_OPERACION = 1 THEN
/*---------------------------------------------------------------------------------------------------------*/
SELECT COD_CUENTA FROM TBL_CUENTAS WHERE NOM_CUENTA =  PV_NOM_CUENTA INTO V_CODCUENTA; 
SELECT COD_SUBCUENTA, NUM_SUBCUENTA  FROM TBL_SUBCUENTAS WHERE NOM_SUBCUENTA = PV_NOM_SUBCUENTA INTO V_CODSUBCUENTA,V_SUBCUENTA; 
-- SELECT COD_ESTADO from tbl_estados_subcuentas where cod_subcuenta = V_CODSUBCUENTA INTO V_CODESTCUENTA;
/*
INSERT INTO tbl_libros_diarios
(COD_CUENTA, COD_SUBCUENTA, COD_ESTADO, NUM_SUBCUENTA, NOM_SUBCUENTA, SAL_DEBE, SAL_HABER, FEC_LIBDIARIO) 
VALUES (V_CODCUENTA, V_CODSUBCUENTA, V_CODESTCUENTA, V_SUBCUENTA, PV_NOM_SUBCUENTA, PV_SALDO_DEBE, PV_SALDO_HABER, now());
*/

INSERT INTO tbl_libros_diarios
(COD_CUENTA, NUM_SUBCUENTA, NOM_SUBCUENTA, SAL_DEBE, SAL_HABER, FEC_LIBDIARIO) 
VALUES (V_CODCUENTA, V_SUBCUENTA, PV_NOM_SUBCUENTA, PV_SALDO_DEBE, PV_SALDO_HABER, now());



INSERT INTO trans_libsub
(COD_SUBCUENTA) 
VALUES (V_CODSUBCUENTA);



SELECT @COD_ESTADO := MAX(COD_LIBDIARIO) FROM TBL_LIBROS_DIARIOS;

/*Se Actualiza el estado de las cuentas*/
UPDATE tbl_estados_cuentas 
SET   EST_CUENTA = 'PENDIENTE'
WHERE COD_CUENTA = V_CODCUENTA;

-- ACTUALIZAR ESTADO DE SUBCUENTA
UPDATE tbl_estados_subcuentas 
SET  EST_SUBCUENTAS = 'PENDIENTE' 
WHERE COD_SUBCUENTA =  V_CODSUBCUENTA;

ELSEIF PV_OPERACION = 2 THEN
SELECT COD_CUENTA,NUM_CUENTA FROM TBL_CUENTAS WHERE NOM_CUENTA =  PV_NOM_CUENTA INTO V_CODCUENTA,V_SUBCUENTA; 
SELECT COD_ESTCUENTA from tbl_estados_cuentas where cod_cuenta = V_CODCUENTA INTO V_CODESTCUENTA;
/*
INSERT INTO tbl_libros_diarios
(COD_CUENTA, COD_SUBCUENTA, COD_ESTADO, NUM_SUBCUENTA, NOM_SUBCUENTA, SAL_DEBE, SAL_HABER, FEC_LIBDIARIO) 
VALUES (V_CODCUENTA, V_CODSUBCUENTA, V_CODESTCUENTA, V_SUBCUENTA, PV_NOM_SUBCUENTA, PV_SALDO_DEBE, PV_SALDO_HABER, now());
*/

INSERT INTO tbl_libros_diarios
(COD_CUENTA, NUM_SUBCUENTA, NOM_SUBCUENTA, SAL_DEBE, SAL_HABER, FEC_LIBDIARIO) 
VALUES (V_CODCUENTA, V_SUBCUENTA, PV_NOM_CUENTA, PV_SALDO_DEBE, PV_SALDO_HABER, now());



SELECT @COD_ESTCUENTA := MAX(COD_LIBDIARIO) FROM TBL_LIBROS_DIARIOS;

/*Se Actualiza el estado de las cuentas*/
UPDATE tbl_estados_cuentas 
SET  EST_CUENTA = 'PENDIENTE'
WHERE COD_CUENTA = V_CODCUENTA;

/*Trae los datos de las subcuentas disponibles*/
ELSEIF PV_OPERACION = 3 THEN
SELECT NUM_SUBCUENTA, NOM_SUBCUENTA FROM TBL_SUBCUENTAS WHERE COD_CUENTA =  PB_FILA ;

ELSEIF PV_OPERACION = 4 THEN
SELECT NUM_CUENTA,NOM_CUENTA FROM TBL_CUENTAS ORDER BY NUM_CUENTA Asc;

ELSEIF PV_OPERACION = 5 THEN
SELECT * FROM TBL_LIBROS_DIARIOS;

ELSEIF PV_OPERACION = 6 THEN
SELECT * FROM TBL_LIBROS_DIARIOS WHERE COD_LIBDIARIO = PB_FILA;
END IF;
COMMIT;
END;




DROP PROCEDURE IF EXISTS UPD_LIBDIARIO;
CREATE PROCEDURE UPD_LIBDIARIO(
 IN PB_COD_CUENTA    BIGINT                                                                
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
SET COD_CUENTA = PB_COD_CUENTA ,  NUM_SUBCUENTA = PB_NUM_SUBCUENTA, NOM_SUBCUENTA = PB_NOM_SUBCUENTA, SAL_DEBE = PB_SAL_DEBE, SAL_HABER = PB_SAL_HABER, FEC_LIBDIARIO = NOW() 
WHERE COD_LIBDIARIO = PB_FILA;
COMMIT;
END;

