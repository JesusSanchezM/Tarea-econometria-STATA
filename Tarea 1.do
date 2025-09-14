*-------------------------------------
*-------------------------------------
*----CODIGO PARA EL EJERCICIO 2.16----
*-------------------------------------
*-------------------------------------

*Inciso b
* Generar el exceso de retorno del mercado
gen excess_mkt = mkt - riskfree

* Generar el exceso de retorno para cada acción
foreach stock in ge ibm ford msft dis xom {
    gen excess_`stock' = `stock' - riskfree
}

* Microsoft
regress excess_msft excess_mkt

* General Electric
regress excess_ge excess_mkt

* Ford (General Motors en los resultados, asumo que es Ford)
regress excess_ford excess_mkt

* IBM
regress excess_ibm excess_mkt

* Disney
regress excess_dis excess_mkt

* Exxon-Mobil
regress excess_xom excess_mkt

*Inciso c
* Graficar dispersión de puntos
twoway (scatter excess_msft excess_mkt) (lfit excess_msft excess_mkt), title("Microsoft CAPM Regression") legend(off)

*Inciso d
* Microsoft sin intercepto
regress excess_msft excess_mkt, noconstant

* General Electric
regress excess_ge excess_mkt, noconstant

* Ford
regress excess_ford excess_mkt, noconstant

* IBM
regress excess_ibm excess_mkt, noconstant

* Disney
regress excess_dis excess_mkt, noconstant

* Exxon-Mobil
regress excess_xom excess_mkt, noconstant


*-------------------------------------
*-------------------------------------
*----CODIGO PARA EL EJERCICIO 2.17----
*-------------------------------------
*-------------------------------------


* a. Graficar precio de la casa contra tamaño en un diagrama de dispersión
scatter price sqft, title("Precio de casa vs. Tamaño") ytitle("Precio ($1000s)") xtitle("Pies Cuadrados (100s)")

* b. Estimar modelo de regresión lineal
regress price sqft

twoway (scatter price sqft) (lfit price sqft), ///
       title("Regresión Lineal: precio vs. Pies Cuadrados") ///
       ytitle("Precio ($1000s)") xtitle("Pies Cuadrados (100s)") ///
       legend(label(1 "Datos Reales") label(2 "Línea Ajustada"))

* c. Estimar modelo de regresión cuadrática
gen sqft2 = sqft^2
regress price sqft2


* d. Graficar curva ajustada y línea tangente
predict yhat_quad
twoway (scatter price sqft) (line yhat_quad sqft, sort), ///
       title("Modelo Cuadrático")


* f. Calcular residuales y graficar contra sqft
* Modelo lineal
regress price sqft
predict resid_linear, residuals
scatter resid_linear sqft, title("Residuales vs sqft - Modelo Lineal")

* Modelo cuadrático
regress price sqft2
predict resid_quad, residuals
scatter resid_quad sqft, title("Residuales vs sqft - Modelo Cuadrático")

* g. Comparar SSE para ambos modelos
* Modelo lineal
regress price sqft
display e(rss)  // Esto muestra la Suma de Cuadrados de los Residuales (SSE)

* Modelo cuadrático  
regress price sqft2
display e(rss)  // Comparar este SSE con el modelo lineal

* El modelo con menor SSE tiene mejor ajuste a los datos


*-------------------------------------
*-------------------------------------
*----CODIGO PARA EL EJERCICIO 2.18----
*-------------------------------------
*-------------------------------------

* a. Histogramas para price y ln(price)
histogram price, title("Histograma de price") name(hist_price, replace)
gen lnprice = ln(price)
histogram lnprice, title("Histograma de ln(price)") name(hist_lnprice, replace)

* b. Estimación del modelo log-lineal
regress lnprice sqft

* Interpretación de coeficientes
display "γ₁ = " _b[_cons]
display "γ₂ = " _b[sqft]

* Predecir valores ajustados
predict lnprice_hat
gen price_hat = exp(lnprice_hat)

* Gráfico de la curva ajustada
twoway (scatter price sqft) (line price_hat sqft, sort), ///
       title("Curva Ajustada de precio: price = exp(γ₁ + γ₂·sqft)") ///
       ytitle("Precio ($1000s)") xtitle("Pies Cuadrados (100s)") ///
       name(fitted_curve, replace)

* Pendiente de la línea tangente para 2000 pies cuadrados (sqft = 20)
local gamma2 = _b[sqft]
display "Pendiente de la línea tangente a 2000 pies cuadrados: " `gamma2' * exp(_b[_cons] + `gamma2'*20)

* c. Residuales y gráfico contra sqft
predict resid_log, residuals
scatter resid_log sqft, title("Residuales vs sqft - Modelo Log-lineal") ///
       yline(0) name(resid_plot, replace)
	   
*-------------------------------------
*-------------------------------------
*----CODIGO PARA EL EJERCICIO 2.23----
*-------------------------------------
*-------------------------------------   


* Crear variable de tiempo para subconjuntos
gen period = 1 if year <= 2012
replace period = 2 if year == 2016

* Parte a: Diagrama de dispersión para 1916-2012
twoway (scatter vote growth if period == 1), ///
       title("Diagrama de Dispersión: VOTE vs GROWTH (1916-2012)") ///
       ytitle("Porcentaje de Votos Demócratas (%)") ///
       xtitle("GROWTH (INCUMB × Tasa de Crecimiento)") ///
       name(scatter_growth, replace)

* Parte b: Regresión para 1916-2012
regress vote growth if period == 1
estimates store growth_model

* Graficar línea ajustada en el diagrama de dispersión
twoway (scatter vote growth if period == 1) ///
       (lfit vote growth if period == 1), ///
       title("VOTE vs GROWTH con Línea Ajustada (1916-2012)") ///
       ytitle("Porcentaje de Votos Demócratas (%)") ///
       xtitle("GROWTH (INCUMB × Tasa de Crecimiento)") ///
       legend(label(1 "Real") label(2 "Ajustado")) ///
       name(fitted_growth, replace)

* Parte c: Predicción para 2016
* Primero, obtener el valor de GROWTH para 2016 (necesitas agregar esto a tus datos)
preserve
keep if year == 2016
local growth_2016 = growth
restore

* Predecir voto 2016 basado en el modelo de crecimiento
display "VOTO Predicho para 2016 basado en modelo GROWTH: " _b[_cons] + _b[growth]*`growth_2016'

* Comparar con valor real de 2016 (necesitas agregar voto 2016 a tus datos)
preserve
keep if year == 2016
local actual_vote_2016 = vote
restore

display "VOTO Real para 2016: `actual_vote_2016'"

* Parte d: Diagrama de dispersión para INFLAT 1916-2012
twoway (scatter vote inflat if period == 1), ///
       title("Diagrama de Dispersión: VOTE vs INFLAT (1916-2012)") ///
       ytitle("Porcentaje de Votos Demócratas (%)") ///
       xtitle("INFLAT (INCUMB × Tasa de Inflación)") ///
       name(scatter_inflat, replace)

* Parte e: Regresión para INFLAT 1916-2012
regress vote inflat if period == 1
estimates store inflat_model

* Parte f: Predicción para 2016 usando modelo INFLAT
* Obtener el valor de INFLAT para 2016 (necesitas agregar esto a tus datos)
preserve
keep if year == 2016
local inflat_2016 = inflat
restore

* Predecir voto 2016 basado en modelo de inflación
display "VOTO Predicho para 2016 basado en modelo INFLAT: " _b[_cons] + _b[inflat]*`inflat_2016'
display "VOTO Real para 2016: `actual_vote_2016'"

* Guardar resultados para comparación
estimates table growth_model inflat_model, stats(N r2) b(%7.3f) se(%7.3f)


*-------------------------------------
*-------------------------------------
*----CODIGO PARA EL EJERCICIO 2.28----
*-------------------------------------
*-------------------------------------  


* 1a. Resumen estadístico e histogramas
summarize wage educ
histogram wage, title("Histograma de wage") normal
histogram educ, title("Histograma de educ") normal

* 1b. Regresión lineal
regress wage educ
estimates store linear_model

* 1c. Residuos de MCO
predict residuals, residuals
scatter residuals educ, title("Residuos vs educ") yline(0)

* 1d. Regresiones separadas por grupos
* Para hombres y mujeres
regress wage educ if female == 0
estimates store males
regress wage educ if female == 1  
estimates store females

* Para blancos y negros
regress wage educ if black == 0
estimates store whites
regress wage educ if black == 1
estimates store blacks

* Comparar resultados
estimates table linear_model males females whites blacks, star stats(N r2)

* 1e. Regresión cuadrática
gen educ2 = educ^2
regress wage educ educ2
estimates store quadratic_model

* Efectos marginales
* Para persona con 12 años de educación
margins, at(educ=12) dydx(educ)
* Para persona con 16 años de educación  
margins, at(educ=16) dydx(educ)

* Comparar con efecto marginal del modelo lineal
margins, dydx(educ)



*-------------------------------------
*-------------------------------------
*----CODIGO PARA EL EJERCICIO 2.29----
*-------------------------------------
*-------------------------------------  



* b. Regresión log-lineal
gen ln_wage = ln(wage)
regress ln_wage educ
estimates store loglinear_model

* c. Predicciones para 12 y 16 años de educación
* Para 12 años
scalar pred_log_12 = exp(_b[_cons] + _b[educ]*12)
* Para 16 años  
scalar pred_log_16 = exp(_b[_cons] + _b[educ]*16)

* Mostrar predicciones
display "Salario predicho con 12 años de educación: " pred_log_12
display "Salario predicho con 16 años de educación: " pred_log_16

* d. Efectos marginales
* Efecto marginal = b2 * exp(b1 + b2*EDUC)
* Para 12 años
scalar me_12 = _b[educ] * exp(_b[_cons] + _b[educ]*12)
* Para 16 años
scalar me_16 = _b[educ] * exp(_b[_cons] + _b[educ]*16)

* Mostrar efectos marginales
display "Efecto marginal con 12 años de educación: " me_12
display "Efecto marginal con 16 años de educación: " me_16

* e. Gráfico comparativo
* Valores ajustados del modelo log-lineal
predict y_hat_log
gen wage_hat_log = exp(y_hat_log)

* Valores ajustados del modelo lineal (del ejercicio anterior)
regress wage educ
predict wage_hat_linear

* Crear gráfico
twoway (scatter wage educ, msize(tiny)) ///
       (line wage_hat_linear educ, sort lcolor(blue)) ///
       (line wage_hat_log educ, sort lcolor(red)), ///
       title("Comparación de Modelos: Lineal vs Log-Lineal") ///
       ytitle("Salario por hora (WAGE)") ///
       xtitle("Años de educación (EDUC)") ///
       legend(order(2 "Modelo Lineal" 3 "Modelo Log-Lineal"))

















	   