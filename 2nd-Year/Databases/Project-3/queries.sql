--3.SQL

SELECT nome FROM retalhista
WHERE tin in (SELECT tin
    FROM evento_reposicao
    GROUP BY tin
    HAVING SUM(unidades) >= ALL(
        SELECT SUM(unidades)
        FROM evento_reposicao
        GROUP BY tin
    )
);


SELECT DISTINCT(nome) FROM retalhista
NATURAL JOIN responsavel_por
NATURAL JOIN 
    (SELECT nome AS nome_cat 
        FROM categoria_simples)
        AS alteracao_categoria;


SELECT ean FROM produto
WHERE ean NOT IN
(SELECT ean FROM evento_reposicao);



--SELECT ean FROM produto
--NATURAL JOIN evento_reposicao
--NATURAL JOIN retalhista
--WHERE tin = ALL(
--    SELECT tin FROM evento_reposicao
--    NATURAL JOIN produto
--    WHERE ean = produto.ean
--);

--6.Consultas OLAP

--1
SELECT dia_mes, mes, ano, dia_semana, concelho, unidades
FROM vendas
WHERE ... BETWEEN data1 AND data2
GROUP BY
    CUBE(, dia_semana, concelho);

--2
SELECT distrito, concelho, cat, dia_semana, unidades
FROM vendas
WHERE distrito = 'Lisboa'
GROUP BY
    CUBE(distrito, concelho, cat, dia_semana);