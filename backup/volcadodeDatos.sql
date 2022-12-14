/* Modulo de seguridad
Modulo de cuentas
Modulo contable
Modulo de mantenimiento*/
/*   Insertar datos  */
use systemhtours;
/* -------------------------------------------------------------------- MODULO DE SEGURIDAD ------------------------------------------ */
INSERT INTO tbl_ms_roles
(ROL, DES_ROL) 
VALUES ('Administrador', 'Usuario con todo los privilegios');


INSERT INTO tbl_ms_usr
(USR, NOM_USR, EST_USR, COD_ROL, FEC_ULT_CONN, PREG_RES, PRIMER_ACC, CORREO) 
VALUES ('USUARIO1', 'Earl Valdez', 'NUEVO', 1, now(), 1, 1, 'evaldez@gmail.com');



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
VALUES ( 1, '1', '1', '1', now(), 'USUARIO1', now(), 'USUARIO1');

INSERT INTO tbl_ms_parametros
(PARAMETRO, VALOR, COD_USR, FEC_CREACION, FEC_MODIFICACION) 
VALUES ('impuesto', '15', 1, '2022-11-06', '2022-11-07');


INSERT INTO  tbl_ms_bitacoras
(FEC_REGISTRO, USR_REGISTRA, COD_USR, ACC_SISTEMA, DES_BITACORA, COD_OBJETO) 
VALUES (now(), 'USUARIO1', 1, 'DELETE', 'BORRADO_INDEBIDO', 1);


INSERT INTO tbl_ms_hist_contrasenas
(COD_USR, CONTRASENA) 
VALUES (1, 'a20f0e44c7a2b7d4d2d3cc050a170a85');


/* -------------------------------------------------------------------- MODULO DE CUENTAS ------------------------------------------ */
INSERT INTO tbl_clasificaciones
(NATURALEZA) 
VALUES ('Activo');

INSERT INTO tbl_periodos
(COD_USUARIO, FEC_PERIODO, NOM_PERIODO, FEC_INI, FEC_FIN, ESTADO) 
VALUES (1, now(), 'Periodo-2020-ene-1-001', '2022-01-01', '2022-12-31', 'Activo');


INSERT INTO tbl_cuentas
(COD_CLASIFICACION, NUM_CUENTA, NOM_CUENTA) 
VALUES (1, '1.1', 'Caja');

INSERT INTO tbl_estados_cuentas
(COD_CUENTA, EST_CUENTA) 
VALUES (1, 'INGRESADA');


INSERT INTO tbl_subcuentas
(COD_CLASIFICACION, NUM_SUBCUENTA, NOM_SUBCUENTA, COD_CUENTA) 
VALUES (1, '1.1.1', 'Efectivo', 1);

INSERT INTO tbl_estados_subcuentas
(COD_SUBCUENTA, EST_SUBCUENTAS) 
VALUES (1, 'INGRESADA');




/* -------------------------------------------------------------------- MODULO CONTABLE ------------------------------------------ */
INSERT INTO tbl_libros_diarios
(COD_CUENTA, COD_SUBCUENTA, COD_ESTADO, NUM_SUBCUENTA, NOM_SUBCUENTA, SAL_DEBE, SAL_HABER, FEC_LIBDIARIO) 
VALUES (1, 1, 1, '1.1.1', 'Efectivo', 0, 250000, now());


INSERT INTO tbl_comprobantes
(COD_LIBDIARIO, FEC_COMPROBANTE, COMPROBANTE, DES_COMPROBANTE) 
VALUES (1, now(), 'ubicaciion', 'comprobante de pago');
-- SE LE HACE UN UPDATE A ESTA SUBCUENTA QUE SE INGRESO 

INSERT INTO tbl_libros_mayores
(COD_CUENTA, COD_CLASIFICACION, COD_PERIODO, COD_ESTCUENTA, NUM_CUENTA, NOM_CUENTA, SAL_DEBE, SAL_HABER, FEC_LIBMAYOR) 
VALUES (1, 1, 1, 1, '1.1', 'Caja', 0, 	5000, now());

INSERT INTO tbl_balances_generales
(COD_LIBMAYOR, EMPRESA, FEC_BALANCE, TOT_ACTIVO, TOT_PASIVO, TOT_PATRIMONIO) 
VALUES (1, 'HTOURS', now(), 0, 255000, 0);

INSERT INTO tbl_saldos_balances
(COD_BALANCE, FEC_SALDOS, TOT_ACTIVO, TOT_PASPAT) 
VALUES (1, now(), 0, 255000);



INSERT INTO tbl_estados_resultados
(COD_LIBMAYOR, COD_PERIODO, COD_PARAMETRO, EMPRESA, FEC_ESTADO, VEN_NETAS, COS_VENTAS, UTI_BRUTA, TOT_GASTOS, UTI_ANTIMP, IMP_UTILIDAD, UTI_NETA) 
VALUES (1, 1, 1, 'HTOURS', now(), 50000, 10000, 40000, 5000, 10000, 	5250, 29750);

