create database cuspidetop100;
USE cuspideTop100 ;
DROP TABLE top100libros ;
CREATE TABLE top100libros(
    idLibro INT AUTO_INCREMENT PRIMARY KEY, 
    titulo VARCHAR(100) , 
    url VARCHAR(300),
    precio DECIMAL(6 , 2),
    precioUsd DECIMAL(4 , 2) ,
    precioUsdBlue DECIMAL (4 , 2) ,
    fechaDato DATE 
);
CREATE TABLE errores(
      idError INT AUTO_INCREMENT PRIMARY KEY ,
      titulo VARCHAR(100) , 
      url VARCHAR(300),
      fecha DATE 
);
