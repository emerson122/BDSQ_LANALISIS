/*
Datos necesarios para el funcionamiento del sistema Laravel
*/
USE systemhtours;
/*Rol del Sistema*/
call PRC_MS_INSERT_ROLES('Administrador', 'Control Absoluto del sistema');
call PRC_MS_INSERT_ROLES('DEFAULT', 'Rol por defecto con el que se crea un usuario');

-- NO UTILIZAR EN PRODUCCION el ROL DEVS, Colocarse este Rol para poder acceder al sistema o el rol administrador
call PRC_MS_INSERT_ROLES('MANTENIMIENTO', 'USUARIO CODIFICADOR');

/*Ingresar un Objeto*/
CALL PRC_OBJETOS('HOME', 'PANTALLA PRINCIPAL', 'PANTALLA', 1, '');
CALL PRC_OBJETOS('LOGIN', 'PANTALLA DE INICIO DE SESION', 'PANTALLA', 1, '');
CALL PRC_OBJETOS('REGISTRO', 'PANTALLA DE REGISTRO DE USUARIO EXTERNA', 'PANTALLA', 1, '');
CALL PRC_OBJETOS('CUENTAS', 'PANTALLA DE REGISTRO DE CUENTAS', 'PANTALLA', 1, '');
CALL PRC_OBJETOS('SUBCUENTAS', 'PANTALLA DE REGISTRO DE SUBCUENTAS', 'PANTALLA', 1, '');


/*Ingresar aqui sus pantallaaaass*/

CALL PRC_OBJETOS('LIBRODIARIO', 'PANTALLA DE LOS LIBROS DIARIOS', 'PANTALLA', 1, '');
CALL PRC_OBJETOS('PERIODO', 'PANTALLA DE GESTION DE PERIODO', 'PANTALLA', 1, '');
CALL PRC_OBJETOS('LIBROMAYOR', 'PANTALLA DE LOS LIBROS MAYORES', 'PANTALLA', 1, '');
CALL PRC_OBJETOS('BALANCE', 'PANTALLA DE LOS LIBROS MAYORES', 'PANTALLA', 1, '');
CALL PRC_OBJETOS('RESULTADOS', 'PANTALLA DE LOS LIBROS MAYORES', 'PANTALLA', 1, '');
CALL PRC_OBJETOS('CLASIFICACION', 'PANTALLA DE LAS CLASIFICACIONES', 'PANTALLA', 1, '');
CALL PRC_OBJETOS('GRUPOS', 'PANTALLA DE REGISTRO DE GRUPOS', 'PANTALLA', 1, '');
CALL PRC_OBJETOS('PERSONAS', 'PANTALLA DE REGISTRO DE PERSONAS', 'PANTALLA', 1, '');
CALL PRC_OBJETOS('OBJETOS', 'PANTALLA DE LOS OBJETOS', 'PANTALLA', 1, '');

/* SEGURIDAD */
CALL PRC_OBJETOS('USUARIOS', 'PANTALLA DE USUARIOS', 'PANTALLA', 1, '');
CALL PRC_OBJETOS('ROLES', 'PANTALLA DE ROLES', 'PANTALLA', 1, '');
CALL PRC_OBJETOS('PERMISOS', 'PANTALLA DE PERMISOS', 'PANTALLA', 1, '');
CALL PRC_OBJETOS('BITACORAS', 'PANTALLA DE BITACORAS', 'PANTALLA', 1, '');
CALL PRC_OBJETOS('PARAMETROS', 'PANTALLA DE PARAMETROS', 'PANTALLA', 1, '');
CALL PRC_OBJETOS('PREGUNTAS', 'PANTALLA DE PREGUNTAS', 'PANTALLA', 1, '');
CALL PRC_OBJETOS('AJUSTES', 'PANTALLA DE AJUSTES', 'PANTALLA', 1, '');



/*Ingresar un Usuario Con control absoluto*/
CALL PROC_MS_USR_INSERTAR('ROOT','TecnoBot ', 1, '2022-02-02', 1, 1, 'tecnobot@gmail.com', 'Cual es tu color favorito?','verde' , ' 0a1b7c9440e4afe5e31ea6a190490bd3');
CALL PROC_MS_USR_INSERTAR('MANT','TecnoBot Mantenimiento', 3, '2022-02-02', 1, 1, 'tecnobot@gmail.com', 'Cual es el mantenimiento Favorito?','programacion' , '137772b7ecb263dc707ab445c56c0181');
CALL PROC_MS_USR_INSERTAR('Usuario_Auto_Registrado','Usuario Autoregisro Externo', 3, '2022-02-02', 1, 1, 'tecnobot@gmail.com', 'Cual es el registro Favorito?','registro' , '137772b7ecb263dc707ab445c56c0181');
CALL PROC_MS_USR_INSERTAR('TECNOBOT','Pruebas', 1, '2022-02-02', 1, 1, 'tecnobot@gmail.com', 'Cual es el registro Favorito?','registro' , '3e20d73773eab6c39d50b2c074c61a3b');
call PRC_PERSONAS('TECNOBOT', 'M', 26, 'J', '0801-2000-08100', 'S', 33410754, 'C', '1', 0);
call UPD_ESTADOUSR('TECNOBOT', '1');



/*
 contrasena de  usuario  ROOT:   vSupnqtYUW21   */
 -- VTnodJbt0Sxqd5OhWYGTZwcw5Ma
 
 /*Parametros del sistema */
 
Call PRC_MS_PARAMETROS('ADMIN_INTENTOS_INVALIDOS', '3', "ROOT", now(), 1, '');
Call PRC_MS_PARAMETROS('ADMIN_CANT_PREG', '2', "ROOT", now(), 1, '');
Call PRC_MS_PARAMETROS('ADMIN_PREGUNTAS', '2', "ROOT", now(), 1, ''); 
Call PRC_MS_PARAMETROS('IMP_UTILIDAD', '0.15', "ROOT", now(), 1, '');
Call PRC_MS_PARAMETROS('NOM_EMPRESA', 'HTOURS', "ROOT", now(), 1, '');
/*
----------------------------------------------------------------
*/


/*
PERMISOS ROL DE ADMINISTRADOR
*/

call PRC_INSERT_PERMISOS(1, 1, '1', '1', '1', '1'); -- TODOS LOS PERMISOS PARA ROL ADMINISTRADOR EN PANTALLA DE HOME
call PRC_INSERT_PERMISOS(1, 2, '1', '1', '1', '1'); -- TODOS LOS PERMISOS PARA ROL ADMINISTRADOR EN PANTALLA DE LOGIN
call PRC_INSERT_PERMISOS(1, 3, '1', '1', '1', '1'); -- TODOS LOS PERMISOS PARA ROL ADMINISTRADOR EN PANTALLA DE REGISTRO
call PRC_INSERT_PERMISOS(1, 4, '1', '1', '1', '1'); -- TODOS LOS PERMISOS PARA ROL ADMINISTRADOR EN PANTALLA DE CUENTAS
call PRC_INSERT_PERMISOS(1, 5, '1', '1', '1', '1'); -- TODOS LOS PERMISOS PARA ROL ADMINISTRADOR EN PANTALLA DE SUBCUENTAS
call PRC_INSERT_PERMISOS(1, 6, '1', '1', '1', '1'); -- TODOS LOS PERMISOS PARA ROL ADMINISTRADOR EN PANTALLA DE LIBRODIARIO
call PRC_INSERT_PERMISOS(1, 7, '1', '1', '1', '1'); -- TODOS LOS PERMISOS PARA ROL ADMINISTRADOR EN PANTALLA DE LIBROMAYOR
call PRC_INSERT_PERMISOS(1, 8, '1', '1', '1', '1'); -- TODOS LOS PERMISOS PARA ROL ADMINISTRADOR EN PANTALLA DE BALANCE
call PRC_INSERT_PERMISOS(1, 9, '1', '1', '1', '1'); -- TODOS LOS PERMISOS PARA ROL ADMINISTRADOR EN PANTALLA DE RESULTADOS
call PRC_INSERT_PERMISOS(1, 10, '1', '1', '1', '1'); -- TODOS LOS PERMISOS PARA ROL ADMINISTRADOR EN PANTALLA DE CLASIFICACION
call PRC_INSERT_PERMISOS(1, 11, '1', '1', '1', '1'); -- TODOS LOS PERMISOS PARA ROL ADMINISTRADOR EN PANTALLA DE GRUPOS
call PRC_INSERT_PERMISOS(1, 12, '1', '1', '1', '1'); -- TODOS LOS PERMISOS PARA ROL ADMINISTRADOR EN PANTALLA DE PERSONAS
call PRC_INSERT_PERMISOS(1, 13, '1', '1', '1', '1'); -- TODOS LOS PERMISOS PARA ROL ADMINISTRADOR EN PANTALLA DE OBJETOS
call PRC_INSERT_PERMISOS(1, 14, '1', '1', '1', '1'); -- TODOS LOS PERMISOS PARA ROL ADMINISTRADOR EN PANTALLA DE USUARIOS
call PRC_INSERT_PERMISOS(1, 15, '1', '1', '1', '1'); -- TODOS LOS PERMISOS PARA ROL ADMINISTRADOR EN PANTALLA DE ROLES
call PRC_INSERT_PERMISOS(1, 16, '1', '1', '1', '1'); -- TODOS LOS PERMISOS PARA ROL ADMINISTRADOR EN PANTALLA DE PERMISOS
call PRC_INSERT_PERMISOS(1, 17, '1', '1', '1', '1'); -- TODOS LOS PERMISOS PARA ROL ADMINISTRADOR EN PANTALLA DE BITACORAS
call PRC_INSERT_PERMISOS(1, 18, '1', '1', '1', '1'); -- TODOS LOS PERMISOS PARA ROL ADMINISTRADOR EN PANTALLA DE PARAMETROS
call PRC_INSERT_PERMISOS(1, 19, '1', '1', '1', '1'); -- TODOS LOS PERMISOS PARA ROL ADMINISTRADOR EN PANTALLA DE PREGUNTAS
call PRC_INSERT_PERMISOS(1, 20, '1', '1', '1', '1'); -- TODOS LOS PERMISOS PARA ROL ADMINISTRADOR EN PANTALLA DE AJUSTES


/*
* Fin de datos necesarios para funcionamiento sistema Laravel
*/




/*
* Logica de Contabilidad
*/


/*Clasificaciones de las cuentas*/
call PRC_CLASIFICACIONES('Activo', '1', 0);
call PRC_CLASIFICACIONES('Pasivo', '1', 0);
call PRC_CLASIFICACIONES('Patrimonio', '1', 0);

/*
Grupos de Cuentas
*/
call PRC_GRUPOS('Activo', '1', 'Activo Corriente', '1', 1);
call PRC_GRUPOS('Activo', '2', 'Activo No Corriente', '1', 1);
call PRC_GRUPOS('Pasivo', '1', 'Pasivo Corriente', '1', 1);
call PRC_GRUPOS('Pasivo', '2', 'Pasivo No Corriente', '1', 1);
call PRC_GRUPOS('Patrimonio', '1', 'Patrimonio', '1', 1);


/*
Cuentas

Activo Corriente
*/
call INS_CUENTAS('Activo', 'Bancos', '1', '1');
call INS_CUENTAS('Activo', 'Efectivo', '5', '1');
call INS_CUENTAS('Activo', 'Caja Chica', '6', '1');

/*
Activo NO Corriente
*/
call INS_CUENTAS('Activo', 'Terrenos', '1', '2');
call INS_CUENTAS('Activo', 'Edificios', '2', '2');
call INS_CUENTAS('Activo', 'Mobiliario', '3', '2');


/*
Pasivo Corrientes
*/

call INS_CUENTAS('PASIVO', 'proveedores', '1', '3');

/*
Pasivo No corrientes
*/
call INS_CUENTAS('PASIVO', 'acreedores', '2', '4');

/*
Patrimonio
*/
call INS_CUENTAS('Patrimonio', 'CAPITAL', '1', '5');


/*
Descuento
*/
-- call INS_CUENTAS('DESCUENTO_I', 'DESCUENTOS VIAJES', '1', '1');
-- call INS_CUENTAS('DESCUENTO_G', 'DESCUENTOS COMPRAS', '2', '1');
-- call INS_CUENTAS('GASTOS', 'GASTOS  ADMINISTRATIVOS','3', '1');
-- call INS_CUENTAS('SUELDOS', 'SUELDOS  EMPLEADOS','4', '1');
-- call INS_CUENTAS('GASTOSV', 'GASTOS EN  VENTAS','5', '1');

/*

iNSERTAR SUBCUENTA
*/

-- -- CALL PRC_SUBCUENTAS(1, '1', 'Bancos', 1,'cheques' );



-- PRUEBAS FUNCIONAL SOLO TODAS LAS DE INSERT ACTIVOS CORRIENTES Y NO CORRIENTES
-- LA CLASIFICACION LA TOMA JUNTO CON EL NUMERO DE LA SUBCUENTA, REVISION.
-- /*  3 SUBCUENTAS DE ACTIVO, GRUPO ACTIVOS CORRIENTES */ 
-- CALL PRC_SUBCUENTAS(1, 'Cheques', 'Bancos','1.1.1','');
-- CALL PRC_SUBCUENTAS(1, 'Dinero', 'Efectivo','1.1.5','');
-- CALL PRC_SUBCUENTAS(1, 'Efectivo', 'Caja Chica','1.1.6','');


-- /*  3 SUBCUENTAS DE ACTIVO, GRUPO ACTIVOS NOOO CORRIENTES */ 
-- CALL PRC_SUBCUENTAS(1, 'Terreno', 'Terrenos','1.2.1','');
-- CALL PRC_SUBCUENTAS(1, 'entrada', 'Edificios','1.2.2','');
-- CALL PRC_SUBCUENTAS(1, 'equipo', 'mobiliario','1.2.3','');


-- /*  1 SUBCUENTAS DE PASIVO, GRUPO PASIVO CORRIENTE */ 
-- /*en orden la columna 1 es el correlativo, la 2 es el nombre de la subcuenta,
-- la 3 es el nombre de la cuenta ya creada en su modulo, la 4 es el numero e esta cuenta*/
-- CALL PRC_SUBCUENTAS('2',1, 'Empresa x', 'proveedores','2.1.1');

-- /*  1 SUBCUENTAS DE PASIVO, GRUPO PASIVO NOOOOO CORRIENTE */ 
-- CALL PRC_SUBCUENTAS(1, 'Servicios', 'Acreedores','2.2.2-1','');

-- /*  1 SUBCUENTAS DE PATRIMONIO */ 
-- CALL PRC_SUBCUENTAS(1, 'Capital social', 'CAPITAL','3.1.1-1','');



