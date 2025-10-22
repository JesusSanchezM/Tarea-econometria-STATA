*-------------------------------------
*-------------------------------------
*----CODIGO PARA EL EJERCICIO 6.25----
*-------------------------------------
*-------------------------------------



* Generar las variables necesarias para el modelo base
gen lnprice = ln(price)
gen age2 = age^2


* --- Pregunta (a) ---
* --------------------------------------------------------------------
* Estimar el modelo y reportar coeficientes y errores estándar
* ln(PRICE) = b1 + b2*SQFT + b3*AGE + b4*AGE^2 + e
reg lnprice sqft age age2


* --- Pregunta (b) ---
* --------------------------------------------------------------------
* Graficar E[ln(PRICE)|SQFT=22, AGE] contra AGE
* 1. Generar la predicción usando los coeficientes de la regresión anterior
* E[ln(price)] = _b[_cons] + _b[sqft]*22 + _b[age]*age + _b[age2]*age^2
gen lnprice_hat_b = _b[_cons] + _b[sqft]*22 + _b[age]*age + _b[age2]*age2

* 2. Graficar la predicción contra la edad (ordenamos por 'age' para la línea)
twoway (line lnprice_hat_b age, sort(age)), ///
    ytitle("E[ln(price)|sqft=22, age]") xtitle("Edad (age)") ///
    title("Precio de la vivienda (log) vs. Edad")


* --- Pregunta (c) ---
* --------------------------------------------------------------------
* Prueba de hipótesis conjunta (F-test) después del modelo base
* (Corremos el 'reg' de nuevo por si acaso)
reg lnprice sqft age age2

* H0(i): E[ln(price)] es el mismo para age=5 y age=80 (dado sqft)
* b3*5 + b4*5^2 = b3*80 + b4*80^2
* 0 = 75*b3 + 6375*b4
* H0(ii): E[ln(price)] es el mismo para (sqft=20, age=5) y (sqft=28, age=30)
* b2*20 + b3*5 + b4*5^2 = b2*28 + b3*30 + b4*30^2
* 0 = 8*b2 + 25*b3 + 875*b4
* (Nota: 2000 sqft = 20, 2800 sqft = 28)

test (75*age + 6375*age2 = 0) (8*sqft + 25*age + 875*age2 = 0)


* --- Pregunta (d) ---
* --------------------------------------------------------------------
* Prueba de hipótesis conjunta (F-test) después del modelo base
reg lnprice sqft age age2

* H0(i): El efecto marginal de 'age' es 0 a los 50 años.
* d(lnprice)/d(age) = b3 + 2*b4*age
* Evaluado en age=50: b3 + 2*b4*50 = b3 + 100*b4 = 0
* H0(ii): El precio esperado para sqft=22, age=50 es $100,000 (price=100)
* E[lnprice] = b1 + b2*22 + b3*50 + b4*50^2 = ln(100)
* (b1 = _cons)

lincom _cons + 22*sqft + 50*age + 2500*age2



* --- Pregunta (e) ---
* --------------------------------------------------------------------
* Añadir 'baths' y 'sqft * bedrooms'
* 1. Generar la variable de interacción
gen sqft_x_bedrooms = sqft * bedrooms

* 2. Estimar el modelo ampliado
reg lnprice sqft age age2 baths sqft_x_bedrooms


* --- Pregunta (f) ---
* --------------------------------------------------------------------
* Prueba F de significancia conjunta para las nuevas variables
* (Debe ejecutarse justo después de la regresión de 'e')
* H0: b_baths = 0 Y b_sqft_x_bedrooms = 0
test (baths = 0) (sqft_x_bedrooms = 0)


* --- Pregunta (g) ---
* --------------------------------------------------------------------
* Estimar el incremento en el valor (usando el modelo de 'e')
* (Corremos el 'reg' de 'e' de nuevo para tener los coeficientes listos)
reg lnprice sqft age age2 baths sqft_x_bedrooms

* Escenario 1 (Base): age=0, sqft=23, bedrooms=3, baths=2
* sqft_x_bedrooms = 23 * 3 = 69
scalar lnprice1 = _b[_cons] + _b[sqft]*23 + _b[age]*0 + _b[age2]*0 + ///
                  _b[baths]*2 + _b[sqft_x_bedrooms]*(69)

* Escenario 2 (Mejorada): age=0, sqft=25.6, bedrooms=4, baths=3
* (sqft = 2300+260 = 2560 pies^2 -> 25.6)
* sqft_x_bedrooms = 25.6 * 4 = 102.4
scalar lnprice2 = _b[_cons] + _b[sqft]*25.6 + _b[age]*0 + _b[age2]*0 + ///
                  _b[baths]*3 + _b[sqft_x_bedrooms]*(102.4)

* Convertir a precios (predictor natural exp(E[ln(price)]))
scalar price1 = exp(lnprice1)
scalar price2 = exp(lnprice2)

* Calcular el incremento en valor (en miles de dólares)
scalar incremento_g = price2 - price1
di "Respuesta (g): Incremento estimado en el valor (en miles de $):"
di incremento_g


* --- Pregunta (h) ---
* --------------------------------------------------------------------
* Estimar el "valor extra" de la casa (mejorada) en 20 años
* (Usamos el modelo de 'e' y los coeficientes de la última regresión)

* Escenario 3 (Mejorada, 20 años después):
* age=20, age2=400, sqft=25.6, bedrooms=4, baths=3
* sqft_x_bedrooms = 102.4 (igual que en g)
scalar lnprice3 = _b[_cons] + _b[sqft]*25.6 + _b[age]*20 + _b[age2]*400 + ///
                  _b[baths]*3 + _b[sqft_x_bedrooms]*(102.4)

* Precio predicho a los 20 años
scalar price3 = exp(lnprice3)

* "Valor extra" = Cambio en el valor de la casa mejorada (price3) 
* comparado con cuando era nueva (price2 de la parte g)
scalar extra_valor_h = price3 - price2
di "Respuesta (h): Valor extra estimado después de 20 años (en miles de $):"
di extra_valor_h
di "(Interpretado como: price_hat(age=20) - price_hat(age=0) para la casa mejorada)"













*-------------------------------------
*-------------------------------------
*----CODIGO PARA EL EJERCICIO 7.26----
*-------------------------------------
*-------------------------------------



* --- Pregunta (a) ---
* -----------------------------------------------------------------------------
* Resumen de datos e histograma de PRICE
display "--- RESULTADOS PREGUNTA (a) ---"
summarize price sqft bedrooms baths age owner traditional fireplace waterfront pool
histogram price, normal width(50000) title("Histograma de PRECIO (PRICE)")


* --- Pregunta (b) ---
* -----------------------------------------------------------------------------
* Generar variables transformadas
gen lnprice = ln(price/1000)
gen sqft100 = sqft/100

* Estimar el modelo de regresión base
display "--- RESULTADOS PREGUNTA (b) ---"
reg lnprice sqft100 bedrooms baths age owner traditional fireplace waterfront pool

* (Para la interpretación exacta de waterfront: e^beta - 1)
lincom waterfront, eform
display "Interpretación exacta (b): (exp(beta_waterfront) - 1) * 100%"


* --- Pregunta (c) ---
* -----------------------------------------------------------------------------
* Crear variable de interacción y reestimar
gen water_trad = waterfront * traditional

display "--- RESULTADOS PREGUNTA (c) ---"
reg lnprice sqft100 bedrooms baths age owner traditional fireplace waterfront pool water_trad


* --- Pregunta (d) ---
* -----------------------------------------------------------------------------
* Prueba de Chow (usando el método de interacción completa)
* H0: Los modelos para traditional=1 y traditional=0 son idénticos.

* 1. Generar interacciones para todas las variables
* (Nota: 'traditional' es el "intercepto" del grupo)
gen i_sqft100 = traditional * sqft100
gen i_bedrooms = traditional * bedrooms
gen i_baths = traditional * baths
gen i_age = traditional * age
gen i_owner = traditional * owner
gen i_fireplace = traditional * fireplace
gen i_waterfront = traditional * waterfront
gen i_pool = traditional * pool

* 2. Correr el modelo "sin restricciones" (completamente interactuado)
reg lnprice sqft100 bedrooms baths age owner fireplace waterfront pool ///
            traditional i_sqft100 i_bedrooms i_baths i_age i_owner ///
            i_fireplace i_waterfront i_pool

* 3. Ejecutar la prueba F conjunta (Prueba de Chow)
* H0: Todos los términos de interacción + el dummy 'traditional' son = 0
display "--- RESULTADOS PREGUNTA (d): Prueba de Chow ---"
testparm traditional i_*


* --- Pregunta (e) ---
* -----------------------------------------------------------------------------
* Predecir el valor usando el modelo de la parte (c)
* (Usamos el modelo 'c' ya que 'd' es una prueba de hipótesis)

* 1. Volver a correr el modelo (c) para asegurar que los coeficientes (e(b)) están cargados
reg lnprice sqft100 bedrooms baths age owner traditional fireplace waterfront pool water_trad

* 2. Definir los valores para la predicción
* !! IMPORTANTE !!
* El problema NO especifica BEDS o BATHS. Asumimos 3 y 2.
* ¡Cámbialos si es necesario!
scalar BEDS_val = 3
scalar BATHS_val = 2

* Valores dados en la pregunta (e)
scalar SQFT100_val = 2500 / 100
scalar AGE_val = 20
scalar OWNER_val = 1
scalar TRAD_val = 1
scalar FIRE_val = 1
scalar POOL_val = 0
scalar WATER_val = 0
scalar WATER_TRAD_val = scalar(WATER_val) * scalar(TRAD_val)

* 3. Calcular ln(price/1000) predicho
scalar lnprice_pred = _b[_cons] + ///
                      _b[sqft100]*scalar(SQFT100_val) + ///
                      _b[bedrooms]*scalar(BEDS_val) + ///
                      _b[baths]*scalar(BATHS_val) + ///
                      _b[age]*scalar(AGE_val) + ///
                      _b[owner]*scalar(OWNER_val) + ///
                      _b[traditional]*scalar(TRAD_val) + ///
                      _b[fireplace]*scalar(FIRE_val) + ///
                      _b[waterfront]*scalar(WATER_val) + ///
                      _b[pool]*scalar(POOL_val) + ///
                      _b[water_trad]*scalar(WATER_TRAD_val)

* 4. Convertir a precio en dólares ($)
scalar price_pred = exp(scalar(lnprice_pred)) * 1000

display "--- RESULTADOS PREGUNTA (e) ---"
display "Valores supuestos: Habitaciones=" scalar(BEDS_val) ", Baños=" scalar(BATHS_val)
display "ln(price/1000) predicho: " scalar(lnprice_pred)
display "Valor (PRICE) predicho en $: " scalar(price_pred)
