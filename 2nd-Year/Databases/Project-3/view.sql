CREATE VIEW vendas AS 
SELECT ean, nome AS cat, EXTRACT(YEAR FROM instante) AS ano, EXTRACT(QUARTER FROM instante) AS trimestre,
    EXTRACT(MONTH FROM instante) AS mes, EXTRACT(DAY FROM instante) AS dia_mes,
    EXTRACT(DOW FROM instante) AS dia_semana, distrito, concelho, unidades
FROM produto, categoria, evento_reposicao, ponto_de_retalho, evento_reposicao