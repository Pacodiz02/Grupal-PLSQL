1. Realiza una función que reciba como parámetros el Número de Pasaporte de un miembro del
Personal y una fecha y devuelva el código del vuelo en el que estaba trabajando en dicha
fecha. Debes controlar las siguientes excepciones: Empleado Inexistente, Fecha sin viajes,
Empleado sin vuelo asignado.


2. Realiza un procedimiento que nos proporcione diferentes listados acerca de los viajes
realizados gestionando las excepciones que consideres oportunas. El primer parámetro
determinará el tipo de informe.

Informe Tipo 1: El segundo parámetro será un código de vuelo y el tercero una fecha. Se
mostrará la siguiente información:

    Fecha: dd/mm/yyyy        Hora: hh:mm

    Código de Vuelo: xxxxxxxxx    AeropuertoOrigen-AeropuertoDestino

      NombrePasajero1            NúmeroBultos1   PesoEquipaje1
      …
      NombrePasajeroN          NúmeroBultosN     PesoEquipajeN
    
    Porcentaje Ocupación Asientos: nn,n%     Total Peso Equipajes: n,nnn


Informe Tipo 2: El segundo parámetro será el número de serie de una aeronave y el tercero
una fecha. Se mostrará información de todos los vuelos realizados por esa aeronave en el
mes correspondiente a la fecha recibida como parámetro con el siguiente formato:


    Aeronave: NumSerieAeronave  FechaFabricación  FechaÚltimaRevisión

    Mes: xxxxxxxxxx

      Código de Vuelo1: xxxxxxxxx  AeropuertoOrigen-AeropuertoDestino
    
        NombrePasajero1          NúmeroBultos1 PesoEquipaje1
        …
        NombrePasajeroN          NúmeroBultosN PesoEquipajeN

      Porcentaje Ocupación Asientos1: nn,n%   Total Peso Equipajes1: n,nnn
    
      Código de Vuelo2: xxxxxxxxx          AeropuertoOrigen-AeropuertoDestino
      …
  
    Porcentaje Medio Ocupación Aeronave xxxxxxxx: nn,n%    Total Peso Equipajes Aeronave xxxxxxx: nnn,nnn
    
    
Informe Tipo 3: El segundo parámetro será el nombre de un módelo de avión y el tercero una
fecha.Se mostrará información de todos los vuelos realizados por las aeronaves de ese
modelo en el mes correspondiente a la fecha recibida como parámetro con el siguiente
formato:

    Modelo: xxxxxxxxxxxx   Compañía Constructora: xxxxxxxxxxx  Capacidad: nnn pasajeros.
      Aeronave: NumSerieAeronave  FechaFabricación  FechaÚltimaRevisión
      Mes: xxxxxxxxxx
        Código de Vuelo1: xxxxxxxxx  AeropuertoOrigen-AeropuertoDestino
        
        NombrePasajero1              NúmeroBultos1 PesoEquipaje1
        …
        NombrePasajeroN              NúmeroBultosN PesoEquipajeN
 
        Porcentaje Ocupación Asientos: nn,n%  Total Peso Equipajes1: n,nnn
        Código de Vuelo2: xxxxxxxxx       AeropuertoOrigen-AeropuertoDestino
        …
        
      Porcentaje Medio Ocupación Aeronave xxxxxxxx: nn,n% Total Peso Equipajes Aeronave xxxxxxx: nnn,nnn
        
      Aeronave: NumSerieAeronave    FechaFabricación    FechaÚltimaRevisión
      …
    Número Total de Pasajeros Transportados: n,nnn,nnn
    
    
3. Añade dos columnas llamadas Distancia y Duración (en formato hh:mi) a la tabla
Vuelos y rellénalas adecuadamente. Realiza un trigger que garantice que un avión
asignado a un viaje tenga una autonomía superior al menos en un 25% a la distancia
a recorrer.


4. Añade una columna eMail a la tabla Auxiliares. Realiza un trigger que envíe un correo
electrónico informativo a los auxiliares de vuelo cada vez que se les asigna un viaje,
informándoles de la ciudad de origen, la fecha, el código de vuelo y los nombres de
piloto y copiloto.


5. Rellena las columnas HorasdeVuelo de la tabla Aeronaves mediante un procedimiento
con los datos existentes en las tablas Vuelos y Viajes. Realiza un trigger que la
mantenga actualizada automáticamente ante cualquier cambio en la base de datos.


6. Realiza los módulos de programación necesarios para garantizar que un piloto no
realiza más de seis vuelos de 10 horas o más a lo largo de un mes natural.


7. Realiza los módulos de programación necesarios para garantizar que una misma
compañía no tiene más de dos vuelos con el mismo origen y destino en un mismo día
de la semana.


8. Realiza los módulos de programación necesarios para garantizar que el número de
auxiliares de vuelo en un viaje es de al menos uno por cada 5 pasajeros que realizan
ese viaje.
