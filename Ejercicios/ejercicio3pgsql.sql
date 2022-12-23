-- ✒️ **Ejercicio hecho por Alejandro Montes Delgado.**
--EJERCICIO 3 PL/PGSQL

--FUNCION QUE OBTIENE LA AUTONOMÍA DEL NUEVO VIAJE QUE AÑADIMOS A LA TABLA
--Y SI LA DISTANCIA MAS UN 25% ES MAYOR QUE LA AUTONOMÍA SALE EL RAISE.
CREATE OR REPLACE FUNCTION F_AUTONOMIA()
RETURNS TRIGGER AS
$$
DECLARE

    VN_AUTONOMIA MODELOS.AUTONOMIA%TYPE;

BEGIN

    SELECT AUTONOMIA INTO VN_AUTONOMIA
    FROM MODELOS
    WHERE NOMBRE IN ( SELECT NOMBREMODELO
                      FROM AERONAVES
                      WHERE NUMSERIE IN ( SELECT NUMSERIEAERONAVE
                                          FROM VIAJES 
                                          WHERE CODVUELO = NEW.CODVUELO ) );
    IF NEW.DISTANCIA * 1.25 > VN_AUTONOMIA THEN
        RAISE EXCEPTION 'El avión no tiene suficiente autonomía para el viaje.';
    END IF;
    RETURN NEW;

END;
$$
LANGUAGE plpgsql;


--TRIGGER QUE SE EJECUTA POR CADA FILA AL INSERTAR O ACTUALIZAR LA TABLA VUELOS.
CREATE TRIGGER T_AUTONOMIA 
BEFORE INSERT OR UPDATE ON VUELOS
FOR EACH ROW
EXECUTE PROCEDURE F_AUTONOMIA();

--PRUEBAS

--ESTE INSERT FUNCIONA.
INSERT INTO VUELOS VALUES (
    'UX-6013',
    'PMI',
    'MAD',
    'Air Europa',
    'Jueves',
    TO_TIMESTAMP('10:15', 'HH24:MI'),
    'EJK000333',
    'HYJ000568',
    TO_TIMESTAMP('01:30','HH24:MI'),
     782
);
--EN ESTE INSERT SE PRODUCE EL ERROR.
INSERT INTO VUELOS VALUES (
    'UX-6013',
    'PMI',
    'MAD',
    'Air Europa',
    'Jueves',
    TO_TIMESTAMP('10:15', 'HH24:MI'),
    'EJK000333',
    'HYJ000568',
    TO_TIMESTAMP('01:30','HH24:MI'),
     7820
);