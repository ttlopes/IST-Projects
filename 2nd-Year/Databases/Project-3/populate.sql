--DROP ALL TABLES
DROP INDEX IF EXISTS idx_nome; 
DROP INDEX IF EXISTS idx_descr;
DROP TABLE IF EXISTS categoria CASCADE;
DROP TABLE IF EXISTS categoria_simples CASCADE;
DROP TABLE IF EXISTS super_categoria CASCADE;
DROP TABLE IF EXISTS tem_outra CASCADE;
DROP TABLE IF EXISTS produto CASCADE;
DROP TABLE IF EXISTS tem_categoria CASCADE;
DROP TABLE IF EXISTS IVM CASCADE;
DROP TABLE IF EXISTS ponto_de_retalho CASCADE;
DROP TABLE IF EXISTS instalada_em CASCADE;
DROP TABLE IF EXISTS prateleira CASCADE;
DROP TABLE IF EXISTS planograma CASCADE;
DROP TABLE IF EXISTS retalhista CASCADE;
DROP TABLE IF EXISTS responsavel_por CASCADE;
DROP TABLE IF EXISTS evento_reposicao CASCADE;

--TABLE CREATION
CREATE TABLE categoria(nome varchar(25) PRIMARY KEY);

CREATE TABLE categoria_simples(
    nome varchar(25),
    PRIMARY KEY (nome),
    FOREIGN KEY (nome) REFERENCES categoria(nome)    
);

CREATE TABLE super_categoria(
    nome varchar(25), 
    PRIMARY KEY (nome),
    FOREIGN KEY (nome) REFERENCES categoria(nome)    
);

CREATE TABLE tem_outra(
    super_categoria varchar(25) NOT NULL,
    categoria varchar(25) NOT NULL,
    PRIMARY KEY (categoria),
    FOREIGN KEY (categoria) REFERENCES categoria(nome),
    FOREIGN KEY (super_categoria) REFERENCES super_categoria(nome)
);
    
CREATE TABLE produto(
    ean numeric(13,0) PRIMARY KEY,
    cat varchar(25),
    descr varchar(255),
    FOREIGN KEY (cat) REFERENCES categoria(nome)
);

CREATE TABLE tem_categoria(
    ean numeric(13,0),
    nome varchar(25),
    PRIMARY KEY (ean, nome),
    FOREIGN KEY (ean) REFERENCES produto(ean),
    FOREIGN KEY (nome) REFERENCES categoria(nome)
);

CREATE TABLE IVM(
    num_serie int UNIQUE,
    fabricante varchar(255),
    PRIMARY KEY (num_serie, fabricante)
);

CREATE TABLE ponto_de_retalho(
    nome varchar(100) PRIMARY KEY,
    distrito varchar(16),
    concelho varchar(24)
);

CREATE TABLE instalada_em(
    num_serie int,
    fabricante varchar(255),
    local varchar(100),
    PRIMARY KEY(num_serie, fabricante),
    FOREIGN KEY (num_serie, fabricante)
        REFERENCES IVM(num_serie, fabricante),
    FOREIGN KEY (local) REFERENCES ponto_de_retalho(nome)
);

CREATE TABLE prateleira(
    nro int,
    num_serie int,
    fabricante varchar(255),
    altura numeric(3,0),
    nome varchar(25),
    PRIMARY KEY (nro, num_serie, fabricante),
    FOREIGN KEY (num_serie, fabricante) REFERENCES IVM(num_serie, fabricante),
    FOREIGN KEY (nome) REFERENCES categoria(nome)
);

CREATE TABLE planograma(
    ean numeric(13,0),
    nro int,
    num_serie int,
    fabricante varchar(255),
    faces int,
    unidades int,
    loc varchar(255),
    PRIMARY KEY (ean, nro, num_serie, fabricante),
    FOREIGN KEY (ean) REFERENCES produto(ean),
    FOREIGN KEY (nro, num_serie, fabricante)
        REFERENCES prateleira(nro, num_serie, fabricante)
);

CREATE TABLE retalhista(
    tin int PRIMARY KEY,
    nome varchar(255) UNIQUE
);

CREATE TABLE responsavel_por(
    nome_cat varchar(25),
    tin int,
    num_serie int,
    fabricante varchar(255),
    PRIMARY KEY (nome_cat, tin, num_serie, fabricante),
    FOREIGN KEY (num_serie, fabricante) 
        REFERENCES IVM(num_serie, fabricante),
    FOREIGN KEY (tin) 
        REFERENCES retalhista(tin),
    FOREIGN KEY (nome_cat) 
        REFERENCES categoria(nome)
);

CREATE TABLE evento_reposicao(
    ean numeric(13,0),
    nro int,
    num_serie int,
    fabricante varchar(255),
    instante timestamp,
    unidades int,
    tin int,
    PRIMARY KEY (ean, nro, num_serie, fabricante, instante),
    FOREIGN KEY (ean, nro, num_serie, fabricante)
        REFERENCES planograma(ean, nro, num_serie, fabricante),
    FOREIGN KEY (tin) REFERENCES retalhista(tin)
);



--Populate database





INSERT INTO categoria VALUES
('Pastilhas'),
('Pastilhas Rebuçados'),
('Pastilhas Elásticas'),
('Pastilhas Sabores'),
('Pastilhas Diferentes'),
('Pastilhas s/ Açúcares'),
('Batatas'),
('Batatas Onduladas'),
('Batatas Lisas'),
('Batatas Sabores'),
('Refrigerante'),
('Refrigerante s/ Açúcares'),
('Refrigerante c/ Açúcares'),
('Chocolate'),
('Chocolate de Leite'),
('Chocolate Negro'),
('50%'),
('60%'),
('70%'),
('Stevia'),
('Chocolate Branco'),
('Chocolate c/ Amêndoas'),
('Chocolate s/ Amêndoas'), -- duas ultimas sao sub cat de chocolate de leite
('Sumo'),
('Água'),
('Chá'),
('Água s/ Gás'),
('Água c/ Gás'),
('Bolachas'),
('Bolachas Água e Sal'),
('Bolachas de Chocolate'),
('Bolachas Simples'),
('Bolachas de Arroz');

INSERT INTO categoria_simples VALUES 
('Pastilhas Rebuçados'),
('Pastilhas Sabores'),
('Pastilhas Diferentes'),
('Pastilhas s/ Açúcares'),
('Batatas Onduladas'),
('Batatas Lisas'),
('Batatas Sabores'),
('Refrigerante s/ Açúcares'),
('Refrigerante c/ Açúcares'),
('50%'),
('60%'),
('Stevia'),
('Chocolate Branco'),
('Chocolate c/ Amêndoas'),
('Chocolate s/ Amêndoas'),
('Sumo'),
('Chá'),
('Água s/ Gás'),
('Água c/ Gás'),
('Bolachas Água e Sal'),
('Bolachas de Chocolate'),
('Bolachas Simples'),
('Bolachas de Arroz');

INSERT INTO super_categoria VALUES
('Pastilhas'),
('Pastilhas Elásticas'),
('Batatas'),
('Refrigerante'),
('Chocolate'),
('Chocolate Negro'),
('70%'),
('Chocolate de Leite'),
('Água'),
('Bolachas');

INSERT INTO tem_outra VALUES 
('Pastilhas', 'Pastilhas Elásticas'),
('Pastilhas', 'Pastilhas Rebuçados'),
('Pastilhas Elásticas', 'Pastilhas Sabores'),
('Pastilhas Elásticas', 'Pastilhas Diferentes'),
('Pastilhas Elásticas', 'Pastilhas s/ Açúcares'),
('Chocolate', 'Chocolate de Leite'),
('Chocolate', 'Chocolate Negro'),
('Chocolate', 'Chocolate Branco'),
('Chocolate de Leite', 'Chocolate c/ Amêndoas'),
('Chocolate de Leite', 'Chocolate s/ Amêndoas'),
('Chocolate Negro', '50%'),
('Chocolate Negro', '60%'),
('Chocolate Negro', '70%'),
('70%', 'Stevia');


INSERT INTO IVM(num_serie, fabricante) VALUES
(1, 'Maquineiros'),
(2, 'Maquineiros'),
(3, 'SmartVM'),
(4, 'Maquineiros'),
(5, 'SmartVM'),
(6, 'Compraqui');


INSERT INTO produto(ean, cat,descr) VALUES
(8938558285175,'Pastilhas Rebuçados', 'Smints'),
(0685409537522,'Pastilhas Rebuçados', 'Halls'),
(1960429282137,'Pastilhas Diferentes','Trident Senses'),
(6591312110862,'Pastilhas s/ Açúcares','Trident Sugar Free'),
(2862298512409,'Pastilhas Sabores','Bubblicious Morango'),
(1211879447145,'Pastilhas Diferentes','Bubblicious Boca Azul'),
(3523834237315,'Pastilhas Sabores','Bubblicious Menta'),
(5886956944179,'Pastilhas Sabores','Bubblicious Marshmallow'),
(5719816745897,'Pastilhas', 'Chiclets'),
(8531751858964,'Chocolate','Twix'),
(7021830878147,'Chocolate','KitKat'),
(4897407216233,'Chocolate de Leite','Kinder Bueno'),
(9844457549356,'Chocolate de Leite','Kinder Bueno White'),
(3022182303852,'Chocolate de Leite','Kinder Délice'),
(4286361451548,'Chocolate de Leite','Kinder Surpresa'),
(7199274295822,'Chocolate c/ Amêndoas','Nestlé com Amêndoas'),
(3374284490250,'Chocolate Negro', 'CÔTE DOR'), 
(9475413958494,'Refrigerante c/ Açúcares','Coca Cola'),
(4946870666929,'Refrigerante s/ Açúcares','Coca Cola Zero'),
(8166196383809,'Refrigerante s/ Açúcares','Coca Cola Light'),
(8527553850704,'Refrigerante','Sumol Ananás'),
(3813667075028,'Refrigerante','Sumol Laranja'),
(0977323221238,'Sumo','Compal Pêra'),
(7242709365195,'Sumo','Compal Pêssego'),
(3771118327572,'Sumo','Compal Manga'),
(9904248260716,'Sumo','Compal Laranja'),
(0060176624636,'Sumo','Compal Laranja Algarve'),
(8565075088410,'Sumo','Compal Maçã'),
(1929252530332,'Sumo','Compal Maçãs Alcobaça'),
(7432150067253,'Sumo','Santal'),
(9043881342469,'Sumo','Trina'),
(1516508119854,'Sumo','Trina Zero'),
(1418587710724,'Sumo','Trina Maçã');


INSERT INTO prateleira(nro, num_serie, fabricante,altura,nome) VALUES
(1,1, 'Maquineiros',100,'Pastilhas'),
(2,1, 'Maquineiros',100,'Refrigerante s/ Açúcares'),
(1,2, 'Maquineiros',100,'Refrigerante'),
(2,2, 'Maquineiros',100,'Sumo'),
(1,4, 'Maquineiros',100,'Chocolate c/ Amêndoas'),
(2,4, 'Maquineiros',100,'Chocolate de Leite'),
(1,3,'SmartVM',100,'Pastilhas Sabores'),
(1,5,'SmartVM',100,'Chocolate'),
(2,3, 'SmartVM',100,'Sumo'),
(1,6,'Compraqui',100,'Pastilhas Rebuçados'),
(2,6,'Compraqui',100,'Pastilhas');


INSERT INTO planograma(ean,nro, num_serie, fabricante, faces, unidades, loc) VALUES
(1211879447145,1,1, 'Maquineiros',3,15,'Atrás'),
(4946870666929,2,1, 'Maquineiros',3,15,'Atrás'),
(8527553850704,1,2, 'Maquineiros',3,15,'Atrás'),
(9043881342469,2,2, 'Maquineiros',3,15,'Atrás'),
(7199274295822,1,4, 'Maquineiros',3,15,'Atrás'),
(7199274295822,2,4, 'Maquineiros',3,15,'Atrás'),
(2862298512409,1,3,'SmartVM',3,15,'Atrás'),
(3374284490250,1,5,'SmartVM',3,15,'Atrás'),
(0977323221238,2,3, 'SmartVM',3,15,'Atrás'),
(0685409537522,1,6,'Compraqui',3,15,'Atrás'),
(5719816745897,2,6,'Compraqui',3,15,'Atrás');

INSERT INTO retalhista(tin,nome) VALUES
(1,'João'),
(2,'Carlos'),
(3,'Pedro'),
(4,'Teresa'),
(5,'Joana'),
(6,'Carolina');

INSERT INTO responsavel_por(nome_cat, tin, num_serie, fabricante) VALUES
('Pastilhas',1,6,'Compraqui'),
('Pastilhas Rebuçados',1,6,'Compraqui'),
('Sumo',1,3,'SmartVM'),
('Chocolate Negro',4,5,'SmartVM'),
('Pastilhas Sabores',4,3,'SmartVM'),
('Chocolate de Leite',4,4,'Maquineiros'),
('Sumo',2,3,'SmartVM'),
('Refrigerante',2,2,'Maquineiros'),
('Pastilhas Sabores',6,3,'SmartVM'),
('Chocolate de Leite',6,4,'Maquineiros');

INSERT INTO evento_reposicao(ean, nro, num_serie, fabricante, instante, unidades, tin) VALUES
(2862298512409,1,3,'SmartVM',(date '2022-01-01')::timestamp,4,1),
(2862298512409,1,3,'SmartVM',(date '2022-01-03')::timestamp,4,2),
(3374284490250,1,5,'SmartVM',(date '2022-01-04')::timestamp,7,4),
(7199274295822,2,4,'Maquineiros',(date '2022-01-05')::timestamp,2,6),
(7199274295822,2,4,'Maquineiros',(date '2022-01-20')::timestamp,5,6);
