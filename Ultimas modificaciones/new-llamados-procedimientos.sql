/*
Datos necesarios para el funcionamiento del sistema Laravel
*/

/*Rol del Sistema*/
call PRC_MS_INSERT_ROLES('Administrador', 'Control Absoluto del sistema');
call PRC_MS_INSERT_ROLES('DEFAULT', 'Rol por defecto con el que se crea un usuario');

-- NO UTILIZAR EN PRODUCCION el ROL DEVS, Colocarse este Rol para poder acceder al sistema o el rol administrador
call PRC_MS_INSERT_ROLES('DEVS', 'USUARIO CODIFICADOR'); 
/*Ingresar un Objeto*/
CALL PRC_OBJETOS('HOME', 'PANTALLA PRINCIPAL', 'PANTALLA', 1, '');
/*Ingresar un Usuario Con control absoluto*/
CALL PROC_MS_USR_INSERTAR('root','TecnoBot ', 1, '2022-02-02', 1, 1, 'tecnobot@gmail.com', 'Cual es tu color favorito?','verde' , ' 0a1b7c9440e4afe5e31ea6a190490bd3');
/*
 contrasena de este usuario :   vSupnqtYUW21   */
 
 /*Parametros del sistema */
 
Call PRC_MS_PARAMETROS('ADMIN_INTENTOS_INVALIDOS', '3', 1, now(), 1, '');
Call PRC_MS_PARAMETROS('ADMIN_CANT_PREG', '3', 1, now(), 1, '');
Call PRC_MS_PARAMETROS('ADMIN_PREGUNTAS', '2', 1, now(), 1, ''); 
Call PRC_MS_PARAMETROS('IMP_UTILIDAD', '0.15', 1, now(), 1, '');
Call PRC_MS_PARAMETROS('NOM_EMPRESA', 'HTOURS', 1, now(), 1, '');
/*
----------------------------------------------------------------
*/

/*
* Fin de datos necesarios para funcionamiento sistema Laravel
*/