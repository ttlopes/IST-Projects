SELECT dia_mes, mes, ano, dia_semana, concelho, unidades
FROM vendas
WHERE dia_mes BETWEEN EXTRACT(DAY FROM DATE('2022-01-02')) AND EXTRACT(DAY FROM DATE('2022-01-06')) AND
mes BETWEEN EXTRACT(MONTH FROM DATE('2022-01-02')) AND EXTRACT(MONTH FROM DATE('2022-01-06')) AND
ano BETWEEN EXTRACT(YEAR FROM DATE('2022-01-02')) AND EXTRACT(YEAR FROM DATE('2022-01-06'))
GROUP BY
    CUBE(dia_mes, mes, ano, dia_semana, concelho, unidades);


SELECT distrito, concelho, cat, dia_semana, unidades
FROM vendas
WHERE distrito = 'Lisboa'
GROUP BY
    CUBE(distrito, concelho, cat, dia_semana);