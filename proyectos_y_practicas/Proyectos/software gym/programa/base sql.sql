use gym;


CREATE TABLE carnets (
    idCarnet INT AUTO_INCREMENT PRIMARY KEY,
    idAlumnos INT,
    pago DECIMAL(8,2),
    fecha_inicio_carnet DATE,
    fechaVencimiento DATE,
    FOREIGN KEY (idAlumnos) REFERENCES alumnos_registrados(idAlumnos)
);

select * from carnets;
-- Los números en la columna "idAlumnos" se generarán automáticamente con autoincremento.
INSERT INTO ALUMNOS_Registrados (Nombre, Apellido, Telefono, Fecha_inscripcion)
VALUES
  ('Juan', 'Pérez', 123456789, '2023-01-15'),
  ('María', 'González', 987654321, '2023-02-20'),
  ('Carlos', 'Sánchez', 555666777, '2023-03-10'),
  ('Ana', 'Martínez', 333222111, '2023-04-05'),
  ('Laura', 'Rodríguez', 555555555, '2023-05-12'),
  ('Pedro', 'López', 777888999, '2023-06-18'),
  ('Sofía', 'Hernández', 666333111, '2023-07-25'),
  ('Miguel', 'Fernández', 444333222, '2023-08-09');
 
 select * from alumnos_registrados