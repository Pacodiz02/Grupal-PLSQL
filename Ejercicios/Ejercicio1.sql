-- ✒️ **Ejercicio hecho por Juan Jesús Alejo Sillero con asistencia de Alejandro Montes Delgado**

-- 1. Realiza una función que reciba como parámetros el Número de Pasaporte de un piloto, copiloto o auxiliar de viaje y una fecha y devuelva el código del vuelo en el que estaba trabajando en dicha fecha. Debes controlar las siguientes excepciones: Empleado Inexistente, Fecha sin viajes, Empleado sin vuelo asignado.

-- 1.1. Función que comprueba si el NUMPASAPORTE existe en la tabla PERSONAL. Si existe, devuelve el NUMPASAPORTE, si no, usará la excepción NO_DATA_FOUND para devolver un mensaje por pantalla.
CREATE OR REPLACE FUNCTION F_EMPLEADOEXISTE (P_NUMPASAPORTE IN PERSONAL.NUMPASAPORTE%TYPE) RETURN VARCHAR2 IS
  VV_NUMPASAPORTE PERSONAL.NUMPASAPORTE%TYPE;
BEGIN
  SELECT NUMPASAPORTE INTO VV_NUMPASAPORTE
  FROM PERSONAL
  WHERE NUMPASAPORTE = P_NUMPASAPORTE;
  RETURN VV_NUMPASAPORTE;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20001, 'El empleado con número de pasaporte ' || P_NUMPASAPORTE || ' no existe.');
END;
/

-- Comprobamos que la función se ejecuta correctamente:
SELECT F_EMPLEADOEXISTE('ABC123456') FROM DUAL; -- Este empleado existe
SELECT F_EMPLEADOEXISTE('XXXXXXXXX') FROM DUAL; -- Este empleado no existe

-- 1.2. Función que comprueba si la FECHA existe en la tabla VIAJES al menos una vez usando ROWNUM = 1 para no leer todos los registros y optimizar la función. Si existe, devuelve la FECHA introducida, si no, usará la excepción NO_DATA_FOUND para devolver un mensaje por pantalla.
CREATE OR REPLACE FUNCTION F_FECHAEXISTE (P_FECHA IN VIAJES.FECHA%TYPE) RETURN DATE IS
  VV_FECHA VIAJES.FECHA%TYPE;
BEGIN
  SELECT FECHA INTO VV_FECHA
  FROM VIAJES
  WHERE FECHA = P_FECHA
  AND ROWNUM = 1;
  RETURN VV_FECHA;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20002, 'La fecha ' || TO_CHAR(P_FECHA, 'DD/MM/YYYY') || ' no cuenta con ningún viaje.');
END;
/

-- Comprobamos que la función se ejecuta correctamente:
SELECT F_FECHAEXISTE(TO_DATE('26/09/2016', 'DD/MM/YYYY')) FROM DUAL; -- Esta fecha existe
SELECT F_FECHAEXISTE(TO_DATE('11/02/2005', 'DD/MM/YYYY')) FROM DUAL; -- Esta fecha no existe

-- 1.3.1. Función que comprueba si el NUMPASAPORTE es de un piloto, si es así, devuelve PILOTO, si no, no devuelve nada.
CREATE OR REPLACE FUNCTION F_ESPILOTO (P_NUMPASAPORTE IN PILOTOS.NUMPASAPORTE%TYPE) RETURN VARCHAR2 IS
  VN_COUNT NUMBER;
  VV_PUESTO VARCHAR2(20);
BEGIN
  SELECT COUNT(*) INTO VN_COUNT
  FROM PILOTOS
  WHERE NUMPASAPORTE = P_NUMPASAPORTE;
  IF VN_COUNT > 0 THEN
    VV_PUESTO := 'PILOTO';
  END IF;
  RETURN VV_PUESTO;
END;
/

-- Comprobamos que la función se ejecuta correctamente:
SELECT F_ESPILOTO('CVF000126') FROM DUAL; -- Este empleado es piloto
SELECT F_ESPILOTO('ABC123456') FROM DUAL; -- Este empleado no es piloto

-- 1.3.2. Función que comprueba si el NUMPASAPORTE es de un copiloto, si es así, devuelve PILOTO, si no, no devuelve nada.
CREATE OR REPLACE FUNCTION F_ESCOPILOTO (P_NUMPASAPORTE IN COPILOTOS.NUMPASAPORTE%TYPE) RETURN VARCHAR2 IS
  VN_COUNT NUMBER;
  VV_PUESTO VARCHAR2(20);
BEGIN
  SELECT COUNT(*) INTO VN_COUNT
  FROM COPILOTOS
  WHERE NUMPASAPORTE = P_NUMPASAPORTE;
  IF VN_COUNT > 0 THEN
    VV_PUESTO := 'COPILOTO';
  END IF;
  RETURN VV_PUESTO;
END;
/

-- Comprobamos que la función se ejecuta correctamente:
SELECT F_ESCOPILOTO('ABC123456') FROM DUAL; -- Este empleado es copiloto
SELECT F_ESCOPILOTO('AHC000120') FROM DUAL; -- Este empleado no es copiloto

-- 1.3.3. Función que comprueba si el NUMPASAPORTE es de un auxiliar, si es así, devuelve PILOTO, si no, no devuelve nada.
CREATE OR REPLACE FUNCTION F_ESAUXILIAR (P_NUMPASAPORTE IN AUXILIARES.NUMPASAPORTE%TYPE) RETURN VARCHAR2 IS
  VN_COUNT NUMBER;
  VV_PUESTO VARCHAR2(20);
BEGIN
  SELECT COUNT(*) INTO VN_COUNT
  FROM AUXILIARES
  WHERE NUMPASAPORTE = P_NUMPASAPORTE;
  IF VN_COUNT > 0 THEN
    VV_PUESTO := 'AUXILIAR';
  END IF;
  RETURN VV_PUESTO;
END;
/

-- Comprobamos que la función se ejecuta correctamente:
SELECT F_ESAUXILIAR('AHC000120') FROM DUAL; -- Este empleado es auxiliar
SELECT F_ESAUXILIAR('CVF000126') FROM DUAL; -- Este empleado no es auxiliar

-- 1.3.4. Función que comprueba el puesto de un empleado llamando a las 3 anteriores y devuelve el puesto.
CREATE OR REPLACE FUNCTION F_COMPROBARPUESTO (P_NUMPASAPORTE IN PERSONAL.NUMPASAPORTE%TYPE) RETURN VARCHAR2 IS
  VV_PUESTO VARCHAR2(20);
BEGIN
  VV_PUESTO := F_ESPILOTO(P_NUMPASAPORTE);
  IF VV_PUESTO IS NULL THEN
    VV_PUESTO := F_ESCOPILOTO(P_NUMPASAPORTE);
  END IF;
  IF VV_PUESTO IS NULL THEN
    VV_PUESTO := F_ESAUXILIAR(P_NUMPASAPORTE);
  END IF;
  RETURN VV_PUESTO;
END;
/

-- Comprobamos que la función se ejecuta correctamente:
SELECT F_COMPROBARPUESTO('CVF000126') FROM DUAL; -- Este empleado es piloto
SELECT F_COMPROBARPUESTO('ABC123456') FROM DUAL; -- Este empleado es copiloto
SELECT F_COMPROBARPUESTO('AHC000120') FROM DUAL; -- Este empleado es auxiliar

-- 1.3.5. Función que recibirá un NUMPASAPORTE y una FECHA.
-- Ejemplo de funcionamiento de la función F_PILOTOVIAJAENFECHA:
-- A la función le doy el día 26/09/2016 y el pasaporte DSA000777.
-- Deberá buscar los diferentes CODVUELO de la tabla VUELOS que coincidan con ese pasaporte, esto se hará con un cursor ya que puede haber varios vuelos con el mismo pasaporte pero distinta fecha.
-- Deberá buscar los CODVUELO de la tabla VIAJES que coincidan con la fecha dada, esto también se hará con un cursor ya que puede haber varios viajes en esa fecha pero con distintos CODVUELO.
-- Una vez tengamos los CODVUELO de la tabla VUELOS y VIAJES, deberemos compararlos para ver si coinciden, si coinciden, devolverá una variable booleana que será TRUE, si no, devolverá FALSE por defecto.
CREATE OR REPLACE FUNCTION F_PILOTOVIAJAENFECHA (P_NUMPASAPORTE IN PERSONAL.NUMPASAPORTE%TYPE, P_FECHA IN VIAJES.FECHA%TYPE) RETURN VARCHAR2 IS
  CURSOR C_VUELOS IS
    SELECT CODVUELO
    FROM VUELOS
    WHERE NUMPASAPORTEPILOTO = P_NUMPASAPORTE;
  CURSOR C_VIAJES IS
    SELECT CODVUELO
    FROM VIAJES
    WHERE FECHA = P_FECHA;
  VV_CODVUELO1 C_VUELOS%ROWTYPE;
  VV_CODVUELO2 C_VIAJES%ROWTYPE;
  VV_CODVUELO VUELOS.CODVUELO%TYPE;
BEGIN
  FOR VV_CODVUELO1 IN C_VUELOS LOOP
    FOR VV_CODVUELO2 IN C_VIAJES LOOP
      IF VV_CODVUELO1.CODVUELO = VV_CODVUELO2.CODVUELO THEN
        VV_CODVUELO := VV_CODVUELO1.CODVUELO;
      END IF;
    END LOOP;
  END LOOP;
  RETURN VV_CODVUELO;
END;
/

-- Comprobamos que la función se ejecuta correctamente:
SELECT F_PILOTOVIAJAENFECHA('DSA000777', TO_DATE('26/09/2016', 'DD/MM/YYYY')) FROM DUAL; -- Este piloto viaja en esa fecha
SELECT F_COPILOTOVIAJAENFECHA('XXXX0777', TO_DATE('26/09/2016', 'DD/MM/YYYY')) FROM DUAL; -- Este piloto no existe y la fecha sí
SELECT F_COPILOTOVIAJAENFECHA('DSA000777', TO_DATE('27/09/2016', 'DD/MM/YYYY')) FROM DUAL; -- Este piloto existe pero la fecha no

-- 1.3.6. Esta función hará lo mismo que la anterior pero con el copiloto:
CREATE OR REPLACE FUNCTION F_COPILOTOVIAJAENFECHA (P_NUMPASAPORTE IN PERSONAL.NUMPASAPORTE%TYPE, P_FECHA IN VIAJES.FECHA%TYPE) RETURN VARCHAR2 IS
  CURSOR C_VUELOS IS
    SELECT CODVUELO
    FROM VUELOS
    WHERE NUMPASAPORTECOPILOTO = P_NUMPASAPORTE;
  CURSOR C_VIAJES IS
    SELECT CODVUELO
    FROM VIAJES
    WHERE FECHA = P_FECHA;
  VV_CODVUELO1 C_VUELOS%ROWTYPE;
  VV_CODVUELO2 C_VIAJES%ROWTYPE;
  VV_CODVUELO VUELOS.CODVUELO%TYPE;
BEGIN
  FOR VV_CODVUELO1 IN C_VUELOS LOOP
    FOR VV_CODVUELO2 IN C_VIAJES LOOP
      IF VV_CODVUELO1.CODVUELO = VV_CODVUELO2.CODVUELO THEN
        VV_CODVUELO := VV_CODVUELO1.CODVUELO;
      END IF;
    END LOOP;
  END LOOP;
  RETURN VV_CODVUELO;
END;
/

-- Comprobamos que la función se ejecuta correctamente:
SELECT F_COPILOTOVIAJAENFECHA('ABC123456', TO_DATE('26/09/2016', 'DD/MM/YYYY')) FROM DUAL; -- Este copiloto viaja en esa fecha
SELECT F_COPILOTOVIAJAENFECHA('ABC12456', TO_DATE('26/09/2016', 'DD/MM/YYYY')) FROM DUAL; -- Este copiloto no existe y la fecha sí
SELECT F_COPILOTOVIAJAENFECHA('ABC123456', TO_DATE('27/09/2016', 'DD/MM/YYYY')) FROM DUAL; -- Este copiloto existe pero la fecha no

-- 1.3.7. Función que recibirá un NUMPASAPORTE y una FECHA.
-- Hace lo mismo que las dos anteriores pero ajustada para los auxiliares de viaje que tienen ambos campos reunidos en la tabla AUXILIARESDEVIAJE:
CREATE OR REPLACE FUNCTION F_AUXILIARVIAJAENFECHA (P_NUMPASAPORTE IN AUXILIARESDEVIAJE.NUMPASAPORTE%TYPE, P_FECHA IN AUXILIARESDEVIAJE.FECHA%TYPE) RETURN VARCHAR2 IS
  VV_CODVUELO AUXILIARESDEVIAJE.CODVUELO%TYPE;
BEGIN
  SELECT CODVUELO INTO VV_CODVUELO
  FROM AUXILIARESDEVIAJE
  WHERE NUMPASAPORTE = P_NUMPASAPORTE AND FECHA = P_FECHA;
  RETURN VV_CODVUELO;
END;
/

-- Comprobamos que la función se ejecuta correctamente:
SELECT F_AUXILIARVIAJAENFECHA('AHC000120', TO_DATE('26/09/2016', 'DD/MM/YYYY')) FROM DUAL; -- Este auxiliar viaja en esa fecha
SELECT F_AUXILIARVIAJAENFECHA('AHC0020', TO_DATE('26/09/2016', 'DD/MM/YYYY')) FROM DUAL; -- Este auxiliar no existe y la fecha sí
SELECT F_AUXILIARVIAJAENFECHA('AHC000120', TO_DATE('28/09/2016', 'DD/MM/YYYY')) FROM DUAL; -- Este auxiliar existe pero la fecha no

-- 1.3.8. Función que recibe un NUMPASAPORTE y una FECHA y llama a la función F_COMPROBARPUESTO para saber el puesto del empleado. Si es PILOTO, llamará a la función F_PILOTOVIAJAENFECHA. Si es COPILOTO, llamará a la función F_COPILOTOVIAJAENFECHA. Si es AUXILIAR, llamará a la función F_AUXILIARVIAJAENFECHA. Devolverá un VARCHAR2 con el código de vuelo o NULL si no viaja en esa fecha:
CREATE OR REPLACE FUNCTION F_EMPLEADOVIAJAENFECHA (P_NUMPASAPORTE IN PERSONAL.NUMPASAPORTE%TYPE, P_FECHA IN VIAJES.FECHA%TYPE) RETURN VARCHAR2 IS
  VV_PUESTO VARCHAR2(20);
  VV_CODVUELO VUELOS.CODVUELO%TYPE;
BEGIN
  VV_PUESTO := F_COMPROBARPUESTO(P_NUMPASAPORTE);
  IF VV_PUESTO = 'PILOTO' THEN
    VV_CODVUELO := F_PILOTOVIAJAENFECHA(P_NUMPASAPORTE, P_FECHA);
  ELSIF VV_PUESTO = 'COPILOTO' THEN
    VV_CODVUELO := F_COPILOTOVIAJAENFECHA(P_NUMPASAPORTE, P_FECHA);
  ELSIF VV_PUESTO = 'AUXILIAR' THEN
    VV_CODVUELO := F_AUXILIARVIAJAENFECHA(P_NUMPASAPORTE, P_FECHA);
  END IF;
  RETURN VV_CODVUELO;
END;
/

-- Comprobamos que la función se ejecuta correctamente:
SELECT F_EMPLEADOVIAJAENFECHA('DSA000777', TO_DATE('26/09/2016', 'DD/MM/YYYY')) FROM DUAL; -- Este piloto viaja en esa fecha
SELECT F_EMPLEADOVIAJAENFECHA('ABC123456', TO_DATE('26/09/2016', 'DD/MM/YYYY')) FROM DUAL; -- Este copiloto viaja en esa fecha
SELECT F_EMPLEADOVIAJAENFECHA('AHC000120', TO_DATE('26/09/2016', 'DD/MM/YYYY')) FROM DUAL; -- Este auxiliar viaja en esa fecha
SELECT F_EMPLEADOVIAJAENFECHA('AHC0120', TO_DATE('26/09/2016', 'DD/MM/YYYY')) FROM DUAL; -- Este empleado no existe y la fecha sí
SELECT F_EMPLEADOVIAJAENFECHA('AHC000120', TO_DATE('26/09/2001', 'DD/MM/YYYY')) FROM DUAL; -- Este empleado existe pero la fecha no

-- 1.4. Función que recibe un NUMPASAPORTE y una FECHA y devuelve el código de vuelo en el que viaja el empleado con ese pasaporte. Si no viaja ese día (el valor de CODVUELO será nulo), ĺevanta una excepción. Antes de empezar, se comprobará que el empleado existe y que la fecha existe usando las funciones F_EMPLEADOEXISTE y F_FECHAEXISTE.
CREATE OR REPLACE FUNCTION F_CODVUELOEMPLEADO (P_NUMPASAPORTE IN PERSONAL.NUMPASAPORTE%TYPE, P_FECHA IN VIAJES.FECHA%TYPE) RETURN VARCHAR2 IS
  VV_NUMPASAPORTE PERSONAL.NUMPASAPORTE%TYPE;
  VV_FECHA VIAJES.FECHA%TYPE;
  VV_CODVUELO VUELOS.CODVUELO%TYPE;
BEGIN
  VV_NUMPASAPORTE := F_EMPLEADOEXISTE(P_NUMPASAPORTE);
  VV_FECHA := F_FECHAEXISTE(P_FECHA);
  VV_CODVUELO := F_EMPLEADOVIAJAENFECHA(P_NUMPASAPORTE, P_FECHA);
  RETURN VV_CODVUELO;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20003, 'El empleado y la fecha existen, pero el empleado no viaja ese día.');
END;
/

-- Comprobamos que la función se ejecuta correctamente:
SELECT F_CODVUELOEMPLEADO('AHC000120', TO_DATE('26/09/2016', 'DD/MM/YYYY')) FROM DUAL; -- Este empleado viaja en esa fecha
SELECT F_CODVUELOEMPLEADO('DSA000777', TO_DATE('26/09/2016', 'DD/MM/YYYY')) FROM DUAL; -- Este empleado viaja en esa fecha
SELECT F_CODVUELOEMPLEADO('ABC123456', TO_DATE('26/09/2016', 'DD/MM/YYYY')) FROM DUAL; -- Este empleado viaja en esa fecha

SELECT F_CODVUELOEMPLEADO('AHC0120', TO_DATE('26/09/2016', 'DD/MM/YYYY')) FROM DUAL; -- Levanta la excepción porque el empleado no existe
SELECT F_CODVUELOEMPLEADO('AHC000120', TO_DATE('26/09/2059', 'DD/MM/YYYY')) FROM DUAL; -- Levanta la excepción porque la fecha no existe
SELECT F_CODVUELOEMPLEADO('AJC000153', TO_DATE('13/10/2016', 'DD/MM/YYYY')) FROM DUAL; -- Levanta la excepción porque el empleado y la fecha existen, pero no viaja ese día
