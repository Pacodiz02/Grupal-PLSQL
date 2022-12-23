-- ✒️ **Ejercicio hecho por Juan Jesús Alejo Sillero**

-- 4. Añade una columna EMAIL a la tabla AUXILIARES. Realiza un trigger que envíe un correo electrónico informativo a los auxiliares de vuelo cada vez que se les asigna un viaje, informándoles de la ciudad de origen, la fecha, el código de vuelo y los nombres de piloto y copiloto.

-- Antes de comenzar, configuro Oracle para que pueda usar el servicio SMTP de mi máquina. Para ello debo conectarme como sysdba:
-- sqlplus / as sysdba

-- Ejecuto lo siguiente:
BEGIN
  DBMS_NETWORK_ACL_ADMIN.CREATE_ACL(
    acl => 'aclcorreo.xml',
    description => 'Enviar correos',
    principal => 'PRACGRUPAL',
    is_grant => true,
    privilege => 'connect',
    start_date => SYSTIMESTAMP,
    end_date => NULL
  );
  COMMIT;
END;
/

BEGIN
  DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL (
    acl => 'aclcorreo.xml',
    host => '*',
    lower_port => NULL,
    upper_port => NULL
  );
  COMMIT;
END;
/

GRANT EXECUTE ON UTL_MAIL TO PRACGRUPAL;

ALTER SYSTEM SET smtp_out_server='localhost' SCOPE=BOTH;
-- Tras esto ya puedo enviar correos desde Oracle.

-- Ahora, me conecto con mi usuario sin privilegios y hago el resto del ejercicio. Agrego la columna EMAIL a la tabla AUXILIARES:
ALTER TABLE AUXILIARES ADD EMAIL VARCHAR2(100);

-- Agrego un email a cada auxiliar para poder probar el trigger:
UPDATE AUXILIARES SET EMAIL = 'auxiliar1@juanje.net' WHERE NUMPASAPORTE = 'AJC000153';
UPDATE AUXILIARES SET EMAIL = 'auxiliar2@juanje.net' WHERE NUMPASAPORTE = 'AHC000120';
UPDATE AUXILIARES SET EMAIL = 'auxiliar3@juanje.net' WHERE NUMPASAPORTE = 'BFJ000171';
UPDATE AUXILIARES SET EMAIL = 'auxiliar4@juanje.net' WHERE NUMPASAPORTE = 'CRT000765';
UPDATE AUXILIARES SET EMAIL = 'auxiliar5@juanje.net' WHERE NUMPASAPORTE = 'ECB000121';
UPDATE AUXILIARES SET EMAIL = 'auxiliar6@juanje.net' WHERE NUMPASAPORTE = 'GBB000732';

-- Función para obtener el email de un auxiliar a partir de su pasaporte:
CREATE OR REPLACE FUNCTION F_OBTENEREMAILAUXILIAR (P_NUMPASAPORTE IN AUXILIARES.NUMPASAPORTE%TYPE)
RETURN AUXILIARES.EMAIL%TYPE
IS
  VV_EMAIL AUXILIARES.EMAIL%TYPE;
BEGIN
  SELECT EMAIL
  INTO VV_EMAIL
  FROM AUXILIARES
  WHERE NUMPASAPORTE = P_NUMPASAPORTE;
  RETURN VV_EMAIL;
END;
/

/* Prueba de que la función se ejecuta correctamente: */
SELECT F_OBTENEREMAILAUXILIAR('AJC000153') FROM DUAL;

-- Función para obtener el pasaporte del piloto de un vuelo a partir del CODVUELO:
CREATE OR REPLACE FUNCTION F_OBTENERPASAPORTEPILOTO (P_CODVUELO IN VUELOS.CODVUELO%TYPE)
RETURN VUELOS.NUMPASAPORTEPILOTO%TYPE
IS
  VV_NUMPASAPORTEPILOTO VUELOS.NUMPASAPORTEPILOTO%TYPE;
BEGIN
  SELECT NUMPASAPORTEPILOTO
  INTO VV_NUMPASAPORTEPILOTO
  FROM VUELOS
  WHERE CODVUELO = P_CODVUELO;
  RETURN VV_NUMPASAPORTEPILOTO;
END;
/

/* Prueba de que la función se ejecuta correctamente: */
SELECT F_OBTENERPASAPORTEPILOTO('IB-3949') FROM DUAL;

-- Función para obtener el nombre del piloto de un vuelo a partir del CODVUELO llamando a la función F_OBTENERPASAPORTEPILOTO:
CREATE OR REPLACE FUNCTION F_OBTENERNOMBREPILOTO (P_CODVUELO IN VUELOS.CODVUELO%TYPE)
RETURN PERSONAL.NOMBRE%TYPE
IS
  VV_NUMPASAPORTEPILOTO VUELOS.NUMPASAPORTEPILOTO%TYPE;
  VV_NOMBRE PERSONAL.NOMBRE%TYPE;
BEGIN
  VV_NUMPASAPORTEPILOTO := F_OBTENERPASAPORTEPILOTO(P_CODVUELO);
  SELECT NOMBRE
  INTO VV_NOMBRE
  FROM PERSONAL
  WHERE NUMPASAPORTE = VV_NUMPASAPORTEPILOTO;
  RETURN VV_NOMBRE;
END;
/

/* Prueba de que la función se ejecuta correctamente: */
SELECT F_OBTENERNOMBREPILOTO('IB-3949') FROM DUAL;

-- Función para obtener el pasaporte del copiloto de un vuelo a partir del CODVUELO:
CREATE OR REPLACE FUNCTION F_OBTENERPASAPORTECOPILOTO (P_CODVUELO IN VUELOS.CODVUELO%TYPE)
RETURN VUELOS.NUMPASAPORTECOPILOTO%TYPE
IS
  VV_NUMPASAPORTECOPILOTO VUELOS.NUMPASAPORTECOPILOTO%TYPE;
BEGIN
  SELECT NUMPASAPORTECOPILOTO
  INTO VV_NUMPASAPORTECOPILOTO
  FROM VUELOS
  WHERE CODVUELO = P_CODVUELO;
  RETURN VV_NUMPASAPORTECOPILOTO;
END;
/

/* Prueba de que la función se ejecuta correctamente: */
SELECT F_OBTENERPASAPORTECOPILOTO('IB-3949') FROM DUAL;

-- Función para obtener el nombre del copiloto de un vuelo a partir del CODVUELO llamando a la función F_OBTENERPASAPORTECOPILOTO:
CREATE OR REPLACE FUNCTION F_OBTENERNOMBRECOPILOTO (P_CODVUELO IN VUELOS.CODVUELO%TYPE)
RETURN PERSONAL.NOMBRE%TYPE
IS
  VV_NUMPASAPORTECOPILOTO VUELOS.NUMPASAPORTECOPILOTO%TYPE;
  VV_NOMBRE PERSONAL.NOMBRE%TYPE;
BEGIN
  VV_NUMPASAPORTECOPILOTO := F_OBTENERPASAPORTECOPILOTO(P_CODVUELO);
  SELECT NOMBRE
  INTO VV_NOMBRE
  FROM PERSONAL
  WHERE NUMPASAPORTE = VV_NUMPASAPORTECOPILOTO;
  RETURN VV_NOMBRE;
END;
/

/* Prueba de que la función se ejecuta correctamente: */
SELECT F_OBTENERNOMBRECOPILOTO('IB-3949') FROM DUAL;

-- Función para obtener el código del aeropuerto de origen de un vuelo a partir del CODVUELO:
CREATE OR REPLACE FUNCTION F_OBTENERCODAEROPUERTOORIGEN (P_CODVUELO IN VUELOS.CODVUELO%TYPE)
RETURN VUELOS.CODAEROPUERTOORIGEN%TYPE
IS
  VV_CODAEROPUERTOORIGEN VUELOS.CODAEROPUERTOORIGEN%TYPE;
BEGIN
  SELECT CODAEROPUERTOORIGEN
  INTO VV_CODAEROPUERTOORIGEN
  FROM VUELOS
  WHERE CODVUELO = P_CODVUELO;
  RETURN VV_CODAEROPUERTOORIGEN;
END;
/

/* Prueba de que la función se ejecuta correctamente: */
SELECT F_OBTENERCODAEROPUERTOORIGEN('IB-3949') FROM DUAL;

-- Función para obtener la ciudad de origen de un vuelo a partir del CODVUELO llamando a la función F_OBTENERCODAEROPUERTOORIGEN:
CREATE OR REPLACE FUNCTION F_OBTENERCIUDADORIGEN (P_CODVUELO IN VUELOS.CODVUELO%TYPE)
RETURN AEROPUERTOS.CIUDAD%TYPE
IS
  VV_CODAEROPUERTOORIGEN VUELOS.CODAEROPUERTOORIGEN%TYPE;
  VV_CIUDAD AEROPUERTOS.CIUDAD%TYPE;
BEGIN
  VV_CODAEROPUERTOORIGEN := F_OBTENERCODAEROPUERTOORIGEN(P_CODVUELO);
  SELECT CIUDAD
  INTO VV_CIUDAD
  FROM AEROPUERTOS
  WHERE CODAEROPUERTO = VV_CODAEROPUERTOORIGEN;
  RETURN VV_CIUDAD;
END;
/

/* Prueba de que la función se ejecuta correctamente: */
SELECT F_OBTENERCIUDADORIGEN('IB-3949') FROM DUAL;

-- Creo el trigger T_ENVIAREMAILAUXILIARESDEVIAJE que se ejecutará cada vez que se inserte un nuevo registro en la tabla AUXILIARESDEVIAJE. Se llamará a las funciones F_OBTENEREMAILAUXILIAR, F_OBTENERNOMBREPILOTO, F_OBTENERNOMBRECOPILOTO y F_OBTENERCIUDADORIGEN para obtener los datos necesarios para enviar el email. La fecha y el código del vuelo se obtienen directamente del registro insertado en la tabla AUXILIARESDEVIAJE:
CREATE OR REPLACE TRIGGER T_ENVIAREMAILAUXILIARESDEVIAJE
AFTER INSERT ON AUXILIARESDEVIAJE
FOR EACH ROW
DECLARE
  VV_EMAILAUXILIAR AUXILIARES.EMAIL%TYPE;
  VV_NOMBREPILOTO PERSONAL.NOMBRE%TYPE;
  VV_NOMBRECOPILOTO PERSONAL.NOMBRE%TYPE;
  VV_CIUDADORIGEN AEROPUERTOS.CIUDAD%TYPE;
BEGIN
  VV_EMAILAUXILIAR := F_OBTENEREMAILAUXILIAR(:NEW.NUMPASAPORTE);
  VV_NOMBREPILOTO := F_OBTENERNOMBREPILOTO(:NEW.CODVUELO);
  VV_NOMBRECOPILOTO := F_OBTENERNOMBRECOPILOTO(:NEW.CODVUELO);
  VV_CIUDADORIGEN := F_OBTENERCIUDADORIGEN(:NEW.CODVUELO);
  UTL_MAIL.SEND(
    SENDER => 'remitente@juanje.net',
    RECIPIENTS => VV_EMAILAUXILIAR,
    SUBJECT => 'Asignación de viaje nuevo',
    MESSAGE => 'Se le ha asignado un nuevo viaje. Los datos del viaje son los siguientes:' || CHR(10) || CHR(10) || '- Fecha: ' || TO_CHAR(:NEW.FECHA, 'DD/MM/YYYY') || CHR(10) || '- Código del vuelo: ' || :NEW.CODVUELO || CHR(10) || '- Nombre del piloto: ' || VV_NOMBREPILOTO || CHR(10) || '- Nombre del copiloto: ' || VV_NOMBRECOPILOTO || CHR(10) || '- Ciudad de origen: ' || VV_CIUDADORIGEN || CHR(10) || CHR(10) || 'Gracias por su atención.',
    MIME_TYPE => 'text/plain'
  );
END;
/

/* Prueba de que el trigger se ejecuta correctamente: */
INSERT INTO VIAJES VALUES (TO_DATE('23/12/2022', 'DD/MM/YYYY'), 'IB-3949', 'S2-AFA');
INSERT INTO AUXILIARESDEVIAJE VALUES ('ECB000121', 'IB-3949', TO_DATE('23/12/2022', 'DD/MM/YYYY'));

/* Para borrar los registros insertados: */
DELETE FROM AUXILIARESDEVIAJE WHERE NUMPASAPORTE = 'ECB000121' AND CODVUELO = 'IB-3949' AND FECHA = TO_DATE('23/12/2022', 'DD/MM/YYYY');
DELETE FROM VIAJES WHERE FECHA = TO_DATE('23/12/2022', 'DD/MM/YYYY') AND CODVUELO = 'IB-3949';
