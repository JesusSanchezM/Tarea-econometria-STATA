*-------------------------------------
*-------------------------------------
*----CODIGO PARA EL EJERCICIO 3.21----
*-------------------------------------
*-------------------------------------

/* Generar las variables de rendimiento excedente */
generate ex_xom = xom - riskfree
generate ex_msft = msft - riskfree
generate ex_ford = ford - riskfree
generate ex_ge = ge - riskfree
generate ex_mkt = mkt - riskfree

/* --- regresiones y pruebas para cada empresa --- */
/* --- para exxon-mobil (incisos a, b, c, e) --- */
regress ex_xom ex_mkt

test ex_mkt = 1

/* --- para microsoft (incisos a, d) --- */
regress ex_msft ex_mkt

/* --- para ford (incisos b, e) --- */
regress ex_ford ex_mkt

test ex_mkt = 1

/* --- para general electric (incisos b, e) --- */
regress ex_ge ex_mkt

test ex_mkt = 1


*-------------------------------------
*-------------------------------------
*----CODIGO PARA EL EJERCICIO 3.22----
*-------------------------------------
*-------------------------------------


/* 1. Obtener las medias de las variables (necesarias para el inciso a) */
summarize price sqft

/* 2. Correr la regresión principal (necesaria para casi todos los incisos) */
regress price sqft

/* 3. Calcular la elasticidad y su IC (para los incisos a y b) */
margins, eyex(sqft) atmeans

/* 4. Estimar el precio esperado y su IC para una casa de 2000 sqft (para el inciso d) */
margins, at(sqft = 20)

/* 5. Calcular el precio promedio de las casas de 2000 sqft en la muestra (para el inciso e) */
summarize price if sqft == 20


*-------------------------------------
*-------------------------------------
*----CODIGO PARA EL EJERCICIO 3.23----
*-------------------------------------
*-------------------------------------


/* 1. Generar la variable de pies cuadrados al cuadrado */
generate sqft2 = sqft^2

/* 2. Correr la regresión cuadrática (es la base para todo) */
regress price sqft2

/* 3. Calcular el efecto marginal para una casa de 2000 pies cuadrados (para el inciso a) */
/* El efecto marginal es 2*a2*sqft. Para 2000 pies (sqft=20), es 2*a2*20 = 40*a2 */
lincom 40 * sqft2

/* 4. Calcular el efecto marginal para una casa de 4000 pies cuadrados (para el inciso b) */
/* Para 4000 pies (sqft=40), es 2*a2*40 = 80*a2 */
lincom 80 * sqft2

/* 5. Estimar el precio esperado para una casa de 2000 pies cuadrados (para el inciso c) */
/* Para 2000 pies (sqft=20), sqft2 es 400 */
margins, at(sqft2 = 400)

/* 6. Calcular el precio promedio de las casas de 2000 pies cuadrados en la muestra (para el inciso d) */
summarize price if sqft == 20

*-------------------------------------
*-------------------------------------
*----CODIGO PARA EL EJERCICIO 3.24----
*-------------------------------------
*-------------------------------------


/* 1. correr la regresión del voto contra el crecimiento */
regress vote growth

/* 2. estimar el voto esperado para un crecimiento de 4% y su ic del 95% */
margins, at(growth = 4)

/* 3. estimar el voto esperado para un crecimiento de 4% y su ic del 99% */
margins, at(growth = 4) level(99)

/* 4. correr la regresión del voto contra la inflación */
regress vote inflat


*-------------------------------------
*-------------------------------------
*----CODIGO PARA EL EJERCICIO 3.25----
*-------------------------------------
*-------------------------------------

/* 1. generar el logaritmo del precio  */
generate ln_rhammer = ln(rhammer)

/* --- para el inciso a --- */
/* 2. correr la regresión del precio contra la antigüedad */
regress ln_rhammer years_old if sold == 1

/* 3. calcular el cambio porcentual exacto y su ic del 95% */
nlcom 100 * (exp(_b[years_old]) - 1)

/* --- para el inciso b --- */
/* 4. probar la hipótesis de que el aumento es del 2% */
test years_old = 0.02

/* --- para el inciso c --- */
/* 5. correr la regresión del precio contra el indicador de recesión */
regress ln_rhammer drec if sold == 1	

/* 6. calcular la reducción porcentual exacta por vender en recesión y su ic del 95% */
nlcom 100 * (exp(_b[drec]) - 1)


*-------------------------------------
*-------------------------------------
*----CODIGO PARA EL EJERCICIO 3.26----
*-------------------------------------
*-------------------------------------

/* 1. regresión para la muestra completa (para incisos a y b) */
regress wage exper

/* 2. regresión para personas en áreas metropolitanas (para inciso c) */
regress wage exper if metro == 1

/* 3. regresión para personas fuera de áreas metropolitanas (para inciso d) */
regress wage exper if metro == 0


*-------------------------------------
*-------------------------------------
*----CODIGO PARA EL EJERCICIO 3.27----
*-------------------------------------
*-------------------------------------


/* 1. crear la variable exper30 */
generate exper30 = exper - 30

/* 2. describir la nueva variable (para inciso a) */
summarize exper30

/* 3. crear el término cuadrático */
generate exper30_sq = exper30^2

/* 4. correr la regresión cuadrática (para inciso b) */
regress wage exper30_sq

/* 5. generar los valores predichos para la gráfica (para inciso c) */
predict wage_hat, xb

/* 6. crear la gráfica de la relación cuadrática */
twoway (scatter wage_hat exper30) (qfit wage_hat exper30)

/* 7. calcular la pendiente cuando exper = 0 (exper30 = -30) (para inciso d y e) */
lincom -60 * exper30_sq

/* 8. calcular la pendiente cuando exper = 10 (exper30 = -20) (para inciso d y e) */
lincom -40 * exper30_sq

/* 9. calcular la pendiente cuando exper = 20 (exper30 = -10) (para inciso d y e) */
lincom -20 * exper30_sq



*-------------------------------------
*-------------------------------------
*----CODIGO PARA EL EJERCICIO 3.32----
*-------------------------------------
*-------------------------------------


/* 1. calcular estadísticas descriptivas para 1985 (para inciso a) */
summarize crmrte prbarr if year == 85

/* 2. crear la gráfica de dispersión (para inciso b) */
twoway (scatter crmrte prbarr if year == 85) (lfit crmrte prbarr if year == 85)

/* 3. correr la regresión lineal para 1985 (para incisos c y d) */
regress crmrte prbarr if year == 85

/* 4. calcular el efecto de un aumento de 10 puntos en prbarr (para inciso c) */
lincom 0.10 * prbarr








