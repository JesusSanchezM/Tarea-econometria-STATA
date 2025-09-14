*-------------------------------------
*-------------------------------------
*----CODIGO PARA EL EJERCICIO 3.21----
*-------------------------------------
*-------------------------------------

*aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
* Calcular exceso de retorno
gen excess_ge = ge - riskfree
gen excess_ford = ford - riskfree
gen excess_msft = msft - riskfree
gen excess_xom = xom - riskfree
gen excess_mkt = mkt - riskfree

* Regresión CAPM para cada acción
reg excess_ge excess_mkt, robust
reg excess_ford excess_mkt, robust
reg excess_msft excess_mkt, robust
reg excess_xom excess_mkt, robust

* Para obtener intervalo del 95% de beta:
reg excess_xom excess_mkt, robust
* Luego mirar el coeficiente de excess_mkt y su 95% CI


*bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
reg excess_ford excess_mkt, robust
test excess_mkt = 1

reg excess_ge excess_mkt, robust
test excess_mkt = 1

reg excess_xom excess_mkt, robust
test excess_mkt = 1


*ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
reg excess_xom excess_mkt, robust
test excess_mkt = 1


*dddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
reg excess_msft excess_mkt, robust
test excess_mkt = 1


*eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
reg excess_ford excess_mkt, robust
test _cons = 0

reg excess_ge excess_mkt, robust
test _cons = 0

reg excess_xom excess_mkt, robust
test _cons = 0


*-------------------------------------
*-------------------------------------
*----CODIGO PARA EL EJERCICIO 3.22----
*-------------------------------------
*-------------------------------------


/* 2. Obtener las medias de las variables (necesarias para el inciso a) */
summarize price sqft

/* 3. Correr la regresión principal (necesaria para casi todos los incisos) */
regress price sqft

/* 4. Calcular la elasticidad y su IC (para los incisos a y b) */
margins, eyex(sqft) atmeans

/* 5. Estimar el precio esperado y su IC para una casa de 2000 sqft (para el inciso d) */
margins, at(sqft = 20)

/* 6. Calcular el precio promedio de las casas de 2000 sqft en la muestra (para el inciso e) */
summarize price if sqft == 20


*-------------------------------------
*-------------------------------------
*----CODIGO PARA EL EJERCICIO 3.23----
*-------------------------------------
*-------------------------------------


/* 2. Generar la variable de pies cuadrados al cuadrado */
generate sqft2 = sqft^2

/* 3. Correr la regresión cuadrática (es la base para todo) */
regress price sqft2

/* 4. Calcular el efecto marginal para una casa de 2000 pies cuadrados (para el inciso a) */
/* El efecto marginal es 2*a2*sqft. Para 2000 pies (sqft=20), es 2*a2*20 = 40*a2 */
lincom 40 * sqft2

/* 5. Calcular el efecto marginal para una casa de 4000 pies cuadrados (para el inciso b) */
/* Para 4000 pies (sqft=40), es 2*a2*40 = 80*a2 */
lincom 80 * sqft2

/* 6. Estimar el precio esperado para una casa de 2000 pies cuadrados (para el inciso c) */
/* Para 2000 pies (sqft=20), sqft2 es 400 */
margins, at(sqft2 = 400)

/* 7. Calcular el precio promedio de las casas de 2000 pies cuadrados en la muestra (para el inciso d) */
summarize price if sqft == 20

*-------------------------------------
*-------------------------------------
*----CODIGO PARA EL EJERCICIO 3.24----
*-------------------------------------
*-------------------------------------


/* 3. correr la regresión del voto contra el crecimiento */
/* --- pásame el resultado de este comando --- */
regress vote growth

/* 4. estimar el voto esperado para un crecimiento de 4% y su ic del 95% */
/* --- pásame el resultado de este comando --- */
margins, at(growth = 4)

/* 5. estimar el voto esperado para un crecimiento de 4% y su ic del 99% */
/* --- pásame el resultado de este comando --- */
margins, at(growth = 4) level(99)

/* 7. correr la regresión del voto contra la inflación */
/* --- pásame el resultado de este comando --- */
regress vote inflat


*-------------------------------------
*-------------------------------------
*----CODIGO PARA EL EJERCICIO 3.25----
*-------------------------------------
*-------------------------------------


/* 1. cargar los datos */
use ashcan_small, clear

/* 2. generar el logaritmo del precio (si no lo tienes ya) */
generate ln_rhammer = ln(rhammer)

/* --- para el inciso a --- */
/* 3. correr la regresión del precio contra la antigüedad */
regress ln_rhammer years_old if sold == 1

/* 4. calcular el cambio porcentual exacto y su ic del 95% */
/* --- pásame el resultado de este comando --- */
nlcom 100 * (exp(_b[years_old]) - 1)

/* --- para el inciso b --- */
/* 5. probar la hipótesis de que el aumento es del 2% */
/* --- pásame el resultado de este comando --- */
test years_old = 0.02

/* --- para el inciso c --- */
/* 6. correr la regresión del precio contra el indicador de recesión */
/* --- pásame el resultado de este comando --- */
regress ln_rhammer drec if sold == 1	

/* 7. calcular la reducción porcentual exacta por vender en recesión y su ic del 95% */
/* --- pásame el resultado de este comando --- */
nlcom 100 * (exp(_b[drec]) - 1)


*-------------------------------------
*-------------------------------------
*----CODIGO PARA EL EJERCICIO 3.26----
*-------------------------------------
*-------------------------------------

/* 2. regresión para la muestra completa (para incisos a y b) */
/* --- pásame el resultado de este comando --- */
regress wage exper

/* 3. regresión para personas en áreas metropolitanas (para inciso c) */
/* --- pásame el resultado de este comando --- */
regress wage exper if metro == 1

/* 4. regresión para personas fuera de áreas metropolitanas (para inciso d) */
/* --- pásame el resultado de este comando --- */
regress wage exper if metro == 0


*-------------------------------------
*-------------------------------------
*----CODIGO PARA EL EJERCICIO 3.26----
*-------------------------------------
*-------------------------------------


/* 2. crear la variable exper30 */
generate exper30 = exper - 30

/* 3. describir la nueva variable (para inciso a) */
/* --- pásame el resultado de este comando --- */
summarize exper30

/* 4. crear el término cuadrático */
generate exper30_sq = exper30^2

/* 5. correr la regresión cuadrática (para inciso b) */
/* --- pásame el resultado de este comando --- */
regress wage exper30_sq

/* 6. generar los valores predichos para la gráfica (para inciso c) */
predict wage_hat, xb

/* 7. crear la gráfica de la relación cuadrática */
/* --- solo describe o manda una captura de la gráfica que te aparezca --- */
twoway (scatter wage_hat exper30) (qfit wage_hat exper30), sort

/* 8. calcular la pendiente cuando exper = 0 (exper30 = -30) (para inciso d y e) */
/* --- pásame el resultado de este comando --- */
lincom -60 * exper30_sq

/* 9. calcular la pendiente cuando exper = 10 (exper30 = -20) (para inciso d y e) */
/* --- pásame el resultado de este comando --- */
lincom -40 * exper30_sq

/* 10. calcular la pendiente cuando exper = 20 (exper30 = -10) (para inciso d y e) */
/* --- pásame el resultado de este comando --- */
lincom -20 * exper30_sq



*-------------------------------------
*-------------------------------------
*----CODIGO PARA EL EJERCICIO 3.32----
*-------------------------------------
*-------------------------------------



/* 2. calcular estadísticas descriptivas para 1985 (para inciso a) */
/* --- pásame el resultado de este comando --- */
summarize crmrte prbarr if year == 85

/* 3. crear la gráfica de dispersión (para inciso b) */
/* --- descríbeme o mándame la gráfica que te aparezca --- */
twoway (scatter crmrte prbarr if year == 85) (lfit crmrte prbarr if year == 85)

/* 4. correr la regresión lineal para 1985 (para incisos c y d) */
/* --- pásame el resultado de este comando --- */
regress crmrte prbarr if year == 85

/* 5. calcular el efecto de un aumento de 10 puntos en prbarr (para inciso c) */
/* --- pásame el resultado de este comando --- */
lincom 0.10 * prbarr
