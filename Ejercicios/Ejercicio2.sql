-- Ejercicio 2

-- Realiza un procedimiento que nos proporcione diferentes listados acerca de los viajes realizados gestionando las excepciones que consideres oportunas. El primer parámetro determinará el tipo de informe.


-- Informe Tipo 1: El segundo parámetro será un código de vuelo y el tercero una fecha. Se mostrará la siguiente información:

-- Fecha: dd/mm/yyyy        Hora: hh:mm

-- Código de Vuelo: xxxxxxxxx       AeropuertoOrigen-AeropuertoDestino

    -- NombrePasajero1                  NúmeroBultos1   PesoEquipaje1

    -- …

-- Porcentaje Ocupación Asientos: nn,n%     Total Peso Equipajes: n,nnn

--Informe 1 :El segundo parámetro será un código de vuelo y el tercero una fecha. Se mostrará la siguiente información:

SET SERVEROUTPUT ON;

-- HORA DEL VUELO --

--- Función para devolver HORA de un determinado VUELO

CREATE OR REPLACE FUNCTION devolver_hora (p_cod_vuelo PASAJEROSEMBARCADOS.CODVUELO%TYPE)
RETURN VARCHAR2
IS
    v_hora VARCHAR2(6);
BEGIN
    SELECT TO_CHAR(HORA, 'HH24:MI') INTO v_hora
    FROM VUELOS
    WHERE CODVUELO=p_cod_vuelo;
    RETURN v_hora;
END;
/

-- AEROPUERTO ORIGEN-DESTINO --

--- Función para devolver NOMBRE de AEROPUERTO ORIGEN

CREATE OR REPLACE FUNCTION devolver_nom_aeropuerto_origen (p_cod_vuelo PASAJEROSEMBARCADOS.CODVUELO%TYPE)
RETURN VARCHAR2
IS
    v_nombre_origen AEROPUERTOS.NOMBRE%TYPE;

BEGIN
    SELECT NOMBRE INTO v_nombre_origen
    FROM AEROPUERTOS
    WHERE CODAEROPUERTO=(SELECT CODAEROPUERTOORIGEN
                         FROM VUELOS
                         WHERE CODVUELO=p_cod_vuelo);
    RETURN v_nombre_origen;
END;
/


--- Función para devolver NOMBRE de AEROPUERTO DESTINO

CREATE OR REPLACE FUNCTION devolver_nom_aeropuerto_destino (p_cod_vuelo PASAJEROSEMBARCADOS.CODVUELO%TYPE)
RETURN VARCHAR2
IS
    v_nombre_destino AEROPUERTOS.NOMBRE%TYPE;

BEGIN
    SELECT NOMBRE INTO v_nombre_destino
    FROM AEROPUERTOS
    WHERE CODAEROPUERTO=(SELECT CODAEROPUERTODESTINO
                         FROM VUELOS
                         WHERE CODVUELO=p_cod_vuelo);
    RETURN v_nombre_destino;
END;
/


-- PASAJEROS        NUMBULTOS  PESOEQUIPAJE --

--- Función para devolver NOMBRE PASAJERO

CREATE OR REPLACE FUNCTION devolver_nombre_pasajero (p_num_pasaporte PASAJEROSEMBARCADOS.NUMPASAPORTE%TYPE)
RETURN VARCHAR2
IS
    v_nombre PASAJEROS.NOMBRE%TYPE;

BEGIN
    SELECT NOMBRE INTO v_nombre
    FROM PASAJEROS
    WHERE NUMPASAPORTE=p_num_pasaporte;
    RETURN v_nombre;
END;
/


--- Procedimiento para LISTAR PASAJEROS

CREATE OR REPLACE PROCEDURE listar_pasajeros (p_cod_vuelo PASAJEROSEMBARCADOS.CODVUELO%TYPE, p_fecha PASAJEROSEMBARCADOS.FECHA%TYPE)
IS
    CURSOR c_listar_pasajeros IS
    SELECT *
    FROM PASAJEROSEMBARCADOS
    WHERE CODVUELO=p_cod_vuelo AND FECHA=p_fecha;
BEGIN
    FOR i in c_listar_pasajeros LOOP
    dbms_output.put_line(devolver_nombre_pasajero(i.NUMPASAPORTE)||'  '||chr(9)||chr(9)||i.NUMBULTOS||chr(9)||i.PESOEQUIPAJE);
    END LOOP;
END;
/


-- PORCENTAJE OCUPACION ASIENTOS        TOTAL PESO EQUIPAJES --

--- Función para DEVOLVER NUMERO DE ASIENTOS


CREATE OR REPLACE FUNCTION devolver_num_asientos (p_cod_vuelo PASAJEROSEMBARCADOS.CODVUELO%TYPE, p_fecha PASAJEROSEMBARCADOS.FECHA%TYPE)
RETURN NUMBER
IS
    v_num_asientos MODELOS.NUMEROASIENTOS%TYPE;
BEGIN
    SELECT NUMEROASIENTOS INTO v_num_asientos
    FROM MODELOS
    WHERE NOMBRE=(SELECT NOMBREMODELO 
                  FROM AERONAVES 
                  WHERE NUMSERIE=(SELECT NUMSERIEAERONAVE 
                                  FROM VIAJES 
                                  WHERE CODVUELO=p_cod_vuelo AND FECHA=p_fecha ));
    RETURN v_num_asientos;
END;
/


--- Función para DEVOLVER NUMERO DE PASAJEROS

CREATE OR REPLACE FUNCTION devolver_num_pasajeros (p_cod_vuelo PASAJEROSEMBARCADOS.CODVUELO%TYPE, p_fecha PASAJEROSEMBARCADOS.FECHA%TYPE)
RETURN NUMBER
IS
    v_total_pasajeros NUMBER;
BEGIN
    SELECT count(NUMPASAPORTE) INTO v_total_pasajeros
    FROM PASAJEROSEMBARCADOS
    WHERE CODVUELO=p_cod_vuelo AND FECHA=p_fecha;
    RETURN v_total_pasajeros;
END;
/


--- Función para DEVOLVER cálculo de PORCENTAJE

CREATE OR REPLACE FUNCTION calcular_porcentaje (p_cod_vuelo PASAJEROSEMBARCADOS.CODVUELO%TYPE, p_fecha PASAJEROSEMBARCADOS.FECHA%TYPE)
RETURN NUMBER
IS
    v_porcentaje NUMBER;
    v_num_asientos NUMBER;
    v_num_pasajeros NUMBER;
BEGIN
    v_num_asientos:=devolver_num_asientos(p_cod_vuelo,p_fecha);
    v_num_pasajeros:=devolver_num_pasajeros(p_cod_vuelo,p_fecha);
    v_porcentaje:=v_num_pasajeros*100/v_num_asientos;
    RETURN v_porcentaje;
END;
/


--- Función para DEVOLVER PESTO TOTAL EQUIPAJES

CREATE OR REPLACE FUNCTION devolver_peso_equipajes (p_cod_vuelo PASAJEROSEMBARCADOS.CODVUELO%TYPE, p_fecha PASAJEROSEMBARCADOS.FECHA%TYPE)
RETURN NUMBER
IS
    v_total_peso NUMBER;
BEGIN
    SELECT sum(PESOEQUIPAJE) INTO v_total_peso
    FROM PASAJEROSEMBARCADOS
    WHERE CODVUELO=p_cod_vuelo AND FECHA=p_fecha;
    RETURN v_total_peso;
END;
/


-- Procedimiento para LISTAR PORCENTAJE-TOTALPESO 

CREATE OR REPLACE PROCEDURE listar_porcentaje_TotalPeso (p_cod_vuelo PASAJEROSEMBARCADOS.CODVUELO%TYPE, p_fecha PASAJEROSEMBARCADOS.FECHA%TYPE)
IS
BEGIN
    dbms_output.put_line(chr(10)||'Porcentaje Ocupacion Asientos: '||ROUND(calcular_porcentaje(p_cod_vuelo,p_fecha), 2)||'%'||chr(9)||'Total Peso Equipajes: '||devolver_peso_equipajes(p_cod_vuelo,p_fecha)||'kg');
END;
/


--- Procedimiento para MOSTRAR INFORME 1

CREATE OR REPLACE PROCEDURE informe1 (p_cod_vuelo VIAJES.CODVUELO%TYPE, p_fecha VIAJES.FECHA%TYPE)
IS
BEGIN
    dbms_output.put_line(chr(10)||'Fecha: '||p_fecha||chr(9)||chr(9)||'Hora: '||devolver_hora(p_cod_vuelo)||chr(10)||chr(10)||'Codigo de Vuelo: '||p_cod_vuelo||chr(9)||devolver_nom_aeropuerto_origen(p_cod_vuelo)||'-'||devolver_nom_aeropuerto_destino(p_cod_vuelo)||chr(10));
    listar_pasajeros(p_cod_vuelo,p_fecha);
    listar_porcentaje_TotalPeso(p_cod_vuelo,p_fecha);
END;
/

-- Comprobación informe1

exec informe1('IB-3949',TO_DATE('26/09/2016', 'DD/MM/YYYY'));


-------------------------------------------------------------------------





