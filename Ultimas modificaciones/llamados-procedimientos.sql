/* ------------------------------------------------------------------ */
/* iNSERTAR PERSONAS*/
call PRC_PERSONAS('elias vasquez', 'm', 21, 'j', '080129912132', 's', '1', 3341043, 'c', 1, 1);
call PRC_PERSONAS('Victor mendez', 'm', 21, 'j', '080129912132', 's', '1', 3341043, 'c', 1, 1);

/* Actualizar personas */
call PRC_PERSONAS('Mauro Mendoza', 'm', 21, 'j', '080129912132', 's', '1', 3341043, 'c', 2, 1);
/* Eliminar personas */
call PRC_PERSONAS('', '', '', '', '', '', '', '', '', 3, 1);
/* Seleccionar ALL Personas */
call PRC_PERSONAS('', '', '', '', '', '', '', '', '', 4, 1);

/* Seleccionar una Persona */
call PRC_PERSONAS('', '', '', '', '', '', '', '', '', 5, 1);
/* --------------------------------------------------------------------------- */
/* insertar Clasificacion */
call PRC_CLASIFICACIONES('activo', 1, '');
call PRC_CLASIFICACIONES('pasivo', 1, '');
call PRC_CLASIFICACIONES('patrimonio', 1, '');
call PRC_CLASIFICACIONES('DESCUENTO_I', 1, '');
call PRC_CLASIFICACIONES('DESCUENTO_G', 1, '');
call PRC_CLASIFICACIONES('GASTOS', 1, '');
call PRC_CLASIFICACIONES('VENTAS', 1, '');
call PRC_CLASIFICACIONES('SUELDOS', 1, '');
call PRC_CLASIFICACIONES('GASTOSV', 1, ''); -- GASTO PARA PRODUCIR UNA VENTA

/* actualizar Clasificacion */
call PRC_CLASIFICACIONES('Activo', 2, 1);

/* Eliminar Clasificaciones */
call PRC_CLASIFICACIONES('', 3, 2);
/*Seleccionar todas las clasificaciones*/
call PRC_CLASIFICACIONES('', 4, '');

/* Seleccionar una especifica */
call PRC_CLASIFICACIONES('', 5, 1);

/* ------------------------------------------------------------------ */

/*Insertar cuenta generando Catalago de cuenta*/
call INS_CUENTAS('activo', 'bancos', 1);
call INS_CUENTAS('PASIVO', 'PROVEEDORES', 2);
CALL INS_CUENTAS('VENTAS','Ventas de viajes',1)

/* Actualizar Cuenta */
call PRC_CUENTAS(1, 'Bancos', '1.1', 2, 1);

/*Eliminar Cuenta  */
call PRC_CUENTAS('', '', '', 3, 2);
/* seleccionar cuentas */
call PRC_CUENTAS('', '', '', 4, '');
/*Seleccionar una Cuenta */
call PRC_CUENTAS('', '', '', 5, 1);
/* ------------------------------------------------------------------ */

/* insertar subcuenta */
CALL PRC_SUBCUENTAS(1, '1', 'EFECTIVO', 'BANCOS', 1, 1);

/* Actualizar Subcuenta */
CALL PRC_SUBCUENTAS(1, '1.1.1', 'Efectivo', 'BANCOS', 2, 1);


/*Eliminar Subcuennta*/
CALL PRC_SUBCUENTAS('', '', '', '', 3, 1);
/* Seleccionar Subcuenta */
CALL PRC_SUBCUENTAS('', '', '', '', 4, '');

/* Selecciona una subcuenta especifica */
CALL PRC_SUBCUENTAS('', '', '', '', 5, 2);

/* ------------------------------------------------------------------ */
/*Insertar roles*/
CALL PRC_MS_ROLES( 'ADMINISTRADOR', 'USUARIO CON TODOS LOS PRIVILEGIOS', 1, '');
CALL PRC_MS_ROLES( 'usuario', 'USUARIO ESTANDAR', 1, '');
/*Actualizar Rol */
CALL PRC_MS_ROLES( 'Contador', 'Usuario con permisos ', 2, 2);

/*Eliminar Rol */
CALL PRC_MS_ROLES( '', '', 3, 2);

/*Seleccionar Roles */
CALL PRC_MS_ROLES( '', '', 4, '');

/* Seleccion especifica */
CALL PRC_MS_ROLES( '', '', 5, 1);

/* ------------------------------------------------------------------ */

/*iNSERTAR OBJETO */
CALL PRC_OBJETOS('HOME', 'PANTALLA PRINCIPAL', 'PANTALLA', 1, '');

/*SELECCIONAR OBJETOS */
CALL PRC_OBJETOS('HOME', 'PANTALLA PRINCIPAL', 'PANTALLA', 4, '');
/* ------------------------------------------------------------------ */
/*INSERTAR Usuario CON CORREO PREGUNTAS Y RESPUESTAS*/
CALL PROC_MS_USR_INSERTAR('USUARIO1', 'HERNESTO VALLADARES', 1, '2022-02-02', 1, 1, 'HEVA@gmail.com', 'Cual es tu color favorito?','verde' , 'secreta1');
/*SELECCIONAR USUARIOS */
CALL PROC_MS_USR_SELECCIONAR();
/* ------------------------------------------------------------------ */

/* INSERTAR PERIODO */
CALL PRC_PERIODOS(1, 'PERIODO-ENE-2022-001', '2022-01-01', '2022-02-01', 'ACTIVO', 1, 1);

/*ACTUALIZAR PERIODO */
CALL PRC_PERIODOS(1, 'PERIODO-FEB-2022-001', '2022-02-01', '2022-03-01', 'ACTIVO', 2, 1);
/*ELIMINAR PERIODO */
CALL PRC_PERIODOS('', '', '', '', '', 3, 1);
/*SELECCIONAR PERIODO */
CALL PRC_PERIODOS('', '', '', '', '', 4, '');

/* ------------------------------------------------------------------ */
/* INSERTAR CUENTA CON SUBCUENTA EN LIBRO DIARIO */
CALL PRC_LIBDIARIO(1,'bancos', 'EFECTIVO', 2000, 0, 1, 1);


/* INSERTAR DATOS SOLO DE CUENTA SIN SUBCUENTA */
CALL PRC_LIBDIARIO(1,'bancos', '', 2000, 0, 2, 1);

CALL PRC_LIBDIARIO(1,'bancos', '', 2000, 0, 2, 1);


/* ------------------------------------------------------------------ */

/* INSERTAR EN LIBRO MAYOR CUENTAS DE LIBRO DIARIO */
CALL PRC_LIBROS_MAYORES(1, 'BANCOS', 0, 0, 1, 1);

/* INSERTAR EN LIBRO MAYOR CUENTAS QUE NO ESTAN EN LIBRO DIARIO*/
CALL PRC_LIBROS_MAYORES(1, 'BANCOS', 100, 0, 6, 1);

/* Actualizar libro MAYOR */
CALL PRC_LIBROS_MAYORES(1, 'BANCOS', 100, 0, 2, 1);

/* ELIMINAR LIBRO MAYOR */
CALL PRC_LIBROS_MAYORES('', '', '', '', 3, 1);
/* SELECCIONAR LIBRO MAYOR */
CALL PRC_LIBROS_MAYORES('', '', '', '', 4,'');
/* SELECCIONAR SOLO 1 */
CALL PRC_LIBROS_MAYORES('', '', '', '', 5,2);


/* ------------------------------------------------------------------ */
/* INSERTAR EN EL BALANCE GENERAL */
/* BALANCE GENERAL ACTIVOS */

CALL INS_BAL_GENERAL('HTOURS', 1,'ACTIVO' , 1);
/* BALANCE GENERAL PASIVOS */
CALL INS_BAL_GENERAL('HTOURS', 1,'PASIVO' , 2);
/* BALANCE GENERAL PATRIMONIOS */
CALL INS_BAL_GENERAL('HTOURS', 1,'PATRIMONIO', 3);

/* ESTADO DE RESULTADO */
CALL PRC_ms_patametros('IMP_UTILIDAD', '0.15', 1, 1, '');

CALL PRC_LIBDIARIO(1,'VENTAS VIAJES', '', 2000, 0, 2, 1);
CALL PRC_LIBDIARIO(1,'VENTAS VIAJES', '', 3000, 0, 2, 1);

/* INSERTAR EN LIBRO MAYOR CUENTAS DE LIBRO DIARIO */
CALL PRC_LIBROS_MAYORES(1, 'BANCOS', 0, 0, 1, 1);
CALL PRC_LIBROS_MAYORES(1, 'VENTAS VIAJES', 0, 0, 1, 1);


/* INSERTAR CUENTAS DE ESTADO DE RESULTADO*/

call INS_CUENTAS('DESCUENTO_I', 'DESCUENTOS VIAJES', 1);
call INS_CUENTAS('DESCUENTO_G', 'DESCUENTOS COMPRAS', 1);
call INS_CUENTAS('GASTOS', 'GASTOS  ADMINISTRATIVOS', 1);
call INS_CUENTAS('SUELDOS', 'SUELDOS  EMPLEADOS', 2);
call INS_CUENTAS('GASTOSV', 'GASTOS EN  VENTAS', 1);

/* INSERTAR EN LIBRO MAYOR CUENTAS QUE NO ESTAN EN LIBRO DIARIO*/
CALL PRC_LIBROS_MAYORES(1, 'DESCUENTOS VIAJES', 1000, 0, 6, 1);
CALL PRC_LIBROS_MAYORES(1, 'DESCUENTOS COMPRAS', 100, 0, 6, 1);
CALL PRC_LIBROS_MAYORES(1, 'GASTOS  ADMINISTRATIVOS',0,  500, 6, 1);
CALL PRC_LIBROS_MAYORES(1, 'SUELDOS  EMPLEADOS', 0, 600, 6, 1);
CALL PRC_LIBROS_MAYORES(1, 'GASTOS EN  VENTAS', 0, 50, 6, 1);


