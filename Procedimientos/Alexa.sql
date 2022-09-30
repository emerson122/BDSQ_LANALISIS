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



CREATE PROCEDURE PROC_CUENTAS(
   IN COD_CUENTA    BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT
  ,IN PB_COD_CLASIFICACION BIGINT NOT NULL
  ,IN NOMBRE_CUENTA VARCHAR(255)
  ,IN PV_NATURALEZA VARCHAR(255)
  ,IN PV_CUENTA VARCHAR(255)
  ,IN PV_OPERACION VARCHAR(1)
  ,IN PB_FILA BIGINT

  
  )BEGIN
  START TRANSACTION;
  IF PV_OPERACION = 1 THEN 
  INSERT INTO TBL_CUENTAS 
  (COD_CLASIFICACION, NOMBRE_CUENTA, NATURALEZA, CUENTA)
  VALUES (PB_COD_CLASIFICACION,NOMBRE_CUENTA,PV_NATURALEZA,PV_CUENTA );

  ELSE IF  PV_OPERACION = 2 THEN 
  UPDATE TBL_CUENTAS
  SET COD_CLASIFICACION = PB_COD_CLASIFICACION, NOM_CUENTA = NOM_CUENTA,NATURALEZA = PV_NATURALEZA,CUENTA = PV_CUENTA
  WHERE COD_CUENTA=PB_FILA;
  COMMIT;
  END;