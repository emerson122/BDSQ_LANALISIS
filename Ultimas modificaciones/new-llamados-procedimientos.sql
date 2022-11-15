/*
Datos necesarios para el funcionamiento del sistema Laravel
*/

/*Rol del Sistema*/
call PRC_MS_INSERT_ROLES('Administrador', 'Control Absoluto del sistema');
call PRC_MS_INSERT_ROLES('DEFAULT', 'Rol por defecto con el que se crea un usuario');

-- NO UTILIZAR EN PRODUCCION el ROL DEVS, Colocarse este Rol para poder acceder al sistema o el rol administrador
call PRC_MS_INSERT_ROLES('MANTENIMIENTO', 'USUARIO CODIFICADOR'); 
/*Ingresar un Objeto*/
CALL PRC_OBJETOS('HOME', 'PANTALLA PRINCIPAL', 'PANTALLA', 1, '');
CALL PRC_OBJETOS('LOGIN', 'PANTALLA DE INICIO DE SESION', 'PANTALLA', 1, '');
CALL PRC_OBJETOS('REGISTRO', 'PANTALLA DE REGISTRO DE USUARIO EXTERNA', 'PANTALLA', 1, '');
/*Ingresar un Usuario Con control absoluto*/
CALL PROC_MS_USR_INSERTAR('ROOT','TecnoBot ', 1, '2022-02-02', 1, 1, 'tecnobot@gmail.com', 'Cual es tu color favorito?','verde' , ' 0a1b7c9440e4afe5e31ea6a190490bd3');
CALL PROC_MS_USR_INSERTAR('MANT','TecnoBot Mantenimiento', 3, '2022-02-02', 1, 1, 'tecnobot@gmail.com', 'Cual es el mantenimiento Favorito?','programacion' , '137772b7ecb263dc707ab445c56c0181');
CALL PROC_MS_USR_INSERTAR('Usuario_Auto_Registrado','Usuario Autoregisro Externo', 3, '2022-02-02', 1, 1, 'tecnobot@gmail.com', 'Cual es el registro Favorito?','registro' , '137772b7ecb263dc707ab445c56c0181');
/*
 contrasena de  usuario  ROOT:   vSupnqtYUW21   */
 -- VTnodJbt0Sxqd5OhWYGTZwcw5Ma
 
 /*Parametros del sistema */
 
Call PRC_MS_PARAMETROS('ADMIN_INTENTOS_INVALIDOS', '3', 1, now(), 1, '');
Call PRC_MS_PARAMETROS('ADMIN_CANT_PREG', '3', 1, now(), 1, '');
Call PRC_MS_PARAMETROS('ADMIN_PREGUNTAS', '3', 1, now(), 1, ''); 
Call PRC_MS_PARAMETROS('IMP_UTILIDAD', '0.15', 1, now(), 1, '');
Call PRC_MS_PARAMETROS('NOM_EMPRESA', 'HTOURS', 1, now(), 1, '');
/*
----------------------------------------------------------------
*/

/*
* Fin de datos necesarios para funcionamiento sistema Laravel
*/