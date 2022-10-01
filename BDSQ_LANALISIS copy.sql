-- descomentar para crear la base de datos 
/*
CREATE DATABASE systemhtours; 
USE systemhtours;
*/


/* Antes de los cambios de jeyson */



/*MODULO DE SEGURIDAD */


-- ///////////////////////////////////////////////////////////
CREATE TABLE `TBL_MS_ROLES` (
  `COD_ROL`     BIGINT     NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'LLAVE PRIMARIA MS ROLES',
  `ROL`         VARCHAR(30)   NOT NULL DEFAULT ''                 COMMENT 'ROL USUARIO',
  `DES_ROL`     VARCHAR(50)   NOT NULL DEFAULT ''                 COMMENT 'DESCRIPCION ROL'
)
ENGINE=INNODB
CHARACTER SET UTF8
COLLATE UTF8_UNICODE_CI
COMMENT 'TABLA MS ROLES';




-- ///////////////////////////////////////////////////////////
CREATE TABLE `TBL_MS_USR` (
  `COD_USR`       BIGINT     NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'LLAVE PRIMARIA MS USUARIO',
  `USR`           VARCHAR(50)   NOT NULL DEFAULT '' COMMENT 'USUARIO',
  `NOM_USR`       VARCHAR(100)  NOT NULL DEFAULT '' COMMENT 'NOMBRE USUARIO',
  `EST_USR`       ENUM('BLOQUEADO', 'ACTIVO','INACTIVO','NUEVO')  NOT NULL DEFAULT 'ACTIVO' COMMENT 'ESTADO USUARIO',
  `COD_ROL`       BIGINT     NOT NULL            COMMENT 'CODIGO ROL',
  `FEC_ULT_CONN`  DATE          NOT NULL            COMMENT 'FECHA ULTIMA CONEXION',
  `PREG_RES`      BIGINT     NOT NULL            COMMENT 'PREGUNTA RESPONDIDA',
  `PRIMER_ACC`    BIGINT     NOT NULL            COMMENT 'PRIMER ACCESO',
  `CORREO`        VARCHAR(100)  NOT NULL DEFAULT '' COMMENT 'CORREO ELECTRONICO',
   CONSTRAINT `FK_COD_ROL` FOREIGN KEY (`COD_ROL`) REFERENCES `TBL_MS_ROLES` (`COD_ROL`) ON DELETE CASCADE
  )
ENGINE=INNODB
CHARACTER SET UTF8
COLLATE UTF8_UNICODE_CI
COMMENT 'TABLA MS USUARIO';

-- ///////////////////////////////////////////////////////////



CREATE TABLE `TBL_MS_PREG` (
  `COD_PREG`  BIGINT    NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'LLAVE PRIMARIA MS PREGUNTA',
  `PREGUNTA`  VARCHAR(100)  NOT NULL DEFAULT '' COMMENT 'PREGUNTA'
)
ENGINE=INNODB
CHARACTER SET UTF8
COLLATE UTF8_UNICODE_CI
COMMENT 'TABLA MS PREGUNTA';

-- ////////////////////////////////////
CREATE TABLE `TBL_MS_PREG_USR` (
  `COD_PREG`     BIGINT     NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'LLAVE PRIMARIA MS PREGUNTA USUARIO',
  `COD_USR`      BIGINT     NOT NULL                            COMMENT 'CODIGO USUARIO',
  `RESPUESTA`    VARCHAR(100)  NOT NULL DEFAULT ''                 COMMENT 'RESPUESTA',
  CONSTRAINT `FK_COD_USR`  FOREIGN KEY (`COD_USR`)  REFERENCES `TBL_MS_USR` (`COD_USR`)   ON DELETE CASCADE,
  CONSTRAINT `FK_PREG_USR` FOREIGN KEY (`COD_PREG`) REFERENCES `TBL_MS_PREG` (`COD_PREG`) ON DELETE CASCADE
)
ENGINE=INNODB
CHARACTER SET UTF8
COLLATE UTF8_UNICODE_CI
COMMENT 'TABLA MS PREGUNTA USUARIO';



CREATE TABLE `tbl_objetos` (
  `COD_OBJETO` bigint PRIMARY KEY AUTO_INCREMENT  NOT NULL,
  `OBJETO` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `DES_OBJETO` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `TIP_OBJETO` varchar(15) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Indices de la tabla `tbl_objetos`




Create table TBL_MS_BITACORAS (
 COD_BITACORA BIGINT PRIMARY KEY AUTO_INCREMENT NOT NULL
,FEC_REGISTRO DATETIME NOT NULL
,USR_REGISTRA VARCHAR(100) NOT NULL
,COD_USR BIGINT NOT NULL
,ACC_SISTEMA VARCHAR(100) NOT NULL
,DES_BITACORA VARCHAR(100) NOT NULL
,COD_OBJETO   BIGINT NOT NULL
,CONSTRAINT `FK_CODRB` FOREIGN KEY (`COD_USR`) REFERENCES `TBL_MS_USR` (`COD_USR`) ON DELETE CASCADE
,CONSTRAINT `FK_BITOBJ` FOREIGN KEY (`COD_OBJETO`) REFERENCES `tbl_objetos` (`COD_OBJETO`) ON DELETE CASCADE
) ENGINE=INNODB CHARACTER SET UTF8 COLLATE UTF8_UNICODE_CI;

-- ////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////


CREATE TABLE `TBL_MS_HIST_CONTRASENAS` (
  `COD_HIST_CONTRA` BIGINT     NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'LLAVE PRIMARIA MS HISTORIAL CONTRASEÑA',
  `COD_USR`         BIGINT     NOT NULL                            COMMENT 'CODIGO USUARIO',
  `CONTRASENA`     VARCHAR(32)   NOT NULL DEFAULT ''                 COMMENT 'CONTRASEÑA',
  CONSTRAINT `FK_USR` FOREIGN KEY (`COD_USR`) REFERENCES `TBL_MS_USR` (`COD_USR`) ON DELETE CASCADE
)
ENGINE=INNODB
CHARACTER SET UTF8
COLLATE UTF8_UNICODE_CI
COMMENT 'TABLA MS CONTRASEÑA';


/* MODULO DE MANTENIMIENTO */

CREATE TABLE `tbl_permisos` (
  `COD_ROL` bigint  NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `COD_OBJETO` bigint NOT NULL,
  `PER_INSERCION` varchar(1) COLLATE utf8_unicode_ci NOT NULL,
  `PER_ELIMINACION` varchar(1) COLLATE utf8_unicode_ci NOT NULL,
  `PER_ACTUALIZACION` varchar(1) COLLATE utf8_unicode_ci NOT NULL,
  `PER_CONSULTAR` varchar(1) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- //////////////////////////////////////////////////////////////////////
CREATE TABLE `tbl_roles_objetos` (
  `COD_ROL` bigint  NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `COD_OBJETO` bigint NOT NULL,
  `PER_EDICION` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `PER_ELIMINAR` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `PER_ACTUALIZAR` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `FEC_CREACION` date NOT NULL,
  `CREADO_POR` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `FEC_MODIFICACION` date NOT NULL,
  `MOD_POR` varchar(100) COLLATE utf8_unicode_ci NOT NULL COMMENT 'MODIFICADO POR'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ///////////////////////////////////////////////////
CREATE TABLE `tbl_ms_parametros` (
  `COD_PARAMETRO` bigint NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `PARAMETRO` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `VALOR` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `COD_USR` bigint  NOT NULL,
  `FEC_CREACION` date NOT NULL,
  `FEC_MODIFICACION` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Indices de la tabla `tbl_ms_parametros`
--

--
ALTER TABLE `tbl_ms_parametros`
  ADD KEY `FK_PARUSR` (`COD_USR`);

--
-- Indices de la tabla `tbl_permisos`
--
ALTER TABLE `tbl_permisos`
  ADD KEY `FK_PERROLES` (`COD_ROL`),
  ADD KEY `FK_PEROBJ` (`COD_OBJETO`);

--
-- Indices de la tabla `tbl_roles_objetos`
--
ALTER TABLE `tbl_roles_objetos`
  ADD KEY `FK_ROLOBJ` (`COD_ROL`),
  ADD KEY `FK_OBJEROL` (`COD_OBJETO`);

--
-- Restricciones para tablas volcadas
--


-- Filtros para la tabla `tbl_ms_parametros`
--
ALTER TABLE `tbl_ms_parametros`
  ADD CONSTRAINT `FK_PARUSR` FOREIGN KEY (`COD_USR`) REFERENCES `tbl_ms_usr` (`COD_USR`) ON DELETE CASCADE;





--
-- Filtros para la tabla `tbl_roles_objetos`
--
ALTER TABLE `tbl_roles_objetos`
  ADD CONSTRAINT `FK_ROLOBJ` FOREIGN KEY (`COD_OBJETO`) REFERENCES `tbl_objetos` (`COD_OBJETO`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_OBJEROL` FOREIGN KEY (`COD_ROL`) REFERENCES `tbl_ms_roles` (`COD_ROL`) ON DELETE CASCADE;
COMMIT;


--
-- Restricciones para tablas volcadas
--



--
-- Filtros para la tabla `tbl_permisos`
--
ALTER TABLE `tbl_permisos`
  ADD CONSTRAINT `FK_PEROBJ` FOREIGN KEY (`COD_OBJETO`) REFERENCES `tbl_objetos` (`COD_OBJETO`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_PERROLES` FOREIGN KEY (`COD_ROL`) REFERENCES `tbl_ms_roles` (`COD_ROL`) ON DELETE CASCADE;

--
-- Filtros para la tabla `tbl_roles_objetos`
--
--
-- Restricciones para tablas volcadas
--


-- Filtros para la tabla `tbl_ms_parametros`
--
ALTER TABLE `tbl_ms_parametros`
  ADD CONSTRAINT `FK_PARAMUSR` FOREIGN KEY (`COD_USR`) REFERENCES `tbl_ms_usr` (`COD_USR`) ON DELETE CASCADE;
  
/*..................................MODULO DE CUENTAS........................................*/
/*............................LA ALEXA Y EL KEVIN............................................*/
/*..............................1-CREAR CUENTA...............................................*/
/*..............................1.1-CLASIFICACION............................................*/
/*...........................................................................................*/


CREATE TABLE TBL_CLASIFICACIONES(
  COD_CLASIFICACION  BIGINT       PRIMARY KEY AUTO_INCREMENT  COMMENT 'CODIGO ID DE LA LLAVE PRIMARIA'
, NATURALEZA         VARCHAR(255) NOT NULL                    COMMENT 'NATURALEZA DE  LA CUENTA'
)ENGINE=INNODB
CHARACTER SET UTF8
COLLATE UTF8_UNICODE_CI;


-- ////////////////////////////////////////////////////


CREATE TABLE TBL_PERIODOS (
   `COD_PERIODO`     BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT
  ,`COD_USUARIO`      BIGINT NOT NULL COMMENT 'FORANEA PARA INDENTIFICAR QUE USUARIO EJECUTO EL CIERRE DE MES' 
  ,`FEC_PERIODO`     DATETIME NOT NULL COMMENT 'FECHA EN QUE SE REALIZO' 
  ,`NOM_PERIODO`     VARCHAR(100) NOT NULL COMMENT 'Nombre del periodo'
  ,`FEC_INI`         DATETIME  NOT NULL  COMMENT 'FECHA DE  CONTABLIZACION INICIAL DEL PERIODO'
  ,`FEC_FIN`         DATETIME  NOT NULL  COMMENT 'FECHA DE FINALIZACION DEL PERIODO'
  ,`ESTADO`          ENUM('ACTIVO','CERRADO')  COMMENT 'ESTADO DEL PERIODO'
) ENGINE=INNODB
CHARACTER SET UTF8
COLLATE UTF8_UNICODE_CI;

ALTER TABLE
TBL_PERIODOS
ADD CONSTRAINT FK_PERUSU
FOREIGN  KEY tbl_periodos(COD_USUARIO)
REFERENCES tbl_ms_usr(COD_USR) ON DELETE CASCADE;

-- ////////////////////////////////////////////////////////////////////

CREATE TABLE TBL_CUENTAS(
  COD_CUENTA    BIGINT       PRIMARY KEY AUTO_INCREMENT COMMENT 'CODIGO ID DE LA LLAVE PRIMARIA'
, COD_CLASIFICACION BIGINT                              COMMENT 'LLAVE FORANEA DE LA TABLA CLASIFICACION'
, NUM_CUENTA    VARCHAR(255) NOT NULL                   COMMENT 'NUMERO DE LA CUENTA'
, NOM_CUENTA    VARCHAR(255) NOT NULL                   COMMENT 'NOMBRE DE LA CUENTA'
,CONSTRAINT `FK_CUECLA` FOREIGN KEY (`COD_CLASIFICACION`) REFERENCES `TBL_CLASIFICACIONES` (`COD_CLASIFICACION`) ON DELETE CASCADE
)ENGINE=INNODB
CHARACTER SET UTF8
COLLATE UTF8_UNICODE_CI;


-- ////////////////////////////////////////////////////////////////////

CREATE TABLE TBL_SUBCUENTAS(
  COD_SUBCUENTA   BIGINT     PRIMARY KEY AUTO_INCREMENT COMMENT 'CODIGO ID DE LA LLAVE PRIMARIA'
, COD_CLASIFICACION BIGINT                              COMMENT 'LLAVE FORANEA DE LA TABLA CLASIFICACION'
, NUM_SUBCUENTA VARCHAR(255) NOT NULL                   COMMENT 'NUMERO DE LA CUENTA'
, NOM_SUBCUENTA VARCHAR(255) NOT NULL                   COMMENT 'NOMBRE DE LA CUENTA'
, COD_CUENTA    BIGINT                                  COMMENT 'CODIGO ID DE LA LLAVE PRIMARIA'
,CONSTRAINT `FK_SUBCLA` FOREIGN KEY (`COD_CLASIFICACION`) REFERENCES `TBL_CLASIFICACIONES` (`COD_CLASIFICACION`) ON DELETE CASCADE
,CONSTRAINT `FK_SUBCUE` FOREIGN KEY (`COD_CUENTA`) REFERENCES `TBL_CUENTAS` (`COD_CUENTA`) ON DELETE CASCADE
)ENGINE=INNODB
CHARACTER SET UTF8
COLLATE UTF8_UNICODE_CI;


-- ////////////////////////////////////////////////////////////////////

/*..................................MODULO DE CONTABLE........................................*/
/*..............................1-LIBRIO DIARIO..............................................*/
/*..............................2-LIBRIO MAYOR...............................................*/
/*...........................................................................................*/
/*...........................................................................................*/
/*...........................................................................................*/
CREATE TABLE TBL_ESTADOS_SUBCUENTAS(
 COD_ESTADO BIGINT           PRIMARY KEY  AUTO_INCREMENT        COMMENT 'LLAVE PRIMARIA DE LA TABLA ESTADO'
,COD_SUBCUENTA BIGINT                                           COMMENT 'LLAVE FORANEA DE LA TABLA SUBCUENTAS'
,EST_SUBCUENTAS ENUM('INGRESADA', 'PENDIENTE', 'PROCESADA')            COMMENT 'DESCRIPCION DEL ESTADO EN EL QUE SE ENCUENTRA LA TRANSACCION'
,CONSTRAINT `FK_ESTSUB` FOREIGN KEY (`COD_SUBCUENTA`) REFERENCES `TBL_SUBCUENTAS` (`COD_SUBCUENTA`) ON DELETE CASCADE
)ENGINE=INNODB
CHARACTER SET UTF8
COLLATE UTF8_UNICODE_CI;


-- /////////////////////////////////////////////////////////////////

CREATE TABLE TBL_LIBROS_DIARIOS(
  COD_LIBDIARIO  BIGINT      PRIMARY KEY AUTO_INCREMENT COMMENT 'CODIGO ID DE LA LLAVE PRIMARIA'
, COD_CUENTA    BIGINT                                  COMMENT 'CODIGO ID DE LA LLAVE PRIMARIA'
, COD_SUBCUENTA BIGINT                                  COMMENT 'CODIGO ID DE LA LLAVE PRIMARIA'
-- , COD_CLASIFICACION BIGINT                         COMMENT 'LLAVE FORANEA DE LA TABLA CLASIFICACION' es necesario por si se mete datos solo a la tabla
, COD_ESTADO    BIGINT                                  COMMENT 'CODIGO ID DE LA LLAVE PRIMARIA'
, NUM_SUBCUENTA VARCHAR(255) NOT NULL                   COMMENT 'NUMERO DE LA SUBCUENTA'
, NOM_SUBCUENTA VARCHAR(255) NOT NULL                   COMMENT 'NOMBRE DE LA SUBCUENTA'
, SAL_DEBE    DECIMAL (8,2) NOT NULL                    COMMENT 'SALDO DEBE DE LA CUENTA'
, SAL_HABER   DECIMAL (8,2) NOT NULL                    COMMENT 'SALDO HABER DE LA CUENTA'
, FEC_LIBDIARIO DATETIME NOT NULL                       COMMENT 'FECHA QUE SE REGISTRA LA TUPLA'
,CONSTRAINT `FK_LIBDCUE` FOREIGN KEY (`COD_CUENTA`) REFERENCES `TBL_CUENTAS` (`COD_CUENTA`) ON DELETE CASCADE
,CONSTRAINT `FK_LIBDSUB` FOREIGN KEY (`COD_SUBCUENTA`) REFERENCES `TBL_SUBCUENTAS` (`COD_SUBCUENTA`) ON DELETE CASCADE
,CONSTRAINT `FK_LIBDEST` FOREIGN KEY (`COD_ESTADO`) REFERENCES `TBL_ESTADOS_SUBCUENTAS` (`COD_ESTADO`) ON DELETE CASCADE
)ENGINE=INNODB
CHARACTER SET UTF8
COLLATE UTF8_UNICODE_CI;

-- //////////////////////////////////////////////////////

CREATE TABLE TBL_ESTADOS_CUENTAS(
 COD_ESTCUENTA BIGINT           PRIMARY KEY  AUTO_INCREMENT       COMMENT 'LLAVE PRIMARIA DE LA TABLA ESTADO'
,COD_CUENTA BIGINT                                                COMMENT 'LLAVE FORANEA DE LA TABLA SUBCUENTAS'                                           
,EST_CUENTA ENUM('INGRESADA', 'PENDIENTE', 'PROCESADA')               COMMENT 'DESCRIPCION DEL ESTADO EN EL QUE SE ENCUENTRA LA TRANSACCION'
,CONSTRAINT `FK_ESTCUE` FOREIGN KEY (`COD_CUENTA`) REFERENCES `TBL_CUENTAS` (`COD_CUENTA`) ON DELETE CASCADE
)ENGINE=INNODB
CHARACTER SET UTF8
COLLATE UTF8_UNICODE_CI;



-- //////////////////////////////////////////////////////////////

CREATE TABLE TBL_LIBROS_MAYORES(  
  COD_LIBMAYOR BIGINT       PRIMARY KEY AUTO_INCREMENT COMMENT 'CODIGO ID DE LA LLAVE PRIMARIA'
, COD_CUENTA  BIGINT                                  COMMENT 'CODIGO ID DE LA LLAVE PRIMARIA'
, COD_CLASIFICACION BIGINT                         COMMENT 'LLAVE FORANEA DE LA TABLA CLASIFICACION'
, COD_PERIODO BIGINT                                 COMMENT 'LLAVE FORANEA DE LA TABLA PERIODO'
, COD_ESTCUENTA BIGINT                                COMMENT 'LLAVE FORANEA DE LA TABLA ESTADO DE CUENTAS'
, NUM_CUENTA   VARCHAR(255) NOT NULL                   COMMENT 'NUMERO DE LA CUENTA'
, NOM_CUENTA   VARCHAR(255) NOT NULL                   COMMENT 'NOMBRE DE LA CUENTA'
, SAL_DEBE   DECIMAL (8,2) NOT NULL                   COMMENT 'SALDO DEBE DE LA CUENTA'
, SAL_HABER  DECIMAL (8,2) NOT NULL                   COMMENT 'SALDO HABER DE LA CUENTA'
, FEC_LIBMAYOR DATETIME NOT NULL                   COMMENT 'FECHA QUE SE REGISTRA LA TUPLA'
,CONSTRAINT `FK_LIBMCUE` FOREIGN KEY (`COD_CUENTA`) REFERENCES `TBL_CUENTAS` (`COD_CUENTA`) ON DELETE CASCADE
,CONSTRAINT `FK_LIBMCLA` FOREIGN KEY (`COD_CLASIFICACION`) REFERENCES `TBL_CLASIFICACIONES` (`COD_CLASIFICACION`) ON DELETE CASCADE
,CONSTRAINT `FK_LIBMPER` FOREIGN KEY (`COD_PERIODO`) REFERENCES `TBL_PERIODOS` (`COD_PERIODO`) ON DELETE CASCADE
,CONSTRAINT `FK_LIBMEST` FOREIGN KEY (`COD_ESTCUENTA`) REFERENCES `TBL_ESTADOS_CUENTAS` (`COD_ESTCUENTA`) ON DELETE CASCADE
)ENGINE=INNODB
CHARACTER SET UTF8
COLLATE UTF8_UNICODE_CI;



-- ////////////////////////////////////////////////////////////
CREATE TABLE TBL_ESTADOS_RESULTADOS(
        `COD_ESTRESULTADO` BIGINT PRIMARY KEY AUTO_INCREMENT NOT NULL,
        `COD_LIBMAYOR` BIGINT,
        `COD_PERIODO` BIGINT,
        `COD_PARAMETRO` BIGINT,
        `EMPRESA` VARCHAR(50) NOT NULL COMMENT 'NOMBRE DE LA EMPRESA',
        `FEC_ESTADO` DATETIME NOT NULL COMMENT 'FECHA EN LA QUE SE HACE EL ESTADO DE RESULTADO',
        `VEN_NETAS` DECIMAL(8, 2) NOT NULL COMMENT 'Ventas netas = Ventas - Descuentos',
        `COS_VENTAS` DECIMAL(8, 2) NOT NULL COMMENT 'TOTAL COSTO DE VENTAS= SUELDOS+COST_VENTAS',
        `UTI_BRUTA` DECIMAL(8, 2) NOT NULL COMMENT 'VENTAS NETAS - COSTOS DE VENTAS = UTILIDAD BRUTA DE LAS VENTAS',
        `TOT_GASTOS` DECIMAL(8, 2) NOT NULL COMMENT 'GASTOS TOTALES ES GASTOS ADMINISTRATIVOS + GASTO DE VENTAS',
        `UTI_ANTIMP` DECIMAL(8, 2) NOT NULL COMMENT 'UTILIDAD ANTES DE IMPUESTO =  UTILDAD BRUTA-TOTALDEGASTOS',
        `IMP_UTILIDAD` DECIMAL(8, 2) NOT NULL COMMENT 'ESTE ES EL IMPUESTO A LA UTILIDAD ES EL 10% EN HONDURAS DE UTIL_IMP',
        `UTI_NETA` DECIMAL(8, 2) NOT NULL COMMENT 'LA UTILIDAD NETA= UTIL_IMP-IMP_UTILIDAD',
        CONSTRAINT `FK_ESTLIBMAYOR` FOREIGN KEY (`COD_LIBMAYOR`) REFERENCES `TBL_LIBROS_MAYORES` (`COD_LIBMAYOR`) ON DELETE CASCADE,
        CONSTRAINT `FK_ESTPER` FOREIGN KEY (`COD_PERIODO`) REFERENCES `TBL_PERIODOS` (`COD_PERIODO`) ON DELETE CASCADE,
        CONSTRAINT `FK_ESTPAR` FOREIGN KEY (`COD_PARAMETRO`) REFERENCES `tbl_ms_parametros` (`COD_PARAMETRO`) ON DELETE CASCADE
    ) ENGINE = INNODB CHARACTER SET UTF8 COLLATE UTF8_UNICODE_CI;


CREATE TABLE `tbl_balances_generales` (
  `COD_BALANCE` bigint NOT NULL AUTO_INCREMENT,
  `COD_LIBMAYOR` bigint NOT NULL,
  `EMPRESA` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `FEC_BALANCE` datetime NOT NULL,
  `TOT_ACTIVO` BIGINT NOT NULL,
  `TOT_PASIVO` BIGINT NOT NULL,
  `TOT_PATRIMONIO` BIGINT NOT NULL,
  PRIMARY KEY (`COD_BALANCE`),
  KEY `FK_BLGLIBMAYOR` (`COD_LIBMAYOR`),
  CONSTRAINT `FK_BLGLIBMAYOR` FOREIGN KEY (`COD_LIBMAYOR`) REFERENCES `TBL_LIBROS_MAYORES` (`COD_LIBMAYOR`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE TBL_SALDOS_BALANCES (
 `COD_SALDO`    BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT
,`COD_BALANCE`  BIGINT NOT NULL
,`FEC_SALDOS`   DATETIME NOT NULL
,`TOT_ACTIVO`   BIGINT NOT NULL
,`TOT_PASPAT`   BIGINT NOT NULL COMMENT 'SUMA DE TOTAL DE PASIVO + TOTAL DE CAPITAL'
 ,CONSTRAINT `FK_ SALBLG` FOREIGN KEY (`COD_BALANCE`) REFERENCES `TBL_BALANCES_GENERALES` (`COD_BALANCE`) ON DELETE CASCADE
) ENGINE=INNODB
CHARACTER SET UTF8
COLLATE UTF8_UNICODE_CI;


CREATE TABLE TBL_COMPROBANTES(
  `COD_COMPROBANTE` BIGINT PRIMARY KEY AUTO_INCREMENT NOT NULL 
  ,`COD_LIBDIARIO`  BIGINT NOT NULL
  ,`FEC_COMPROBANTE`DATETIME NOT NULL
  ,`COMPROBANTE`    VARCHAR(255) NOT NULL
  ,`DES_COMPROBANTE`VARCHAR(100) NOT NULL
  ,CONSTRAINT `FK_COM_LIBDIARIO` FOREIGN KEY (`COD_LIBDIARIO`) REFERENCES `TBL_LIBROS_DIARIOS` (`COD_LIBDIARIO`) ON DELETE CASCADE
)ENGINE=INNODB
CHARACTER SET UTF8
COLLATE UTF8_UNICODE_CI;


