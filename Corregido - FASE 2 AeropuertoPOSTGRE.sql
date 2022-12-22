-- ✒️ **Script revisado y corregido por Juan Jesús Alejo Sillero.**

--- Creación de tablas:

-- Tabla 1, personal:

create table personal (
    NumPasaporte varchar(9),
    Nombre varchar(35),
    Telefono varchar(9),
    Direccion varchar(55),
    FechaAlta date,
    SueldoBase numeric(6, 2),
    HorasExtra numeric(4),
    constraint pk_personal primary key (NumPasaporte),
    constraint pasaportepersonal check (NumPasaporte ~* '^[a-zA-Z]{3}[0-9]{6}'),
    constraint fechaaltaOK check (to_char(FechaAlta, 'D') != '1'),
    constraint telobligatorio check (Telefono is not null),
    constraint CandidateKey unique (Telefono)
);

insert into personal values (
'ABC123456',
    'Castillo Ruiz Nahum',
    '649364028',
    'Antonio Delgado Roig P3 N5, Sevilla España',
    to_date('05/01/2015', 'DD/MM/YYYY'),
    3500,
    315
);

insert into personal values (
    'AJC000153',
    'Clemente Cervantes Ricardo',
    '661401496',
    'Carrera Comercial 40, Sevilla España',
    to_date('03/02/2015', 'DD/MM/YYYY'),
    3000,
    220
);

insert into personal values (
    'AHC000120',
    'Del Toro Arreola David',
    '617456394',
    'Calle Ginebra 5, Madrid España',
    to_date('04/03/2015', 'DD/MM/YYYY'),
    2000,
    410
);

insert into personal values (
    'BFJ000171',
    'Estrada Torres Gilberto',
    '654674422',
    'Avenida de la Prensa 28, Madrid España',
    to_date('16/04/2015', 'DD/MM/YYYY'),
    1500,
    90
);

insert into personal values (
    'CRT000765',
    'Figueroa Valle Jorge Alberto',
    '654574888',
    'Cristo de la Sed 132, Barcelona España',
    to_date('01/05/2015', 'DD/MM/YYYY'),
    2000,
    170
);

insert into personal values (
    'CVF000126',
    'Franco Mota Ernesto',
    '635500878',
    'Fernando Zobel 13, Barcelona España',
    to_date('13/06/2015', 'DD/MM/YYYY'),
    4000,
    300
);

insert into personal values (
    'DSA000777',
    'Galindo Andrade Carlos',
    '654281239',
    'Avenida Republica Argentina, Sevilla España',
    to_date('18/07/2015', 'DD/MM/YYYY'),
    3800,
    512
);

insert into personal values (
    'EJK000333',
    'Garcia Campos J. Elias',
    '655657700',
    'Plaza San Agustin, Barcelona España',
    to_date('06/01/2015', 'DD/MM/YYYY'),
    3780,
    250
);

insert into personal values (
    'ECB000121',
    'Garcia Garcia Ivan',
    '654988601',
    'Avenida de los Pirralos 15, Madrid España',
    to_date('04/02/2015', 'DD/MM/YYYY'),
    2700,
    150
);

insert into personal values (
    'FHY000456',
    'Fernandez Martinez Jose',
    '655852528',
    'Luis Daoiz 15, Paris Francia',
    to_date('05/03/2015', 'DD/MM/YYYY'),
    3100,
    167
);

insert into personal values (
    'GBB000732',
    'Esquinca Gutierrez Jose Rodulfo',
    '655913815',
    'Avenida Andalucia 3, Paris Francia',
    to_date('17/04/2015', 'DD/MM/YYYY'),
    2600,
    70
);

insert into personal values (
    'HYJ000568',
    'Dzul Chi Cesar Isai',
    '655735347',
    'Avenida España 28, Paris Francia',
    to_date('02/05/2015', 'DD/MM/YYYY'),
    3200,
    210
);

select * from personal;

-- Tabla 2, pilotos:

create table pilotos (
    NumPasaporte varchar(9),
    constraint pk_pilotos primary key (NumPasaporte),
    constraint fk_pilotos foreign key (NumPasaporte) references personal (NumPasaporte),
    constraint pasaportepilotos check (NumPasaporte ~* '^[a-zA-Z]{3}[0-9]{6}')
);

insert into pilotos values ('CVF000126');

insert into pilotos values ('DSA000777');

insert into pilotos values ('EJK000333');

select * from pilotos;

-- Tabla 3, copilotos:

create table copilotos (
    NumPasaporte varchar(9),
    constraint pk_copilotos primary key (NumPasaporte),
    constraint fk_copilotos foreign key (NumPasaporte) references personal (NumPasaporte),
    constraint pasaportecopilotos check (NumPasaporte ~* '^[a-zA-Z]{3}[0-9]{6}')
);

insert into copilotos values (
    'ABC123456'
);

insert into copilotos values (
    'FHY000456'
);

insert into copilotos values (
    'HYJ000568'
);

select * from copilotos;

-- Tabla 4, auxiliares:

create table auxiliares (
    NumPasaporte varchar(9),
    constraint pk_auxiliares primary key (NumPasaporte),
    constraint fk_auxiliares foreign key (NumPasaporte) references personal (NumPasaporte),
    constraint pasaporteauxiliares check (NumPasaporte ~* '^[a-zA-Z]{3}[0-9]{6}')
);

insert into auxiliares values ('AJC000153');

insert into auxiliares values ('AHC000120');

insert into auxiliares values ('BFJ000171');

insert into auxiliares values ('CRT000765');

insert into auxiliares values ('ECB000121');

insert into auxiliares values ('GBB000732');

select * from auxiliares;

-- Tabla 5, pasajeros:

create table pasajeros (
    NumPasaporte varchar(9),
    Nombre varchar(30),
    constraint pk_pasajeros primary key (NumPasaporte),
    constraint pasaportepasajeros check (NumPasaporte ~* '^[a-zA-Z]{3}[0-9]{6}')
);

insert into pasajeros values ('AXN000888', 'De Leon Sanchez Juan de Dios');

insert into pasajeros values ('BCF174623', 'Delgado Bugarin Norma');

insert into pasajeros values ('CGB653132', 'Corona Ortiz Angel');

insert into pasajeros values ('DWQ000879', 'Chaim Camacho Oliver');

insert into pasajeros values ('ERT000919', 'Castro Sanchez Luis');

insert into pasajeros values ('FHJ456123', 'Castro Heredia Felizardo');

insert into pasajeros values ('GGG000555', 'Casas Garcia Gabriel');

insert into pasajeros values ('HKL000333', 'Casillas Gutierrez Olga');

insert into pasajeros values ('IRT000444', 'Carrera Molina Gonzalo');

insert into pasajeros values ('JYN000222', 'Campos Saito Jorge Alonso');

select * from pasajeros;

-- Tabla 6, aeropuertos:

create table aeropuertos (
    CodAeropuerto varchar(3),
    Nombre varchar(30),
    Direccion varchar(50),
    Telefono varchar(20),
    Director varchar(50),
    Ciudad varchar(25),
    NumPistas varchar(1) default 1,
    constraint pk_aeropuertos primary key (CodAeropuerto),
    constraint inicialesmayus check (Director = initcap(Director))
);

insert into aeropuertos values (
    'CDG',
    'Charles de Gaulle',
    '95700, Roissy-en-France, Francia',
    '+33 1 70 36 39 50',
    'Edward Arkwright',
    'Paris',
    4
);

insert into aeropuertos values (
    'PMI',
    'Son San Juan',
    '07611, Palma de Mallorca, España',
    '+34 902 40 47 04',
    'Jose Antonio Alvarez',
    'Palma de Mallorca',
    2
);

insert into aeropuertos values (
    'SVQ',
    'San Pablo',
    'A-4, Km. 532, 41020, Sevilla, España',
    '954 44 90 00',
    'Jesus Caballero Pinto',
    'Sevilla',
    1
);

insert into aeropuertos values (
    'MAD',
    'Adolfo Suarez',
    'Avda. de la Hispanidad s/n. 28042, Madrid, España',
    '902 404 704',
    'Elena Mayoral',
    'Madrid',
    4
);

insert into aeropuertos values (
    'BCN',
    'El Prat',
    '08820, El Prat de Llobregat, España',
    '902 40 47 04',
    'Sonia Corrochano',
    'Barcelona',
    3
);

insert into aeropuertos values (
    'TFS',
    'Reina Sofia',
    '38610, Santa Cruz de Tenerife, España',
    '922 392 037',
    'Santiago Yus Saenz',
    'Santa Cruz de Tenerife',
    1
);

select * from aeropuertos;

-- Tabla 7, vuelos:

create table vuelos (
    CodVuelo varchar(7),
    CodAeropuertoDestino varchar(3),
    CodAeropuertoOrigen varchar(3),
    Compania varchar(25),
    DiaSemana varchar(9),
    Hora time,
    NumPasaportePiloto varchar(9),
    NumPasaporteCopiloto varchar(9),
    constraint pk_vuelos primary key (CodVuelo),
    constraint fk_codaeropuertoorigen foreign key (CodAeropuertoOrigen) references aeropuertos (CodAeropuerto),
    constraint fk_codaeropuertodestino foreign key (CodAeropuertoDestino) references aeropuertos (CodAeropuerto),
    constraint fk_NumPasaportePiloto foreign key (NumPasaportePiloto) references pilotos (NumPasaporte),
    constraint fk_NumPasaporteCopiloto foreign key (NumPasaporteCopiloto) references copilotos (NumPasaporte),
    constraint codvueloOK check (CodVuelo ~* '^[a-zA-Z]{2}-[0-9]{3,4}'),
    constraint pasaportevuelospiloto check (NumPasaportePiloto ~* '^[a-zA-Z]{3}[0-9]{6}'),
    constraint pasaportevueloscopiloto check (NumPasaporteCopiloto ~* '^[a-zA-Z]{3}[0-9]{6}')
);

insert into vuelos values (
    'IB-3949',
    'MAD',
    'SVQ',
    'Iberia',
    'Lunes',
    '10:25',
    'DSA000777',
    'ABC123456'
);

insert into vuelos values (
    'IB-5940',
    'BCN',
    'SVQ',
    'Iberia',
    'Lunes',
    '09:20',
    'CVF000126',
    'FHY000456'
);

insert into vuelos values (
    'VY-3924',
    'PMI',
    'BCN',
    'Vueling',
    'Lunes',
    '09:05',
    'EJK000333',
    'HYJ000568'
);

insert into vuelos values (
    'AF-1149',
    'CDG',
    'BCN',
    'Air France',
    'Jueves',
    '09:50',
    'DSA000777',
    'ABC123456'
);

insert into vuelos values (
    'QR-3776',
    'TFS',
    'BCN',
    'Qatar Airways',
    'Jueves',
    '09:45',
    'CVF000126',
    'FHY000456'
);

insert into vuelos values (
    'UX-6013',
    'PMI',
    'MAD',
    'Air Europa',
    'Jueves',
    '10:15',
    'EJK000333',
    'HYJ000568'
);

select * from vuelos;

-- Tabla 8, modelos:

create table modelos (
    Nombre varchar(5),
    CompaniaConstructora varchar(20),
    NumMotores numeric(1),
    PotenciaMotores varchar(6),
    Autonomia numeric(5),
    NumeroAsientos numeric(3),
    Longitud numeric(4, 1),
    Envergadura numeric(3, 1),
    constraint pk_modelos primary key (Nombre),
    constraint compconstructora check (
        CompaniaConstructora in ('Airbus', 'Boeing', 'Mc''Donell Douglas')
    ),
    constraint longmax check (Longitud <= 100)
);

insert into modelos values ('A320', 'Airbus', 2, '326000', 5900, 180, 37.6, 34.1);

insert into modelos values ('A380', 'Airbus', 4, '400000', 15400, 469, 72.7, 79.8);

insert into modelos values ('747', 'Boeing', 4, '400000', 13450, 345, 70.9, 64.4);

insert into modelos values (
    'MD-90',
    'Mc''Donell Douglas',
    2,
    '326000',
    3860,
    160,
    46.5,
    32.7
);

select * from modelos;

-- Tabla 9, aeronaves:

create table aeronaves (
    NumSerie varchar(6),
    FechaFabricacion date,
    HorasdeVuelo numeric(6),
    FechaUltimaRevision date,
    NombreModelo varchar(15),
    constraint pk_aeronaves primary key (NumSerie),
    constraint fk_aeronaves foreign key (NombreModelo) references modelos (Nombre),
    constraint fecharevisionesOK check (
        (
            extract(
                day
                from (
                        date_trunc('month', FechaUltimaRevision) + '1month'::interval - '1day'::interval
                    )
            ) - extract(
                day
                from FechaUltimaRevision
            )
        ) <= 3
    )
);

insert into aeronaves values (
    'F-GHQC',
    to_date('15/02/1989', 'DD/MM/YYYY'),
    13668,
    to_date('29/12/2016', 'DD/MM/YYYY'),
    'A320'
);

insert into aeronaves values (
    'D-AIPM',
    to_date('13/02/1990', 'DD/MM/YYYY'),
    13435,
    to_date('31/01/2017', 'DD/MM/YYYY'),
    'A320'
);

insert into aeronaves values (
    'F-WWOW',
    to_date('27/04/2005', 'DD/MM/YYYY'),
    5876,
    to_date('25/02/2017', 'DD/MM/YYYY'),
    'A380'
);

insert into aeronaves values (
    'F-WWDD',
    to_date('18/10/2005', 'DD/MM/YYYY'),
    5230,
    to_date('26/02/2017', 'DD/MM/YYYY'),
    'A380'
);

insert into aeronaves values (
    'EP-NHT',
    to_date('24/09/1970', 'DD/MM/YYYY'),
    22589,
    to_date('27/02/2017', 'DD/MM/YYYY'),
    '747'
);

insert into aeronaves values (
    'S2-AFA',
    to_date('11/03/1970', 'DD/MM/YYYY'),
    23400,
    to_date('28/02/2017', 'DD/MM/YYYY'),
    '747'
);

insert into aeronaves values (
    'N918DH',
    to_date('01/08/1997', 'DD/MM/YYYY'),
    7121,
    to_date('28/02/2017', 'DD/MM/YYYY'),
    'MD-90'
);

insert into aeronaves values (
    'HZ-APH',
    to_date('01/02/1998', 'DD/MM/YYYY'),
    6854,
    to_date('26/02/2017', 'DD/MM/YYYY'),
    'MD-90'
);

select * from aeronaves;

-- Tabla 10, viajes:

create table viajes (
    Fecha date,
    CodVuelo varchar(7),
    NumSerieAeronave varchar(6),
    constraint pk_viajes primary key (Fecha, CodVuelo),
    constraint fk_viajesnumserie foreign key (NumSerieAeronave) references aeronaves (NumSerie)
);

insert into viajes values (
    to_date('26/09/2016', 'DD/MM/YYYY'),
    'IB-3949',
    'F-GHQC'
);

insert into viajes values (
    to_date('17/10/2016', 'DD/MM/YYYY'),
    'IB-3949',
    'F-GHQC'
);

insert into viajes values (
    to_date('04/04/2016', 'DD/MM/YYYY'),
    'IB-5940',
    'D-AIPM'
);

insert into viajes values (
    to_date('02/05/2016', 'DD/MM/YYYY'),
    'IB-5940',
    'D-AIPM'
);

insert into viajes values (
    to_date('12/09/2016', 'DD/MM/YYYY'),
    'VY-3924',
    'F-WWOW'
);

insert into viajes values (
    to_date('26/09/2016', 'DD/MM/YYYY'),
    'VY-3924',
    'F-WWDD'
);

insert into viajes values (
    to_date('13/10/2016', 'DD/MM/YYYY'),
    'AF-1149',
    'EP-NHT'
);

insert into viajes values (
    to_date('17/11/2016', 'DD/MM/YYYY'),
    'AF-1149',
    'EP-NHT'
);

insert into viajes values (
    to_date('24/11/2016', 'DD/MM/YYYY'),
    'QR-3776',
    'S2-AFA'
);

insert into viajes values (
    to_date('22/12/2016', 'DD/MM/YYYY'),
    'QR-3776',
    'S2-AFA'
);

insert into viajes values (
    to_date('12/01/2017', 'DD/MM/YYYY'),
    'UX-6013',
    'N918DH'
);

insert into viajes values (
    to_date('02/02/2017', 'DD/MM/YYYY'),
    'UX-6013',
    'HZ-APH'
);

select * from viajes;

-- Tabla 11, auxiliares de viaje:

create table auxiliaresdeviaje (
    NumPasaporte varchar(9),
    CodVuelo varchar(7),
    Fecha date,
    constraint pk_auxiliaresdeviaje primary key (NumPasaporte, CodVuelo, Fecha),
    constraint fk_auxviajesnumpasaporte foreign key (NumPasaporte) references auxiliares (NumPasaporte),
    constraint fk_auxviajescodvuelo foreign key (CodVuelo, Fecha) references viajes (CodVuelo, Fecha),
    constraint pasaporteauxiliaresdeviaje check (NumPasaporte ~* '^[a-zA-Z]{3}[0-9]{6}')
);

insert into auxiliaresdeviaje values (
    'AJC000153',
    'IB-3949',
    to_date('26/09/2016', 'DD/MM/YYYY')
);

insert into auxiliaresdeviaje values (
    'BFJ000171',
    'IB-3949',
    to_date('26/09/2016', 'DD/MM/YYYY')
);

insert into auxiliaresdeviaje values (
    'AHC000120',
    'IB-3949',
    to_date('26/09/2016', 'DD/MM/YYYY')
);

insert into auxiliaresdeviaje values (
    'CRT000765',
    'IB-3949',
    to_date('26/09/2016', 'DD/MM/YYYY')
);

insert into auxiliaresdeviaje values (
    'ECB000121',
    'IB-5940',
    to_date('02/05/2016', 'DD/MM/YYYY')
);

insert into auxiliaresdeviaje values (
    'GBB000732',
    'IB-5940',
    to_date('02/05/2016', 'DD/MM/YYYY')
);

insert into auxiliaresdeviaje values (
    'AHC000120',
    'IB-5940',
    to_date('02/05/2016', 'DD/MM/YYYY')
);

insert into auxiliaresdeviaje values (
    'BFJ000171',
    'IB-5940',
    to_date('02/05/2016', 'DD/MM/YYYY')
);

insert into auxiliaresdeviaje values (
    'AHC000120',
    'AF-1149',
    to_date('13/10/2016', 'DD/MM/YYYY')
);

insert into auxiliaresdeviaje values (
    'CRT000765',
    'AF-1149',
    to_date('13/10/2016', 'DD/MM/YYYY')
);

insert into auxiliaresdeviaje values (
    'GBB000732',
    'AF-1149',
    to_date('13/10/2016', 'DD/MM/YYYY')
);

insert into auxiliaresdeviaje values (
    'ECB000121',
    'AF-1149',
    to_date('13/10/2016', 'DD/MM/YYYY')
);

insert into auxiliaresdeviaje values (
    'AJC000153',
    'QR-3776',
    to_date('22/12/2016', 'DD/MM/YYYY')
);

insert into auxiliaresdeviaje values (
    'AHC000120',
    'QR-3776',
    to_date('22/12/2016', 'DD/MM/YYYY')
);

insert into auxiliaresdeviaje values (
    'GBB000732',
    'QR-3776',
    to_date('22/12/2016', 'DD/MM/YYYY')
);

insert into auxiliaresdeviaje values (
    'ECB000121',
    'QR-3776',
    to_date('22/12/2016', 'DD/MM/YYYY')
);

insert into auxiliaresdeviaje values (
    'ECB000121',
    'UX-6013',
    to_date('12/01/2017', 'DD/MM/YYYY')
);

insert into auxiliaresdeviaje values (
    'CRT000765',
    'UX-6013',
    to_date('12/01/2017', 'DD/MM/YYYY')
);

insert into auxiliaresdeviaje values (
    'BFJ000171',
    'UX-6013',
    to_date('12/01/2017', 'DD/MM/YYYY')
);

insert into auxiliaresdeviaje values (
    'AJC000153',
    'UX-6013',
    to_date('12/01/2017', 'DD/MM/YYYY')
);

select * from auxiliaresdeviaje;

-- Tabla 12, pasajeros embarcados:

create table pasajerosembarcados (
    NumPasaporte varchar(9),
    CodVuelo varchar(7),
    Fecha date,
    NumBultos numeric(1),
    PesoEquipaje numeric(4, 2),
    constraint pk_pasajerosembarcados primary key (NumPasaporte, CodVuelo, Fecha),
    constraint fk_pasajerosembarnumpasaporte foreign key (NumPasaporte) references pasajeros (NumPasaporte),
    constraint fk_pasajerosembarcodvuelo foreign key (CodVuelo, Fecha) references viajes (CodVuelo, Fecha),
    constraint pasaportepasajerosembarcados check (NumPasaporte ~* '^[a-zA-Z]{3}[0-9]{6}')
);

insert into pasajerosembarcados values (
    'AXN000888',
    'IB-3949',
    to_date('26/09/2016', 'DD/MM/YYYY'),
    1,
    7.58
);

insert into pasajerosembarcados values (
    'BCF174623',
    'IB-3949',
    to_date('26/09/2016', 'DD/MM/YYYY'),
    2,
    14.08
);

insert into pasajerosembarcados values (
    'CGB653132',
    'IB-3949',
    to_date('26/09/2016', 'DD/MM/YYYY'),
    1,
    9.34
);

insert into pasajerosembarcados values (
    'DWQ000879',
    'IB-5940',
    to_date('04/04/2016', 'DD/MM/YYYY'),
    2,
    23.05
);

insert into pasajerosembarcados values (
    'ERT000919',
    'IB-5940',
    to_date('04/04/2016', 'DD/MM/YYYY'),
    1,
    5.55
);

insert into pasajerosembarcados values (
    'FHJ456123',
    'VY-3924',
    to_date('12/09/2016', 'DD/MM/YYYY'),
    2,
    7.69
);

insert into pasajerosembarcados values (
    'GGG000555',
    'VY-3924',
    to_date('12/09/2016', 'DD/MM/YYYY'),
    2,
    17.65
);

insert into pasajerosembarcados values (
    'HKL000333',
    'AF-1149',
    to_date('13/10/2016', 'DD/MM/YYYY'),
    1,
    6.32
);

insert into pasajerosembarcados values (
    'IRT000444',
    'AF-1149',
    to_date('13/10/2016', 'DD/MM/YYYY'),
    1,
    8.67
);

insert into pasajerosembarcados values (
    'JYN000222',
    'AF-1149',
    to_date('13/10/2016', 'DD/MM/YYYY'),
    1,
    2.29
);

insert into pasajerosembarcados values (
    'AXN000888',
    'IB-3949',
    to_date('17/10/2016', 'DD/MM/YYYY'),
    2,
    9.99
);

insert into pasajerosembarcados values (
    'BCF174623',
    'UX-6013',
    to_date('02/02/2017', 'DD/MM/YYYY'),
    1,
    11.45
);

insert into pasajerosembarcados values (
    'DWQ000879',
    'IB-5940',
    to_date('02/05/2016', 'DD/MM/YYYY'),
    2,
    13.78
);

insert into pasajerosembarcados values (
    'ERT000919',
    'UX-6013',
    to_date('12/01/2017', 'DD/MM/YYYY'),
    1,
    7.54
);

insert into pasajerosembarcados values (
    'FHJ456123',
    'VY-3924',
    to_date('26/09/2016', 'DD/MM/YYYY'),
    2,
    23.51
);

insert into pasajerosembarcados values (
    'GGG000555',
    'QR-3776',
    to_date('22/12/2016', 'DD/MM/YYYY'),
    1,
    6.66
);

insert into pasajerosembarcados values (
    'HKL000333',
    'AF-1149',
    to_date('17/11/2016', 'DD/MM/YYYY'),
    2,
    15.78
);

insert into pasajerosembarcados values (
    'IRT000444',
    'QR-3776',
    to_date('24/11/2016', 'DD/MM/YYYY'),
    1,
    9.21
);

select * from pasajerosembarcados;
