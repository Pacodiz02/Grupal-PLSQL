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


--- Procedimiento para listar FECHA-HORA-CODVUELO-AEORIGEN-AEDESTINO

CREATE OR REPLACE PROCEDURE listar_cabecera (p_cod_vuelo VIAJES.CODVUELO%TYPE, p_fecha VIAJES.FECHA%TYPE)
IS
BEGIN
    dbms_output.put_line(chr(10)||'Fecha: '||p_fecha||chr(9)||chr(9)||'Hora: '||devolver_hora(p_cod_vuelo)||chr(10)||chr(10)||'Codigo de Vuelo: '||p_cod_vuelo||chr(9)||devolver_nom_aeropuerto_origen(p_cod_vuelo)||'-'||devolver_nom_aeropuerto_destino(p_cod_vuelo)||chr(10));
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
    dbms_output.put_line(devolver_nombre_pasajero(i.NUMPASAPORTE)||chr(9)||chr(9)||i.NUMBULTOS||chr(9)||chr(9)||chr(9)||chr(9)||i.PESOEQUIPAJE||'kg');
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
    listar_cabecera(p_cod_vuelo,p_fecha);
    listar_pasajeros(p_cod_vuelo,p_fecha);
    listar_porcentaje_TotalPeso(p_cod_vuelo,p_fecha);
END;
/

-- Comprobación informe1

exec informe1('IB-3949',TO_DATE('26/09/2016', 'DD/MM/YYYY'));



-------------------------------------------------------------------------
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

SET SERVEROUTPUT ON;

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
        dbms_output.put_line(chr(10)||'Codigo de Vuelo: '||i.CODVUELO||chr(9)||devolver_nom_aeropuerto_origen(i.CODVUELO)||'-'||devolver_nom_aeropuerto_destino(i.CODVUELO)||chr(10));
        listar_pasajeros(i.CODVUELO,p_fecha);
        listar_porcentaje_TotalPeso(i.CODVUELO,p_fecha);
    END LOOP;
END;
/



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


--- Procedimiento para listar Porcentaje Medio y Peso de una Aeronave

CREATE OR REPLACE PROCEDURE listar_PMedio_TPesoAeronave (p_numserie AERONAVES.NUMSERIE%TYPE,p_fecha VIAJES.FECHA%TYPE)
IS
BEGIN
    dbms_output.put_line('Porcentaje Medio Ocupación Aeronave '||p_numserie||' : '||devolver_PMedioOcupacion(p_numserie,p_fecha)||'%'||chr(9)||chr(9)||'Total Peso Equipajes Aeronave '||p_numserie||' : '||devolver_TotalEquipajes(p_numserie,p_fecha)||'kg'||chr(10));
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
-------------------------------------------------------------------------

--Informe Tipo 3: El segundo parámetro será el nombre de un módelo de avión y el tercero una fecha.Se mostrará información de todos los vuelos realizados por las aeronaves de ese modelo en el mes correspondiente a la fecha recibida como parámetro con el siguiente formato:

--    Modelo: xxxxxxxxxxxx   Compañía Constructora: xxxxxxxxxxx  Capacidad: nnn pasajeros.
--      Aeronave: NumSerieAeronave  FechaFabricación  FechaÚltimaRevisión
--      Mes: xxxxxxxxxx
--        Código de Vuelo1: xxxxxxxxx  AeropuertoOrigen-AeropuertoDestino
--        
--        NombrePasajero1              NúmeroBultos1 PesoEquipaje1
--        …
--        NombrePasajeroN              NúmeroBultosN PesoEquipajeN
-- 
--        Porcentaje Ocupación Asientos: nn,n%  Total Peso Equipajes1: n,nnn
--        Código de Vuelo2: xxxxxxxxx       AeropuertoOrigen-AeropuertoDestino
--        …
--        
--      Porcentaje Medio Ocupación Aeronave xxxxxxxx: nn,n% Total Peso Equipajes Aeronave xxxxxxx: nnn,nnn
--        
--      Aeronave: NumSerieAeronave    FechaFabricación    FechaÚltimaRevisión
--      …
--    Número Total de Pasajeros Transportados: n,nnn,nnn


-------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON;


--- Función que metes un NOMBRE de un MODELO y DEVUELVE su COMPAÑIA CONSTRUCTORA

CREATE OR REPLACE FUNCTION devolver_compania (p_nombre MODELOS.NOMBRE%TYPE)
RETURN VARCHAR2
IS
    v_compania MODELOS.COMPANIACONSTRUCTORA%TYPE;
BEGIN
    SELECT COMPANIACONSTRUCTORA INTO v_compania
    FROM MODELOS
    WHERE NOMBRE=p_nombre;
    RETURN v_compania;
END;
/


--- Función que DEVUELVE la CAPACIDAD de un MODELO(Número de asientos)

CREATE OR REPLACE FUNCTION devolver_capacidad(p_nombre MODELOS.NOMBRE%TYPE)
RETURN NUMBER
IS
    v_capacidad MODELOS.NUMEROASIENTOS%TYPE;
BEGIN
    SELECT NUMEROASIENTOS INTO v_capacidad
    FROM MODELOS
    WHERE NOMBRE=p_nombre;
    RETURN v_capacidad;
END;
/


--- Procedimiento para listar aeronaves

CREATE OR REPLACE PROCEDURE listar_info_mod(p_nombre MODELOS.NOMBRE%TYPE)
IS
BEGIN
    dbms_output.put_line(chr(10)||'Modelo: '||p_nombre||chr(9)||chr(9)||'Compañía Constructora: '||devolver_compania(p_nombre)||chr(9)||chr(9)||'Capacidad: '||devolver_capacidad(p_nombre)||chr(10));
END;
/


--- Procedimiento para listar aeronaves de un modelo

CREATE OR REPLACE PROCEDURE listar_aeronave_modelo (p_nombre MODELOS.NOMBRE%TYPE, p_fecha VIAJES.FECHA%TYPE)
IS
    CURSOR c_listar_aeronave_m IS
    SELECT DISTINCT NUMSERIEAERONAVE
    FROM VIAJES
    WHERE FECHA=p_fecha AND NUMSERIEAERONAVE IN(SELECT NUMSERIE
                                              FROM AERONAVES
                                              WHERE NOMBREMODELO=p_nombre);
BEGIN
    FOR i IN c_listar_aeronave_m LOOP
        listar_aeronave (i.NUMSERIEAERONAVE);
        dbms_output.put_line('Mes: '||TO_CHAR(p_fecha, 'MONTH'));
        listar_vuelos(i.NUMSERIEAERONAVE,p_fecha);
        listar_PMedio_TPesoAeronave(i.NUMSERIEAERONAVE,p_fecha);
    END LOOP;
END;
/


--- Función que metes un NUMEROSERIE de una AERONAVE y fecha y DEVUELVE el total pasajeros embarcados

CREATE OR REPLACE FUNCTION devolver_Tpasajeros_aeronave (p_numserie VIAJES.NUMSERIEAERONAVE%TYPE, p_fecha VIAJES.FECHA%TYPE)
RETURN NUMBER
IS
    v_Tpasajeros_aeronave NUMBER;
BEGIN
    SELECT COUNT(NUMPASAPORTE) INTO v_Tpasajeros_aeronave
    FROM PASAJEROSEMBARCADOS
    WHERE FECHA=p_fecha AND CODVUELO IN(SELECT CODVUELO
                                      FROM VIAJES
                                      WHERE FECHA=p_fecha AND NUMSERIEAERONAVE=p_numserie);
    RETURN v_Tpasajeros_aeronave;
END;
/


--- Función que metes un NOMBRE de un MODELO y fecha y DEVUELVE el total pasajeros embarcados

CREATE OR REPLACE FUNCTION devolver_Tpasajeros_modelo (p_nombre MODELOS.NOMBRE%TYPE, p_fecha VIAJES.FECHA%TYPE)
RETURN NUMBER
IS
    v_acum NUMBER:=0;
    v_Tpasajeros NUMBER:=0;
    CURSOR c_dev_Tpasajeros IS
    SELECT  DISTINCT NUMSERIEAERONAVE, FECHA
    FROM VIAJES
    WHERE FECHA=p_fecha AND NUMSERIEAERONAVE IN(SELECT DISTINCT NUMSERIE
                                                FROM AERONAVES
                                                WHERE NOMBREMODELO=p_nombre);
BEGIN
    FOR i IN c_dev_Tpasajeros LOOP
        v_Tpasajeros:=devolver_Tpasajeros_aeronave(i.NUMSERIEAERONAVE,p_fecha);
        v_acum:=v_acum+v_Tpasajeros;
    END LOOP;
    RETURN v_acum;
END;
/


--- Procedimiento para listar Total de Pasajeros que transporta un determinado modelo.

CREATE OR REPLACE PROCEDURE listar_Tpasajeros_modelo(p_nombre MODELOS.NOMBRE%TYPE, p_fecha VIAJES.FECHA%TYPE)
IS
BEGIN
    dbms_output.put_line('Numero Total de Pasajeros Transportados: '||devolver_Tpasajeros_modelo(p_nombre,p_fecha));
END;
/


--- Procedimiento para MOSTRAR INFORME 3

CREATE OR REPLACE PROCEDURE informe3 (p_nombre MODELOS.NOMBRE%TYPE, p_fecha VIAJES.FECHA%TYPE)
IS
BEGIN
    listar_info_mod(p_nombre);
    listar_aeronave_modelo(p_nombre,p_fecha);
    listar_Tpasajeros_modelo(p_nombre,p_fecha);
END;
/

-- Comprobación:

INSERT INTO VIAJES VALUES (
    TO_DATE('26/09/2016', 'DD/MM/YYYY'),
    'AF-1149',
    'D-AIPM'
);

INSERT INTO PASAJEROSEMBARCADOS VALUES (
    'DWQ000879',
    'AF-1149',
    TO_DATE('26/09/2016', 'DD/MM/YYYY'),
    2,
    23.05
);

INSERT INTO PASAJEROSEMBARCADOS VALUES (
    'ERT000919',
    'AF-1149',
    TO_DATE('26/09/2016', 'DD/MM/YYYY'),
    1,
    5.55
);

INSERT INTO PASAJEROSEMBARCADOS VALUES (
    'FHJ456123',
    'AF-1149',
    TO_DATE('26/09/2016', 'DD/MM/YYYY'),
    2,
    7.69
);

exec informe3('A320',TO_DATE('26/09/2016', 'DD/MM/YYYY'));


-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------


----------------------------------PROCEDIMIENTO-PRINCIPAL----------------------------------

SET SERVEROUTPUT ON;


--- Procedimiento que muestra los 3 tipos de informes dependiendo del segundo parámetro y la fecha que pongamos.

CREATE OR REPLACE PROCEDURE mostrar_informes (p_tipo NUMBER, p_2 VARCHAR2, p_fecha DATE)
IS
BEGIN
    IF p_tipo = 1 THEN
        informe1(p_2,p_fecha);
    ELSIF p_tipo = 2 THEN
        informe2(p_2,p_fecha);
    ELSIF p_tipo = 3 THEN
        informe3(p_2,p_fecha);
    END IF;
END;
/


-- Comprobaciones mostrar_informes:

-- Informe1 (Tipo_informe,CodVuelo,Fecha)

exec mostrar_informes(1,'IB-3949',TO_DATE('26/09/2016', 'DD/MM/YYYY'));


-- Informe2 (Tipo_informe,NumSerie,Fecha)

exec mostrar_informes(2,'F-GHQC',TO_DATE('26/09/2016', 'DD/MM/YYYY'));


-- Informe3 (Tipo_informe,NombreModelo,Fecha)

exec mostrar_informes(3,'A320',TO_DATE('26/09/2016', 'DD/MM/YYYY'));


