-- ✒️ **Ejercicio hecho por Paco Diz Ureña**

-- Ejercicio 2

-- Realiza un procedimiento que nos proporcione diferentes listados acerca de los viajes realizados gestionando las excepciones que consideres oportunas. El primer parámetro determinará el tipo de informe.


-- Informe Tipo 1: El segundo parámetro será un código de vuelo y el tercero una fecha. Se mostrará la siguiente información:

-- Fecha: dd/mm/yyyy        Hora: hh:mm

-- Código de Vuelo: xxxxxxxxx       AeropuertoOrigen-AeropuertoDestino

    -- NombrePasajero1                  NúmeroBultos1   PesoEquipaje1

    -- …

-- Porcentaje Ocupación Asientos: nn,n%     Total Peso Equipajes: n,nnn

-------------------------------------------------------------------------------------------

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
    SELECT NUMPASAPORTE, NUMBULTOS, PESOEQUIPAJE
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

SELECT NUMPASAPORTE
FROM PASAJEROSEMBARCADOS
WHERE CODVUELO='IB-3949' AND FECHA=TO_DATE('26/09/2016', 'DD/MM/YYYY');


SELECT devolver_num_pasajeros('IB-3949',TO_DATE('26/09/2016', 'DD/MM/YYYY')) FROM DUAL;

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
    v_porcentaje:=(v_num_pasajeros/v_num_asientos)*100;
    RETURN v_porcentaje;
END;
/

SELECT calcular_porcentaje('IB-3949',TO_DATE('26/09/2016', 'DD/MM/YYYY')) FROM DUAL;

--- Función para DEVOLVER PESO TOTAL EQUIPAJES

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
    dbms_output.put_line(chr(10)||'Porcentaje Ocupacion Asientos: '||ROUND(calcular_porcentaje(p_cod_vuelo,p_fecha), 2)||'%'||chr(9)||chr(9)||'Total Peso Equipajes: '||devolver_peso_equipajes(p_cod_vuelo,p_fecha)||'kg'||chr(10));
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

-- Informe Tipo 2: El segundo parámetro será el número de serie de una aeronave y el tercero una fecha. Se mostrará información de todos los vuelos realizados por esa aeronave en el mes correspondiente a la fecha recibida como parámetro con el siguiente formato:

--    Aeronave: NumSerieAeronave  FechaFabricación  FechaÚltimaRevisión

--    Mes: xxxxxxxxxx

--      Código de Vuelo1: xxxxxxxxx  AeropuertoOrigen-AeropuertoDestino
    
--        NombrePasajero1          NúmeroBultos1 PesoEquipaje1
--        …
--        NombrePasajeroN          NúmeroBultosN PesoEquipajeN

--      Porcentaje Ocupación Asientos1: nn,n%   Total Peso Equipajes1: n,nnn
    
--      Código de Vuelo2: xxxxxxxxx          AeropuertoOrigen-AeropuertoDestino
--      …
  
--    Porcentaje Medio Ocupación Aeronave xxxxxxxx: nn,n%    Total Peso Equipajes Aeronave xxxxxxx: nnn,nnn


-------------------------------------------------------------------------------------------

-- Aeronave: NUMSERIEAERONAVE        FechaFabricación        FechaÚltimaRevisión --

--- Procedimiento que LISTA INFORMACIÓN de la AERONAVE

CREATE OR REPLACE PROCEDURE listar_aeronave (p_numserie AERONAVES.NUMSERIE%TYPE)
IS
    CURSOR c_listar_aeronave IS
    SELECT FECHAFABRICACION, FECHAULTIMAREVISION
    FROM AERONAVES
    WHERE NUMSERIE=p_numserie;
BEGIN
    FOR i IN c_listar_aeronave LOOP
        dbms_output.put_line(chr(10)||'Aeronave: '||p_numserie||chr(9)||'FechaFabricacion: '||i.FECHAFABRICACION||chr(9)||'FechaUltimaRevision: '||i.FECHAULTIMAREVISION);
    END LOOP;
END;
/


--- Procedimiento que LISTA los VUELOS de CADA AERONAVE(Vuelo-Pasajeros-Porcentaje)

CREATE OR REPLACE PROCEDURE listar_vuelos (p_numserie VIAJES.NUMSERIEAERONAVE%TYPE, p_fecha VIAJES.FECHA%TYPE)
IS
    CURSOR c_listar_vuelos IS
    SELECT CODVUELO
    FROM VIAJES
    WHERE NUMSERIEAERONAVE=p_numserie AND FECHA=p_fecha;
BEGIN
    FOR i IN c_listar_vuelos LOOP
        dbms_output.put_line('Codigo de Vuelo: '||i.CODVUELO||chr(9)||devolver_nom_aeropuerto_origen(i.CODVUELO)||'-'||devolver_nom_aeropuerto_destino(i.CODVUELO)||chr(10));
        listar_pasajeros(i.CODVUELO,p_fecha);
        listar_porcentaje_TotalPeso(i.CODVUELO,p_fecha);
    END LOOP;
END;
/

SELECT CODVUELO
FROM VIAJES
WHERE FECHA=TO_DATE('26/09/2016', 'DD/MM/YYYY') AND NUMSERIEAERONAVE='F-GHQC';
exec informe2('F-GHQC',TO_DATE('26/09/2016', 'DD/MM/YYYY'));

------------------------------------------------------------------------------------

-- Porcentaje Medio Ocupación Aeronave              Total Peso Equipajes Aeronave --

--- Función que DEVUELVE el NUMERO de VUELOS que ha realizado UNA AERONAVE

CREATE OR REPLACE FUNCTION devolver_num_vuelos (p_numserie VIAJES.NUMSERIEAERONAVE%TYPE,p_fecha VIAJES.FECHA%TYPE)
RETURN NUMBER
IS
    v_total_vuelos NUMBER;
BEGIN
    SELECT count(CODVUELO) INTO v_total_vuelos
    FROM VIAJES
    WHERE NUMSERIEAERONAVE=p_numserie AND FECHA=p_fecha;
    RETURN v_total_vuelos;
END;
/


--- Función que DEVUELVE el TOTAL de PORCENTAJES de una AERONAVE

CREATE OR REPLACE FUNCTION devolver_total_porcentajes (p_numserie VIAJES.NUMSERIEAERONAVE%TYPE,p_fecha VIAJES.FECHA%TYPE)
RETURN NUMBER
IS
    v_acumulador NUMBER:=0;
    v_porcentaje NUMBER:=0;
    CURSOR c_porcentaje_total IS
    SELECT FECHA,CODVUELO
    FROM VIAJES
    WHERE NUMSERIEAERONAVE=p_numserie AND FECHA=p_fecha;
BEGIN
    FOR i IN c_porcentaje_total LOOP
        v_porcentaje:=calcular_porcentaje(i.CODVUELO,i.FECHA);
        v_acumulador:=v_acumulador+v_porcentaje;
    END LOOP;
    RETURN ROUND(v_acumulador,2);
END;
/


--- Función que DEVUELVE PORCENTAJE MEDIO OCUPACION

CREATE OR REPLACE FUNCTION devolver_PMedioOcupacion (p_numserie VIAJES.NUMSERIEAERONAVE%TYPE,p_fecha VIAJES.FECHA%TYPE)
RETURN NUMBER
IS
    v_media NUMBER;
BEGIN
    v_media:=devolver_total_porcentajes(p_numserie,p_fecha)/devolver_num_vuelos(p_numserie,p_fecha);
    RETURN v_media;
END;
/

SELECT devolver_PMedioOcupacion('F-GHQC',TO_DATE('26/09/2016', 'DD/MM/YYYY')) FROM DUAL;
SELECT devolver_PMedioOcupacion('F-GHQC',TO_DATE('17/10/2016', 'DD/MM/YYYY')) FROM DUAL;



--- Función que DEVUELVE el TOTAL PESO EQUIPAJES AERONAVE

CREATE OR REPLACE FUNCTION devolver_TotalEquipajes (p_numserie VIAJES.NUMSERIEAERONAVE%TYPE,p_fecha VIAJES.FECHA%TYPE)
RETURN NUMBER
IS
    v_acumulador NUMBER:=0;
    v_peso NUMBER:=0;
    CURSOR c_peso_total IS
    SELECT FECHA,CODVUELO
    FROM VIAJES
    WHERE NUMSERIEAERONAVE=p_numserie AND FECHA=p_fecha;
BEGIN
    FOR i IN c_peso_total LOOP
        v_peso:=devolver_peso_equipajes(i.CODVUELO,i.FECHA);
        v_acumulador:=v_acumulador+v_peso;
    END LOOP;
    RETURN v_acumulador;
END;
/

SELECT devolver_TotalEquipajes('F-GHQC',TO_DATE('26/09/2016', 'DD/MM/YYYY')) FROM DUAL;


CREATE OR REPLACE PROCEDURE listar_PMedio_TPesoAeronave (p_numserie AERONAVES.NUMSERIE%TYPE,p_fecha VIAJES.FECHA%TYPE)
IS
BEGIN
    dbms_output.put_line('Porcentaje Medio Ocupación Aeronave '||p_numserie||' : '||devolver_PMedioOcupacion(p_numserie,p_fecha)||'%'||chr(9)||chr(9)||'Total Peso Equipajes Aeronave '||p_numserie||' : '||devolver_TotalEquipajes(p_numserie,p_fecha)||'kg');
END;
/


--- Procedimiento para MOSTRAR INFORME 2

CREATE OR REPLACE PROCEDURE informe2 (p_numserie AERONAVES.NUMSERIE%TYPE, p_fecha VIAJES.FECHA%TYPE)
IS
BEGIN
    listar_aeronave (p_numserie);
    dbms_output.put_line('Mes: '||TO_CHAR(p_fecha, 'MONTH'));
    listar_vuelos(p_numserie,p_fecha);
    listar_PMedio_TPesoAeronave(p_numserie,p_fecha);
END;
/

-- Comprobación:

--- Para la comprobación necesitaremos añadir los siguientes inserts

INSERT INTO VIAJES VALUES (
    TO_DATE('26/09/2016', 'DD/MM/YYYY'),
    'IB-5940',
    'F-GHQC'
);

INSERT INTO PASAJEROSEMBARCADOS VALUES (
    'GGG000555',
    'IB-5940',
    TO_DATE('26/09/2016', 'DD/MM/YYYY'),
    1,
    6.66
);

INSERT INTO PASAJEROSEMBARCADOS VALUES (
    'HKL000333',
    'IB-5940',
    TO_DATE('26/09/2016', 'DD/MM/YYYY'),
    2,
    15.78
);

INSERT INTO PASAJEROSEMBARCADOS VALUES (
    'IRT000444',
    'IB-5940',
    TO_DATE('26/09/2016', 'DD/MM/YYYY'),
    1,
    9.21
);

exec informe2('F-GHQC',TO_DATE('26/09/2016', 'DD/MM/YYYY'));


-------------------------------------------------------------------------

