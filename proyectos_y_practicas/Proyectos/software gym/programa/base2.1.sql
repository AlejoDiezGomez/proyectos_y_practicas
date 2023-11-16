create database appgym3 ;
USE appgym3;
CREATE TABLE alumnos_registro (
     ID int auto_increment not null,
     nombre VARCHAR(50) not null,
     apellido VARCHAR(50) not null,
     telefono int not null ,
     fecha_inscripcion date , 
     PRIMARY KEY (ID)
);

CREATE TABLE carnet (
    IDcarnet int auto_increment not null,
    IDregistro int not null,
    fecha_inicio_carnet date not null , 
    fecha_vencimiento_carnet date not null , 
    pago decimal(8 , 2 ),
    PRIMARY KEY (IDcarnet),
    foreign key (IDregistro) references alumnos_registro (ID)
    
);
#select * from alumnos_registro ;
select * from carnet ;