call PRC_CLASIFICACIONES('activo', 1, '');
call INS_CUENTAS('activo', 'bancos', 1,1);
CALL PRC_LIBDIARIO(1,'bancos', '', 2000, 0,2, 1);
CALL PRC_PERIODOS(1, 'PERIODO-ENE-2022-001', '2022-01-01', '2022-02-01', 'ACTIVO', 1, 1);
CALL PROC_MS_USR_INSERTAR('USUARIO1', 'HERNESTO VALLADARES', 1, '2022-02-02', 1, 1, 'HEVA@gmail.com', 'Cual es tu color favorito?','verde' , 'secreta1');
CALL PRC_OBJETOS('HOME', 'PANTALLA PRINCIPAL', 'PANTALLA', 1, '');
CALL PRC_MS_ROLES( 'ADMINISTRADOR', 'USUARIO CON TODOS LOS PRIVILEGIOS', 1, '');
CALL PRC_LIBROS_MAYORES(1, 'BANCOS', 0, 0, 1, 1);