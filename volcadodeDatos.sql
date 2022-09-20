/*   Insertar datos  */
INSERT INTO tbl_ms_roles
(ROL, DES_ROL) 
VALUES ('Administrador', 'Usuario con todos los privilegios');



INSERT INTO tbl_ms_usr
(USR, NOM_USR, EST_USR, COD_ROL, FEC_ULT_CONN, PREG_RES, PRIMER_ACC, CORREO) 
VALUES ('USUARIO1', 'Earl Valdez', 'NUEVO', 1, '2022-09-19', 1, 1, 'evaldez@gmail.com');



INSERT INTO tbl_ms_preg
(PREGUNTA) 
VALUES ('Cual es tu comida favorita?');


INSERT INTO tbl_ms_preg_usr
(COD_USR, RESPUESTA) 
VALUES (1, 'Pizza');


INSERT INTO tbl_objetos
(OBJETO, DES_OBJETO, TIP_OBJETO) 
VALUES ('Cuentas', 'Pantalla de gestion de cuentas', 'pantalla');

INSERT INTO tbl_permisos
(COD_ROL, COD_OBJETO, PER_INSERCION, PER_ELIMINACION, PER_ACTUALIZACION, PER_CONSULTAR) 
VALUES (1, 1, '0', '0', '0', '1');



INSERT INTO tbl_roles_objetos
( COD_OBJETO, PER_EDICION, PER_ELIMINAR, PER_ACTUALIZAR, FEC_CREACION, CREADO_POR, FEC_MODIFICACION, MOD_POR) 
VALUES ( 1, '1', '1', '1', '2022-09-09', 'USUARIO1', '2022-09-19', 'USUARIO1');

INSERT INTO tbl_ms_parametros
(PARAMETRO, VALOR, COD_USR, FEC_CREACION, FEC_MODIFICACION) 
VALUES ('Admin_Num_Registros', '2', 1, '2022-11-06', '2022-11-07');


INSERT INTO  tbl_ms_bitacoras
(FEC_REGISTRO, USR_REGISTRA, COD_USR, ACC_SISTEMA, DES_BITACORA, COD_OBJETO) 
VALUES ('2022-11-06', 'USUARIO1', 1, 'DELETE', 'BORRADO_INDEBIDO', 1);


INSERT INTO tbl_ms_hist_contrasegna
(COD_USR, CONTRASEGNA) 
VALUES (1, 'a20f0e44c7a2b7d4d2d3cc050a170a85');

-- modulo cuentas
INSERT INTO tbl_clasificaciones
(NATURALEZA) 
VALUES ('Activo');

INSERT INTO tbl_periodos
(COD_USUARIO, FEC_PERIODO, NOM_PERIODO, FEC_INI, FEC_FIN, ESTADO) 
VALUES (1, '2022-19-9', 'Periodo-2020-ene-1-001', '2022-01-01', '2022-12-31', 'Activo');


INSERT INTO tbl_cuentas
(COD_CLASIFICACION, NUM_CUENTA, NOM_CUENTA) 
VALUES (1, '1.1', 'Caja');

INSERT INTO systemhtours2.tbl_subcuentas
(COD_CLASIFICACION, NUM_SUBCUENTA, NOM_SUBCUENTA, COD_CUENTA) 
VALUES (1, '1.1.1', 'Efectivo', 1);


/*   Actualizar  datos  */


/* Seleccionar Datos */


/*   Eliminar datos  */
