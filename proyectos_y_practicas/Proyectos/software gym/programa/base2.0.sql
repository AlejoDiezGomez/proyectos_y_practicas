use appgym;
CREATE TABLE carnets (
     IDcarnets int auto_increment primary key,
     IDalumnos int,
     fecha_inicio_carnet date not null,
     fecha_vencimiento_carnet date not null,
     pago decimal(8.2),
     foreign key (IDalumnos) references alumnos_registro(ID)
);