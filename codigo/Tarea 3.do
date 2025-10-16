*-------------------------------------------------------------------------------
* Tarea 5.13: Modelo de precios de vivienda en Baton Rouge
*-------------------------------------------------------------------------------

* Primero, asegúrate de que Stata esté apuntando a la carpeta donde tienes
* el archivo "br2.dat". Puedes usar el menú (File > Change working directory)
* o el comando `cd "C:\Tu\Ruta\De\Carpeta"`.

* Cargar los datos. Asumimos que es un archivo de texto delimitado por tabulaciones o espacios.
insheet using br2.dat, clear names

*-------------------------------------------------------------------------------
* INCISO (a): Modelo Lineal Simple
*-------------------------------------------------------------------------------
* (i) Estimar el modelo y obtener los coeficientes
regress PRICE SQFT AGE

* (ii) El intervalo de confianza del 95% para el coeficiente de SQFT
* se muestra automáticamente en la tabla de resultados del comando anterior.

* (iii) Probar la hipótesis H0: B_AGE >= -1000 vs H1: B_AGE < -1000
* Stata realiza pruebas de dos colas. Haremos una prueba de una cola manualmente.
* Paso 1: Obtenemos el estadístico t.
* t = (b_AGE - (-1000)) / se(b_AGE)
display "Estadístico t para H0: B_AGE = -1000 es:"
display (_b[AGE] - (-1000)) / _se[AGE]
* Deberás comparar este valor t con el valor crítico t de una cola.

*-------------------------------------------------------------------------------
* INCISO (b): Modelo Cuadrático
*-------------------------------------------------------------------------------
* Generar las variables al cuadrado
generate SQFT2 = SQFT^2
generate AGE2 = AGE^2

* Estimar el nuevo modelo con los términos cuadráticos
regress PRICE SQFT AGE SQFT2 AGE2

* (i) y (ii) Encontrar estimaciones de los efectos marginales
* Primero, necesitamos los valores mínimo y máximo de SQFT y AGE
summarize SQFT
local min_sqft = r(min)
local max_sqft = r(max)

summarize AGE
local min_age = r(min)
local max_age = r(max)

* Efecto marginal de SQFT en la casa más pequeña, más grande y una de 2300 pies^2
margins, dydx(SQFT) at(SQFT=(`min_sqft' `max_sqft' 2300))

* Efecto marginal de AGE en la casa más nueva, más vieja y una de 20 años
margins, dydx(AGE) at(AGE=(`min_age' `max_age' 20))

* (iii) Encontrar el intervalo de confianza del 95% para el efecto marginal
* de SQFT para una casa de 2300 pies^2.
* El comando `margins` anterior ya te da este intervalo.

* (iv) Probar la hipótesis para el efecto marginal de AGE para una casa de 20 años.
* H0: dPRICE/dAGE >= -1000 vs H1: dPRICE/dAGE < -1000
* El efecto marginal es: B_AGE + 2 * B_AGE2 * 20 = B_AGE + 40 * B_AGE2
* Usamos `testnl` para probar esta combinación no lineal.
testnl (_b[AGE] + 40 * _b[AGE2]) = -1000
* De nuevo, interpreta el resultado para una prueba de una cola.

*-------------------------------------------------------------------------------
* INCISO (c): Modelo con Interacción
*-------------------------------------------------------------------------------
* Crear la variable de interacción
generate SQFT_AGE = SQFT * AGE

* Estimar el modelo completo: cuadrático + interacción
regress PRICE SQFT AGE SQFT2 AGE2 SQFT_AGE

* Repetir (i), (ii), (iii) y (iv) usando SQFT = 2300 y AGE = 20.
* Los efectos marginales ahora dependen de la otra variable.

* (i) y (iii) Efecto marginal de SQFT y su IC del 95%
* (cuando SQFT=2300 y AGE=20)
margins, dydx(SQFT) at(SQFT=2300 AGE=20)

* (ii) Efecto marginal de AGE (cuando SQFT=2300 y AGE=20)
margins, dydx(AGE) at(SQFT=2300 AGE=20)

* (iv) Probar la hipótesis para el efecto marginal de AGE
* (cuando SQFT=2300 y AGE=20)
* H0: dPRICE/dAGE >= -1000 vs H1: dPRICE/dAGE < -1000
* El efecto marginal es: B_AGE + 2*B_AGE2*20 + B_SQFT_AGE*2300
testnl (_b[AGE] + 40 * _b[AGE2] + 2300 * _b[SQFT_AGE]) = -1000
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
generate SQFT100 = SQFT / 100
generate lnPRICE = ln(PRICE)
generate AGE2 = AGE^2

*-------------------------------------------------------------------------------
* INCISO (a): Estimar la ecuación
*-------------------------------------------------------------------------------
regress lnPRICE SQFT100 AGE AGE2

*-------------------------------------------------------------------------------
* INCISO (c): Encontrar e interpretar estimaciones del efecto marginal sobre ln(PRICE)
*-------------------------------------------------------------------------------
* Para AGE = 5 y AGE = 20
margins, dydx(AGE) at(AGE=(5 20))

*-------------------------------------------------------------------------------
* INCISO (e): Estimar efectos marginales sobre PRICE para una casa específica
*-------------------------------------------------------------------------------
* Para AGE = 20 y SQFT = 2300 (es decir, SQFT100 = 23)
* Usamos la opción 'expression' para obtener el efecto sobre el nivel de PRICE, no el logaritmo.
margins, dydx(*) at(age=20 sqft100=23) expression(exp(predict()))

