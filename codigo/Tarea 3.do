*-------------------------------------------------------------------------------
* Tarea 5.13: Modelo de precios de vivienda en Baton Rouge
*-------------------------------------------------------------------------------


*-------------------------------------------------------------------------------
* INCISO (a): Modelo Lineal Simple
*-------------------------------------------------------------------------------
* (i) Estimar el modelo y obtener los coeficientes
regress price sqft age

* (ii) El intervalo de confianza del 95% para el coeficiente de sqft
* se muestra automáticamente en la tabla de resultados del comando anterior.

* (iii) Probar la hipótesis H0: B_age >= -1000 vs H1: B_age < -1000
* Stata realiza pruebas de dos colas. Haremos una prueba de una cola manualmente.
* Paso 1: Obtenemos el estadístico t.
* t = (b_age - (-1000)) / se(b_age)
display "Estadístico t para H0: B_age = -1000 es:"
display (_b[age] - (-1000)) / _se[age]
* Deberás comparar este valor t con el valor crítico t de una cola.

*-------------------------------------------------------------------------------
* INCISO (b): Modelo Cuadrático
*-------------------------------------------------------------------------------
* Generar las variables al cuadrado
generate sqft2 = sqft^2
generate age2 = age^2

* Estimar el nuevo modelo con los términos cuadráticos
regress price sqft age sqft2 age2

* (i) y (ii) Encontrar estimaciones de los efectos marginales
* Primero, necesitamos los valores mínimo y máximo de sqft y age
summarize sqft
local min_sqft = r(min)
local max_sqft = r(max)

summarize age
local min_age = r(min)
local max_age = r(max)

* Efecto marginal de sqft en la casa más pequeña, más grande y una de 2300 pies^2
margins, dydx(sqft) at(sqft=(`min_sqft' `max_sqft' 2300))

* Efecto marginal de age en la casa más nueva, más vieja y una de 20 años
margins, dydx(age) at(age=(`min_age' `max_age' 20))

* (iii) Encontrar el intervalo de confianza del 95% para el efecto marginal
* de sqft para una casa de 2300 pies^2.
* El comando `margins` anterior ya te da este intervalo.
lincom (_b[sqft] + 2 * _b[sqft2] * 2300)

* (iv) Probar la hipótesis para el efecto marginal de age para una casa de 20 años.
* H0: dprice/dage >= -1000 vs H1: dprice/dage < -1000
* El efecto marginal es: B_age + 2 * B_age2 * 20 = B_age + 40 * B_age2
* Usamos `testnl` para probar esta combinación no lineal.
testnl (_b[age] + 40 * _b[age2]) = -1000
* De nuevo, interpreta el resultado para una prueba de una cola.

*-------------------------------------------------------------------------------
* INCISO (c): Modelo con Interacción
*-------------------------------------------------------------------------------
* Crear la variable de interacción
generate sqft_age = sqft * age

* Estimar el modelo completo: cuadrático + interacción
regress price sqft age sqft2 age2 sqft_age

* Repetir (i), (ii), (iii) y (iv) usando sqft = 2300 y age = 20.
* Los efectos marginales ahora dependen de la otra variable.

* (i) y (iii) Efecto marginal de sqft y su IC del 95%
* (cuando sqft=2300 y age=20)
margins, dydx(sqft) at(sqft=2300 age=20)

* (ii) Efecto marginal de age (cuando sqft=2300 y age=20)
margins, dydx(age) at(sqft=2300 age=20)

* (iv) Probar la hipótesis para el efecto marginal de age
* (cuando sqft=2300 y age=20)
* H0: dprice/dage >= -1000 vs H1: dprice/dage < -1000
* El efecto marginal es: B_age + 2*B_age2*20 + B_sqft_age*2300
testnl (_b[age] + 40 * _b[age2] + 2300 * _b[sqft_age]) = -1000
* Interpreta el resultado para una prueba de una cola.

*-------------------------------------------------------------------------------
* INCISO (d): Sensibilidad del modelo
*-------------------------------------------------------------------------------
* No se requiere código para este inciso. Se trata de comparar los resultados
* de los modelos (a), (b) y (c) para discutir cómo las especificaciones
* afectan las conclusiones.
*-------------------------------------------------------------------------------




















*-------------------------------------------------------------------------------
* Tarea 5.14: Modelo Log-Lineal de Precios de Vivienda
*-------------------------------------------------------------------------------

* Cargar los datos (si no están ya cargados)
* insheet using br2.dat, clear names

* Generar las nuevas variables necesarias
generate sqft100 = sqft / 100
generate lnprice = ln(price)
generate age2 = age^2

*-------------------------------------------------------------------------------
* INCISO (a): Estimar la ecuación
*-------------------------------------------------------------------------------
regress lnprice sqft100 age age2

*-------------------------------------------------------------------------------
* INCISO (c): Encontrar e interpretar estimaciones del efecto marginal sobre ln(price)
*-------------------------------------------------------------------------------
* Para age = 5 y age = 20
margins, dydx(age) at(age=(5 20))

*-------------------------------------------------------------------------------
* INCISO (e): Estimar efectos marginales sobre price para una casa específica
*-------------------------------------------------------------------------------
* Para age = 20 y sqft = 2300 (es decir, sqft100 = 23)
* Usamos la opción 'expression' para obtener el efecto sobre el nivel de price, no el logaritmo.
margins, dydx(*) at(age=20 sqft100=23) expression(exp(predict()))

