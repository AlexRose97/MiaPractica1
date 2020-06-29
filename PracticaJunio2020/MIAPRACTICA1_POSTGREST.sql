/*1)-----------------------------------------------Creacion de las tablas---------------------------------------------*/
/*----->tablas independientes*/
create table PROFESION
(
    cod_prof INTEGER not null,
    nombre VARCHAR(50) not null unique,
    primary key(cod_prof)
);

create table PAIS
(
    cod_pais INTEGER not null,
    nombre VARCHAR(50) not null CONSTRAINT U_Pais_nombre unique,
    primary key(cod_pais)
);

create table PUESTO
(
    cod_puesto INTEGER not null,
    nombre VARCHAR(50) not null CONSTRAINT U_puesto_nombre unique,
    primary key(cod_puesto)
);

create table DEPARTAMENTO
(
    cod_depto INTEGER not null,
    nombre VARCHAR(50) not null CONSTRAINT U_Dep_nombre unique,
    primary key(cod_depto)
);

create table TIPO_MEDALLA
(
    cod_tipo INTEGER not null,
    medalla VARCHAR(20) not null CONSTRAINT U_Tip_Me_medalla unique,
    primary key(cod_tipo)
);

create table DISCIPLINA
(
    cod_disciplina INTEGER not null,
    nombre VARCHAR(50) not null,
    descripcion VARCHAR(150) null,
    primary key(cod_disciplina)
);

create table CATEGORIA
(
    cod_categoria INTEGER not null,
    categoria VARCHAR(50) not null,
    primary key(cod_categoria)
);

create table TIPO_PARTICIPACION
(
    cod_participacion INTEGER not null,
    tipo_participacion VARCHAR(100) not null,
    primary key(cod_participacion)
);

create table TELEVISORA
(
    cod_televisora INTEGER not null,
    nombre VARCHAR(50) not null,
    primary key(cod_televisora)
);


/*----->tablas con llaves foraneas*/
create table MIEMBRO
(
    cod_miembro INTEGER not null,
    nombre VARCHAR(100) not null,
    apellido VARCHAR(100) not null,
    edad INTEGER not null,
    telefono INTEGER null,
    residencia VARCHAR(100) null,
    PAIS_cod_pais INTEGER not null,
    PROFESION_cod_prof INTEGER not null,
    CONSTRAINT FK_MIEMBRO_cod_pais foreign key(PAIS_cod_pais) REFERENCES PAIS(cod_pais) ON DELETE CASCADE,
    CONSTRAINT FK_MIEMBRO_cod_prof foreign key(PROFESION_cod_prof) REFERENCES PROFESION(cod_prof) ON DELETE CASCADE,
    primary key(cod_miembro)
);
create table PUESTO_MIEMBRO
(
    MIEMBRO_cod_miembro INTEGER not null,
    PUESTO_cod_puesto INTEGER not null,
    DEPARTAMENTO_cod_depto INTEGER not null,
    fecha_inicio DATE not null,
    fecha_fin Date null,
    CONSTRAINT FK_PM_cod_miembro foreign key(MIEMBRO_cod_miembro) REFERENCES MIEMBRO(cod_miembro) ON DELETE CASCADE,
    CONSTRAINT FK_PM_cod_puesto foreign key(PUESTO_cod_puesto) REFERENCES PUESTO(cod_puesto) ON DELETE CASCADE ,
    CONSTRAINT FK_PM_cod_depto foreign key(DEPARTAMENTO_cod_depto) REFERENCES DEPARTAMENTO(cod_depto) ON DELETE CASCADE ,
    primary key(MIEMBRO_cod_miembro, PUESTO_cod_puesto, DEPARTAMENTO_cod_depto)
);

create table MEDALLERO
(
    PAIS_cod_pais INTEGER not null,
    cantidad_medallas INTEGER not null,
    TIPO_MEDALLA_cod_tipo INTEGER not null,
    CONSTRAINT FK_MED_cod_pais foreign key(PAIS_cod_pais) REFERENCES PAIS(cod_pais) ON DELETE CASCADE ,
    CONSTRAINT FK_MED_cod_tipo foreign key(TIPO_MEDALLA_cod_tipo) REFERENCES TIPO_MEDALLA(cod_tipo) ON DELETE CASCADE ,
    primary key(PAIS_cod_pais, TIPO_MEDALLA_cod_tipo)
);

create table ATLETA
(
    cod_atleta INTEGER not null,
    nombre VARCHAR(50) not null,
    apellido VARCHAR(50) not null,
    edad INTEGER not null,
    participaciones VARCHAR(100) not null,
    DISCIPLINA_cod_disciplina INTEGER not null,
    PAIS_cod_pais INTEGER not null,
    CONSTRAINT FK_ATL_cod_disciplina foreign key(DISCIPLINA_cod_disciplina) REFERENCES DISCIPLINA(cod_disciplina) ON DELETE CASCADE ,
    CONSTRAINT FK_ATL_cod_pais foreign key(PAIS_cod_pais) REFERENCES PAIS(cod_pais) ON DELETE CASCADE ,
    primary key(cod_atleta)
);

create table EVENTO
(
    cod_evento INTEGER not null,
    fecha DATE not null,
    ubicacion VARCHAR(50) not null,
    hora DATE not null,
    DISCIPLINA_cod_disciplina INTEGER not null,
    TIPO_PARTICIPACION_cod_part INTEGER not null,
    CATEGORIA_cod_categoria INTEGER not null,
    CONSTRAINT FK_Ev_cod_disciplina foreign key(DISCIPLINA_cod_disciplina) REFERENCES DISCIPLINA(cod_disciplina) ON DELETE CASCADE ,
    CONSTRAINT FK_Ev_cod_participacion foreign key(TIPO_PARTICIPACION_cod_part) REFERENCES TIPO_PARTICIPACION(cod_participacion) ON DELETE CASCADE ,
    CONSTRAINT FK_Ev_cod_categoria foreign key(CATEGORIA_cod_categoria) REFERENCES CATEGORIA(cod_categoria) ON DELETE CASCADE ,
    primary key(cod_evento)
);

create table EVENTO_ATLETA
(
    ATLETA_cod_atleta INTEGER not null,
    EVENTO_cod_evento INTEGER not null,
    CONSTRAINT FK_EA_cod_atleta foreign key(ATLETA_cod_atleta) REFERENCES ATLETA(cod_atleta) ON DELETE CASCADE ,
    CONSTRAINT FK_EA_cod_evento foreign key(EVENTO_cod_evento) REFERENCES EVENTO(cod_evento) ON DELETE CASCADE ,
    primary key(ATLETA_cod_atleta, EVENTO_cod_evento)
);

create table COSTO_EVENTO
(
    EVENTO_cod_evento INTEGER not null,
    TELEVISORA_cod_televisora INTEGER not null,
    tarifa INTEGER not null,
    CONSTRAINT FK_CE_cod_evento foreign key(EVENTO_cod_evento) REFERENCES EVENTO(cod_evento) ON DELETE CASCADE ,
    CONSTRAINT FK_CE_cod_televisora foreign key(TELEVISORA_cod_televisora) REFERENCES TELEVISORA(cod_televisora) ON DELETE CASCADE ,
    primary key(EVENTO_cod_evento, TELEVISORA_cod_televisora)
);

/*2)-----------------------------------------------------Tabla evento-------------------------------------------------*/
/*----->eliminar columnas fecha y hora*/
ALTER TABLE EVENTO DROP COLUMN FECHA;
ALTER TABLE EVENTO DROP COLUMN HORA;

/*----->eliminar columnas fecha y hora*/
ALTER TABLE EVENTO ADD fecha_hora DATE NOT NULL;

/*3)------------------------------------------------Rango de eventos--------------------------------------------------*/
/*24/07/20 9:00:00 hasta 09/08/20 20:00:00, */
ALTER TABLE EVENTO ADD CONSTRAINT CHECK_FH CHECK ((fecha_hora) BETWEEN TO_DATE('2020-07-24 9:00:00','yyyy-mm-dd hh24:mi:ss') AND TO_DATE('2020-08-09 20:00:00','yyyy-mm-dd hh24:mi:ss'));

/*4)-------------------------------------Creacion de tabla auxiliar para eventos--------------------------------------*/
/*----->crear tabla sede*/
create table SEDE
(
    codigo INTEGER not null,
    sede VARCHAR(50) not null,
    primary key(codigo)
);

/*----->Cambiar "ubicacion" a entero en tabla EVENTO*/
ALTER TABLE EVENTO ALTER COLUMN ubicacion TYPE integer using ubicacion::integer;

/*----->AGREGAR LLAVE FORANEA*/
ALTER TABLE EVENTO ADD CONSTRAINT FK_EVEN_ubicacion foreign key (ubicacion) references SEDE(codigo);



/*5)--------------------------------------numero telefonico default 0 en miembros-------------------------------------*/
ALTER TABLE MIEMBRO ALTER COLUMN telefono SET DEFAULT 0;

/*6)---------------------------------------------------Ingresar Datos-------------------------------------------------*/
/*----->pais*/
insert into pais (cod_pais, nombre) values(1,'Guatemala');
insert into pais (cod_pais, nombre) values(2,'Francia');
insert into pais (cod_pais, nombre) values(3,'Argentina');
insert into pais (cod_pais, nombre) values(4,'Alemania');
insert into pais (cod_pais, nombre) values(5,'Italia');
insert into pais (cod_pais, nombre) values(6,'Brasil');
insert into pais (cod_pais, nombre) values(7,'Estados Unidos');
/*----->profesion*/
insert into PROFESION (cod_prof, nombre) values(1,'Medico');
insert into PROFESION (cod_prof, nombre) values(2,'Arquitecto');
insert into PROFESION (cod_prof, nombre) values(3,'Ingeniero');
insert into PROFESION (cod_prof, nombre) values(4,'Secretaria');
insert into PROFESION (cod_prof, nombre) values(5,'Auditor');
/*------>Miembro*/
insert into MIEMBRO (cod_miembro,nombre,apellido,edad,telefono,residencia,PAIS_cod_pais,PROFESION_cod_prof) values(1,'Scott','Mitchell',32,null,'1092 Highland Drive Manitowoc, WI 54220',7,3);
insert into MIEMBRO (cod_miembro,nombre,apellido,edad,telefono,residencia,PAIS_cod_pais,PROFESION_cod_prof) values(2,'Fanette','Poulin',25,25075853,'49, boulevard Aristide Briand 76120 LE GRAND-QUEVILLY',2,4);
insert into MIEMBRO (cod_miembro,nombre,apellido,edad,telefono,residencia,PAIS_cod_pais,PROFESION_cod_prof) values(3,'Laura','Cunha Silva',55,null,'Rua Onze, 86 Uberaba-MG',6,5);
insert into MIEMBRO (cod_miembro,nombre,apellido,edad,telefono,residencia,PAIS_cod_pais,PROFESION_cod_prof) values(4,'Juan Jose','Lopez',38,36985247,'26 calle 4-10 zona 11',1,2);
insert into MIEMBRO (cod_miembro,nombre,apellido,edad,telefono,residencia,PAIS_cod_pais,PROFESION_cod_prof) values(5,'Arcangela','Punicucci',39,391664921,'Via Santa Teresa, 114 90010-Geraci Siculo PA',5,1);
insert into MIEMBRO (cod_miembro,nombre,apellido,edad,telefono,residencia,PAIS_cod_pais,PROFESION_cod_prof) values(6,'Jeuel','Villalpando',31,null,'Acuña de Figeroa 6106 80101 Playa Pascual',3,5);
/*------>Disciplina*/
insert into DISCIPLINA (cod_disciplina,nombre,descripcion) values(1,'Atletismo','Saltos de longitud y triples, de altura y con pértiga o garrocha; las pruebas de lanzamiento de martillo, jabalina y disco.');
insert into DISCIPLINA (cod_disciplina,nombre,descripcion) values(2,'Badminton',null);
insert into DISCIPLINA (cod_disciplina,nombre,descripcion) values(3,'ciclismo',null);
insert into DISCIPLINA (cod_disciplina,nombre,descripcion) values(4,'judo','Es un arte marcial que se originó en Japón alrededor de 1880');
insert into DISCIPLINA (cod_disciplina,nombre,descripcion) values(5,'lucha',null);
insert into DISCIPLINA (cod_disciplina,nombre,descripcion) values(6,'Tenis de mesa',null);
insert into DISCIPLINA (cod_disciplina,nombre,descripcion) values(7,'Boxeo',null);
insert into DISCIPLINA (cod_disciplina,nombre,descripcion) values(8,'Natacion','Está presente como deporte en los Juegos desde la primera edición de la era moderna, en Atenas, Grecia, en 1896, donde se disputo en aguas abiertas.');
insert into DISCIPLINA (cod_disciplina,nombre,descripcion) values(9,'Esgrima',null);
insert into DISCIPLINA (cod_disciplina,nombre,descripcion) values(10,'Vela',null);
/*------->TIPO_MEDALLA*/
insert into TIPO_MEDALLA (cod_tipo,medalla) values(1,'Oro');
insert into TIPO_MEDALLA (cod_tipo,medalla) values(2,'Plata');
insert into TIPO_MEDALLA (cod_tipo,medalla) values(3,'Bronce');
insert into TIPO_MEDALLA (cod_tipo,medalla) values(4,'Platino');
/*------->Categoria*/
insert into CATEGORIA (cod_categoria,categoria) values(1,'Clasificatorio');
insert into CATEGORIA (cod_categoria,categoria) values(2,'Eliminatorio');
insert into CATEGORIA (cod_categoria,categoria) values(3,'final');
/*------->TIPO_Participacion*/
insert into TIPO_PARTICIPACION (cod_participacion,tipo_participacion) values(1,'Individual');
insert into TIPO_PARTICIPACION (cod_participacion,tipo_participacion) values(2,'Parejas');
insert into TIPO_PARTICIPACION (cod_participacion,tipo_participacion) values(3,'Equipos');
/*------->MEDALLERo*/
insert into MEDALLERO (PAIS_cod_pais,TIPO_MEDALLA_cod_tipo,cantidad_medallas) values(5,1,3);
insert into MEDALLERO (PAIS_cod_pais,TIPO_MEDALLA_cod_tipo,cantidad_medallas) values(2,1,5);
insert into MEDALLERO (PAIS_cod_pais,TIPO_MEDALLA_cod_tipo,cantidad_medallas) values(6,3,4);
insert into MEDALLERO (PAIS_cod_pais,TIPO_MEDALLA_cod_tipo,cantidad_medallas) values(4,4,3);
insert into MEDALLERO (PAIS_cod_pais,TIPO_MEDALLA_cod_tipo,cantidad_medallas) values(7,3,10);
insert into MEDALLERO (PAIS_cod_pais,TIPO_MEDALLA_cod_tipo,cantidad_medallas) values(3,2,8);
insert into MEDALLERO (PAIS_cod_pais,TIPO_MEDALLA_cod_tipo,cantidad_medallas) values(1,1,2);
insert into MEDALLERO (PAIS_cod_pais,TIPO_MEDALLA_cod_tipo,cantidad_medallas) values(1,4,5);
insert into MEDALLERO (PAIS_cod_pais,TIPO_MEDALLA_cod_tipo,cantidad_medallas) values(5,2,7);
/*------>SEDE*/
insert into SEDE (codigo,sede) values(1,'Gimnasio Metropolitano de Tokio');
insert into SEDE (codigo,sede) values(2,'Jardín del Palacio Imperial de Tokio');
insert into SEDE (codigo,sede) values(3,'Gimnasio Nacional Yoyogi');
insert into SEDE (codigo,sede) values(4,'Nippon Budokan');
insert into SEDE (codigo,sede) values(5,'Estadio Olímpico');
/*------>EVENTO*/
insert into EVENTO (cod_evento,fecha_hora,ubicacion,DISCIPLINA_cod_disciplina,TIPO_PARTICIPACION_cod_part,CATEGORIA_cod_categoria) values(1,TO_DATE('2020-07-24 11:00:00','yyyy-mm-dd hh24:mi:ss'),3,2,2,1);
insert into EVENTO (cod_evento,fecha_hora,ubicacion,DISCIPLINA_cod_disciplina,TIPO_PARTICIPACION_cod_part,CATEGORIA_cod_categoria) values(2,TO_DATE('2020-07-26 10:30:00','yyyy-mm-dd hh24:mi:ss'),1,6,1,3);
insert into EVENTO (cod_evento,fecha_hora,ubicacion,DISCIPLINA_cod_disciplina,TIPO_PARTICIPACION_cod_part,CATEGORIA_cod_categoria) values(3,TO_DATE('2020-07-30 18:45:00','yyyy-mm-dd hh24:mi:ss'),5,7,1,2);
insert into EVENTO (cod_evento,fecha_hora,ubicacion,DISCIPLINA_cod_disciplina,TIPO_PARTICIPACION_cod_part,CATEGORIA_cod_categoria) values(4,TO_DATE('2020-08-01 12:15:00','yyyy-mm-dd hh24:mi:ss'),2,1,1,1);
insert into EVENTO (cod_evento,fecha_hora,ubicacion,DISCIPLINA_cod_disciplina,TIPO_PARTICIPACION_cod_part,CATEGORIA_cod_categoria) values(5,TO_DATE('2020-08-08 19:35:00','yyyy-mm-dd hh24:mi:ss'),4,10,3,1);



/*7)----------------------------------------------------quitar unique-------------------------------------------------*/
ALTER TABLE PAIS DROP CONSTRAINT U_pais_nombre;
ALTER TABLE TIPO_MEDALLA DROP CONSTRAINT U_Tip_Me_medalla;
ALTER TABLE DEPARTAMENTO DROP CONSTRAINT U_Dep_nombre;

/*8)-------------------------------------------------Modificar atleta-------------------------------------------------*/
/*------>eliminar llave foranea "cod_disiplina" de atleta*/
ALTER TABLE ATLETA DROP CONSTRAINT FK_ATL_cod_disciplina;
/*------>crear tabla DISCIPLINA_ATLETA*/
create table DISCIPLINA_ATLETA
(
    cod_atleta INTEGER not null,
    cod_disciplina INTEGER not null,
    CONSTRAINT FK_DA_cod_atleta foreign key(cod_atleta) REFERENCES ATLETA(cod_atleta) ON DELETE CASCADE,
    CONSTRAINT FK_DA_cod_disc foreign key(cod_disciplina) REFERENCES DISCIPLINA(cod_disciplina) ON DELETE CASCADE,
    primary key(cod_atleta,cod_disciplina)
);


/*9)------------------------------------------Modificar "tarifa" de costo_evento--------------------------------------*/
ALTER TABLE COSTO_EVENTO ALTER COLUMN tarifa TYPE decimal(38,2);


/*10)----------------------------------------------Eliminar un registro-----------------------------------------------*/
delete from TIPO_MEDALLA where cod_tipo=4 and Lower(Medalla)='platino';


/*11)-------------------------------Eliminar tablas TELEVISORAS” y “COSTO_EVENTO--------------------------------------*/
drop table TELEVISORA cascade;
drop table COSTO_EVENTO cascade;


/*12)--------------------------------------Eliminar registros de DISCIPLINA-------------------------------------------*/
delete from DISCIPLINA;

/*13)-------------------------------------actualizar datos a registro miembros----------------------------------------*/
update MIEMBRO set telefono=55464601 where lower(NOMBRE)=lower('Laura') and lower(apellido)=lower('Cunha Silva');
update MIEMBRO set telefono=91514243 where lower(NOMBRE)=lower('Jeuel') and lower(apellido)=lower('Villalpando');
update MIEMBRO set telefono=920686670 where lower(NOMBRE)=lower('Scott') and lower(apellido)=lower('Mitchell');



/*14)-------------------------------------agregar imagenes a los ATLETAS----------------------------------------------*/
alter table ATLETA add Fotografia VARCHAR(250) null;


/*15)-------------------------------------agregar rango a edades atleta<25 -------------------------------------------*/
ALTER TABLE ATLETA ADD CONSTRAINT CHECK_EDAD CHECK ((edad)<25);


/*borrar todo*/
/*
drop table ATLETA cascade;
drop table CATEGORIA cascade;
drop table DEPARTAMENTO cascade;
drop table DISCIPLINA cascade;
drop table MEDALLERO cascade;
drop table MIEMBRO cascade;
drop table PAIS cascade;
drop table PROFESION cascade;
drop table PUESTO cascade;
drop table PUESTO_MIEMBRO cascade;
drop table TELEVISORA cascade;
drop table TIPO_MEDALLA cascade;
drop table TIPO_PARTICIPACION cascade;
drop table EVENTO cascade;
drop table EVENTO_ATLETA cascade;
drop table COSTO_EVENTO cascade;
drop table SEDE cascade;
drop table DISCIPLINA_ATLETA cascade;
*/
