call PRC_CLASIFICACIONES('activo', 1, '');
call INS_CUENTAS('activo', 'bancos', 1,1);
CALL PRC_LIBDIARIO(1,'bancos', '', 2000, 0,2, 1);
CALL PRC_PERIODOS(1, 'PERIODO-ENE-2022-001', '2022-01-01', '2022-02-01', 'ACTIVO', 1, 1);
CALL PROC_MS_USR_INSERTAR('USUARIO1', 'HERNESTO VALLADARES', 1, '2022-02-02', 1, 1, 'HEVA@gmail.com', 'Cual es tu color favorito?','verde' , 'secreta1');
CALL PRC_OBJETOS('HOME', 'PANTALLA PRINCIPAL', 'PANTALLA', 1, '');
CALL PRC_MS_ROLES( 'ADMINISTRADOR', 'USUARIO CON TODOS LOS PRIVILEGIOS', 1, '');
CALL PRC_LIBROS_MAYORES(1, 'BANCOS', 0, 0, 1, 1);

DROP PROCEDURE IF EXISTS PRC_BITACORA;
CREATE PROCEDURE PRC_BITACORA(
  /*
 * NOMBRE : INSERTAR Y SELECCIONAR LOS DATOS DE LA BITACORA
 * DESCRIPCIÓN : PROCEDIMIENTOS MODIFICAR TBL_MS_USR CONTRASEÑA
 * AUTOR: 
 * VERSION : 1.0  
 * */
   IN PV_USR  VARCHAR(255)
 	,IN PV_ACCION VARCHAR(100)
  ,IN PV_DESACCION VARCHAR(100)
 	,IN PV_OBJETO VARCHAR(255)
  ,IN PV_OPCION VARCHAR(1)
 	
)
BEGIN
DECLARE V_CODUSR,V_CODOBJ BIGINT;
	START TRANSACTION;
  IF PV_OPCION = 1 THEN 
 SELECT COD_USR FROM tbl_ms_usr WHERE USR = PV_USR INTO V_CODUSR;
 SELECT COD_OBJETO FROM tbl_objetos WHERE OBJETO = PV_OBJETO INTO V_CODOBJ;
INSERT INTO tbl_ms_bitacoras
(FEC_REGISTRO, USR_REGISTRA, COD_USR, ACC_SISTEMA, DES_BITACORA, COD_OBJETO) 
VALUES (NOW(), PV_USR, V_CODUSR, PV_ACCION, PV_DESACCION, V_CODOBJ);
ELSEIF PV_OPCION = 2 THEN
SELECT COD_BITACORA,FEC_REGISTRO,USR_REGISTRA,ACC_SISTEMA,DES_BITACORA,(SELECT OBJETO FROM TBL_OBJETOS WHERE COD_OBJETO = COD_OBJETO) AS OBJETO FROM tbl_ms_bitacoras;
ELSEIF PV_OPCION - 3 THEN
SELECT COD_BITACORA,FEC_REGISTRO,USR_REGISTRA,ACC_SISTEMA,DES_BITACORA FROM tbl_ms_bitacoras WHERE USR_REGISTRA = PV_USR ;
END IF;
COMMIT;
END;