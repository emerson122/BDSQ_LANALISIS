
-- todos los procedimientos necesitan adaptarse a la nueva estructura de las base de datos

CREATE PROCEDURE PROC_CUENTAS(
  IN NOMBRE_CUENTA VARCHAR(255)
  ,IN PV_NATURALEZA VARCHAR(255)
  ,IN PV_CUENTA VARCHAR(255)
)
BEGIN
DECLARE CODIGO VARCHAR(255);
DECLARE VALIDADORDEEXISTENCIA INT;
/*LLEVA FORANEA CON LA CLASIFICACION*/
/*Valida naturaleza*/
SELECT COD_CLASIFICACION FROM TBL_CLASIFICACION WHERE NATURALEZA = PV_NATURALEZA INTO CODIGO;
/*Valida existencia*/
select count(*) from tbl_crear_cuentas where NUM_CUENTA =  CONCAT(CODIGO,'.',PV_CUENTA) INTO VALIDADORDEEXISTENCIA;
/*si NO existe*/
IF VALIDADORDEEXISTENCIA = 0 THEN

/*insetar  cuentas */
INSERT INTO tbl_crear_cuentas(
   NATURALEZA
  ,NUM_CUENTA
  ,NOM_CUENTA
) VALUES (
   PV_NATURALEZA -- NATURALEZA - IN varchar(255)
  ,CONCAT(CODIGO,'.',PV_CUENTA) -- NUM_CUENTA - IN varchar(255)
  ,NOMBRE_CUENTA-- NOM_CUENTA - IN varchar(255)
);
/* Si existe despliega mensaje que esta duplicado */
ELSE
SELECT 'NUMERO DE CUENTA DUPLICADA';
END IF;
COMMIT;
END;
/*insertar en subcuenta*/

CREATE PROCEDURE PROC_SUBCUENTAS(
     IN PV_OPCION VARCHAR(1)
    ,IN PV_SUBCUENTA VARCHAR(255)
    ,IN PV_NOMBRE    VARCHAR(255)
    ,IN PV_SUBGRUPO     VARCHAR(255)
    ,IN PV_NATURAL VARCHAR(255)
    )
BEGIN
DECLARE V_CODIGO VARCHAR(255);
DECLARE VALIDADORDEEXISTENCIA INT;
DECLARE V_NATURALEZA VARCHAR(255);
DECLARE V_FORANEA BIGINT;
/* SE LE HACE UN SELECT A TODOS LAS CUENTAS POR LA NATURALEZA QUE SE ESPECIFIQUE PARA PRESENTARLE UNA LISTA AL USUARIO
Y QUE PUEDA ESCOGER COMO SUB CUENTA DE QUE CUENTA QUIERE CREAR UNA NUEVA SUBCUENTA */
IF PV_OPCION = 1 THEN
SELECT NOM_CUENTA FROM tbl_crear_cuentas WHERE NATURALEZA = PV_NATURAL;

ELSEIF PV_OPCION = 2 THEN 
SELECT COD_CUENTA,NUM_CUENTA, NATURALEZA FROM tbl_crear_cuentas  WHERE NOM_CUENTA = PV_SUBGRUPO INTO V_FORANEA,V_CODIGO, V_NATURALEZA;
select count(*) from tbl_subcuentas where NUM_SUBCUENTA =  CONCAT(V_CODIGO,'.',PV_SUBCUENTA) INTO VALIDADORDEEXISTENCIA;

  IF VALIDADORDEEXISTENCIA = 0 THEN
    INSERT INTO tbl_subcuentas(
     COD_CUENTA
    ,NUM_SUBCUENTA
    ,NOM_SUBCUENTA
    ,SUBGRUPO
    ,NATURALEZA
  ) VALUES( 
     V_FORANEA
    ,CONCAT(V_CODIGO,'.',PV_SUBCUENTA) -- NUM_SUBCUENTA - IN varchar(255)
    ,PV_NOMBRE -- NOM_SUBCUENTA - IN varchar(255)
    ,PV_SUBGRUPO -- SUBGRUPO - IN varchar(255)
    ,V_NATURALEZA -- NATURALEZA - IN varchar(255)
  );
  else
  select "subcuenta duplicada";
  END IF;
END IF; 
COMMIT;
END;

/* modulo de periodo */
/* Procedimiento libro diario*/
CREATE PROCEDURE PROC_LIBDIARIO(
  IN PV_NUM_CUENTA VARCHAR(255)
, IN PV_NOM_CUENTA VARCHAR(255)
, IN PV_NUM_SUBCUENTA VARCHAR(255)
, IN PV_NOM_SUBCUENTA VARCHAR(255)
, IN PV_SALDO_DEBE INT
, IN PV_SALDO_HABER INT
, IN PV_OPCION VARCHAR(1)
)
BEGIN
IF PV_OPCION = 1 THEN
/*Mostrar una lista al usuario de las cuentas diponibles*/
SELECT NUM_CUENTA,NOM_CUENTA FROM TBL_CREAR_CUENTAS order by NUM_CUENTA Asc;
ELSEIF PV_OPCION = 2 THEN
/*Mostrar al usuario una lista de las subcuentas disponibles*/
SELECT NUM_SUBCUENTA,NOM_SUBCUENTA FROM TBL_SUBCUENTAS WHERE SUBGRUPO = PV_NOM_CUENTA order by NUM_SUBCUENTA Asc;

ELSEIF PV_OPCION = 3 THEN
/*Inserta los datos en la base de datos*/
INSERT INTO tbl_libro_diario
(NUM_CUENTA, NOM_CUENTA, NUM_SUBCUENTA, NOM_SUBCUENTA,SALDO_DEBE,SALDO_HABER, FEC_LIBDIARIO) 
VALUES (PV_NUM_CUENTA, PV_NOM_CUENTA, PV_NUM_SUBCUENTA, PV_NOM_SUBCUENTA, PV_SALDO_DEBE, PV_SALDO_HABER,now());
END IF;
COMMIT;
END;

/*Procedimiento libro Mayor'
cada transaccion que se haga desde libro diario debe sumar a lo que ya habia en el libro mayor

https://www.youtube.com/watch?v=dAXWkwXVFZg

minuto 9:45 se restan ambos totales y da un saldo acreedor o un saldo deudor
*/

/*lIBRO MAYOR DEBERIA BORRASE LOS DATOS MENSUALMENTE*/
CREATE PROCEDURE PROC_LIBMAYOR(
  IN PV_NUM_CUENTA VARCHAR(255)
, IN PV_NOM_CUENTA VARCHAR(255)
, IN PV_NATURALEZA VARCHAR(255)
,IN   PV_FEC       VARCHAR(255) 
, IN PV_OPCION VARCHAR(1)
)
BEGIN
DECLARE V_TOTDEBE, V_TOTHABER INT;
DECLARE V_NOMBRE VARCHAR(255);
IF PV_OPCION = 1 THEN
/*Mostrar una lista al usuario de las cuentas diponibles*/
SELECT NUM_CUENTA,NOM_CUENTA,Naturaleza FROM TBL_CREAR_CUENTAS order by NUM_CUENTA Asc;


ELSEIF PV_OPCION = 2 THEN
/*CONSEGUIR LA SUMA TOTAL DE LOS SALDOS DE LA CUENTA DE LIBRO DIARIO*/
/*Pa usarlo en el procedimiento se debe colocar el total de bancos*/
SELECT NOM_CUENTA, SUM(SALDO_DEBE),SUM(SALDO_HABER)  FROM TBL_LIBRO_DIARIO where NOM_CUENTA = PV_NOM_CUENTA AND FEC_LIBDIARIO BETWEEN PV_FEC AND DATE_ADD(PV_FEC,INTERVAL 1 month) INTO V_NOMBRE, V_TOTDEBE, V_TOTHABER ;
  
  /*Select SUM(SALDO_DEBE),SUM(SALDO_HABER) from tbl_libro_diario WHERE NOM_CUENTA = PV_NOM_CUENTA INTO V_TOTDEBE, V_TOTHABER ; */
  
/*Inserta los datos en la base de datos*/
INSERT INTO tbl_libro_mayor
( NUM_CUENTA, NOM_CUENTA, NATURALEZA, SALDO_DEBE, SALDO_HABER, FEC_LIBMAYOR) 
VALUES (PV_NUM_CUENTA, PV_NOM_CUENTA, PV_NATURALEZA, V_TOTDEBE, V_TOTHABER, NOW());

END IF;
COMMIT;
END;

CREATE PROCEDURE `PROC_BAL_GENERAL`(
 IN PV_NOMBRE_EMPRESA VARCHAR(255)
,IN PV_OPCION VARCHAR(1)
)
BEGIN
DECLARE DEBE INT;
DECLARE HABER INT;
DECLARE V_NUMCUENTA VARCHAR(255);
DECLARE V_NOMCUENTA VARCHAR(255);
DECLARE CODIGO INT;
DECLARE TOTAL INT;
DECLARE N INT;
DECLARE I INT;

IF PV_OPCION = 1 THEN
/*Trea saldo debe y haber de activo*/
SELECT COUNT(*) FROM  TBL_LIBRO_MAYOR WHERE COD_CLASIFICACION = '1' INTO N;
SET I=0;

WHILE I<N do 
  SELECT COD_LIBMAYOR,NUM_CUENTA,NOM_CUENTA,SALDO_DEBE,SALDO_HABER FROM TBL_LIBRO_MAYOR WHERE COD_CLASIFICACION = '1' LIMIT I,1 INTO CODIGO,V_NUMCUENTA,V_NOMCUENTA,DEBE,HABER;

    IF DEBE > HABER THEN
      SET TOTAL:=DEBE-HABER;
      SELECT "SALDO DEUDOR";
     ELSE  
      SET TOTAL:= DEBE - HABER;   
      SET TOTAL:= TOTAL * -1;
      SELECT "SALDO ACREEDOR";
    END IF;
 SET I = I + 1;
 INSERT INTO systemhtours.tbl_balance_general
(COD_LIBMAYOR, COD_CUENTA, EMPRESA, FECHA, NUM_CUENTA, NOM_CUENTA, TOT_ACTIVO, TOT_PASIVO, TOT_PATRIMONIO, SUM_PASCAP) 
VALUES (CODIGO, COD_CUENTA, PV_NOMBRE_EMPRESA, NOW(), V_NUMCUENTA, V_NOMCUENTA, TOTAL, 0, 0, 0);
END WHILE;
ELSEIF PV_OPCION = 2 THEN
SELECT COUNT(*) FROM TBL_LIBRO_MAYOR WHERE NATURALEZA = 'Pasivo' INTO N;
SET I=0;

WHILE I<N do 
SELECT COD_LIBMAYOR,NUM_CUENTA,NOM_CUENTA,SALDO_DEBE,SALDO_HABER  FROM TBL_LIBRO_MAYOR WHERE NATURALEZA = 'Pasivo' LIMIT I,1 INTO CODIGO,V_NUMCUENTA,V_NOMCUENTA,DEBE,HABER;

    IF DEBE > HABER THEN
      SET TOTAL:=DEBE-HABER;
      SELECT "SALDO DEUDOR";
    ELSE  
      SET TOTAL:= DEBE - HABER;   
      SET TOTAL:= TOTAL * -1;
      SELECT "SALDO ACREEDOR";
    END IF;
  SET I = I + 1;
  INSERT INTO tbl_balance_general
  (COD_LIBMAYOR, COD_CUENTA, EMPRESA, FECHA, NUM_CUENTA, NOM_CUENTA, TOT_ACTIVO, TOT_PASIVO, TOT_PATRIMONIO, SUM_PASCAP) 
   VALUES (CODIGO, COD_CUENTA, PV_NOMBRE_EMPRESA, NOW(), V_NUMCUENTA, V_NOMCUENTA, 0, TOTAL, 0, TOTAL);
END WHILE;
ELSEIF PV_OPCION = 3 THEN

SELECT COUNT(*) FROM TBL_LIBRO_MAYOR WHERE NATURALEZA = 'Patrimonio' INTO N;
SET I=0;

WHILE I<N do 
SELECT COD_LIBMAYOR,NUM_CUENTA,NOM_CUENTA,SALDO_DEBE,SALDO_HABER FROM TBL_LIBRO_MAYOR WHERE NATURALEZA = 'Patrimonio' LIMIT I,1 INTO CODIGO,V_NUMCUENTA,V_NOMCUENTA,DEBE,HABER;

  IF DEBE > HABER THEN
    SET TOTAL:=DEBE-HABER;
    SELECT "SALDO DEUDOR";
  ELSE  
    SET TOTAL:= DEBE - HABER;   
    SET TOTAL:= TOTAL *-1;
    SELECT "SALDO ACREEDOR";
  END IF;
  
  INSERT INTO tbl_balance_general
  (COD_LIBMAYOR, COD_CUENTA, EMPRESA, FECHA, NUM_CUENTA, NOM_CUENTA, TOT_ACTIVO, TOT_PASIVO, TOT_PATRIMONIO, SUM_PASCAP) 
    VALUES (CODIGO,COD_CUENTA, PV_NOMBRE_EMPRESA, NOW(),V_NUMCUENTA,V_NOMCUENTA, 0, 0, TOTAL, TOTAL);
 END WHILE;
END IF;
COMMIT;
END;

CREATE PROCEDURE PROC_ESTADOS_RESULTADOS(
    PV_OPCION VARCHAR(1)
)BEGIN
  DECLARE CODIGO, SALDO_DEBE,SALDO_HABER INT;
  DECLARE V_NUM_CUENTA,V_NOM_CUENTA VARCHAR(255);
  IF PV_OPCION = 1 THEN
  SELECT * FROM TBL_ESTADOS_RESULTADOS ;
  ELSEIF PV_OPCION = 2 THEN
  SELECT COD_LIBMAYOR,NUM_CUENTA,NOM_CUENTA,SALDO_DEBE,SALDO_HABER FROM TBL_LIBRO_MAYOR WHERE NATURALEZA = 'RESULTADOS' INTO CODIGO,V_NUM_CUENTA,V_NOM_CUENTA,SALDO_DEBE,SALDO_HABER;
  END IF;
COMMIT;
END;





CREATE PROCEDURE PROC_CATALAGO_CUENTAS(
  IN PV_OPCION VARCHAR(1)
)
BEGIN
IF PV_OPCION = 1 THEN
SELECT NUM_CUENTA,NOM_CUENTA FROM tbl_crear_cuentas WHERE NATURALEZA = 'Activo' order by NUM_CUENTA Asc;
ELSEIF PV_OPCION = 2 THEN
SELECT NUM_CUENTA,NOM_CUENTA FROM tbl_crear_cuentas WHERE NATURALEZA = 'Pasivo' order by NUM_CUENTA Asc;
ELSEIF PV_OPCION = 3 THEN
SELECT NUM_CUENTA,NOM_CUENTA FROM tbl_crear_cuentas WHERE NATURALEZA = 'Patrimonio' order by NUM_CUENTA Asc;
ELSEIF PV_OPCION = 4 THEN
SELECT NUM_CUENTA,NOM_CUENTA FROM tbl_crear_cuentas WHERE NATURALEZA = 'Resultados' order by NUM_CUENTA Asc;
END if;
COMMIT;
END;


CREATE PROCEDURE CAT_SUBCUENTAS(
)
begin 
SELECT NUM_CUENTA,NOM_CUENTA FROM tbl_subcuentas WHERE NATURALEZA = 'Activo' order by NUM_CUENTA Asc;
COMMIT;
END;

