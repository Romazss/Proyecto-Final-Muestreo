# Referencias Técnicas - Estimación con Diseño Complejo CASEN 2022

Este documento complementa el beamer principal con detalles técnicos, fórmulas y ecuaciones de referencia.

---

## 1. ESTIMADORES BAJO DISEÑO COMPLEJO

### 1.1 Estimador de Horvitz-Thompson (HT)

Para estimar el total poblacional de una variable $Y$:

$$\hat{Y}_{HT} = \sum_{i \in s} \frac{y_i}{\pi_i} = \sum_{i \in s} w_i \cdot y_i$$

donde:
- $s$ = muestra seleccionada
- $y_i$ = valor observado de la variable para la unidad $i$
- $\pi_i$ = probabilidad de inclusión de la unidad $i$
- $w_i = 1/\pi_i$ = peso o factor de expansión de la unidad $i$

**En CASEN 2022:** El factor de expansión es la variable `expr`.

---

### 1.2 Estimador de la Media (Hájek)

El estimador de la media poblacional es:

$$\hat{\bar{Y}} = \frac{\sum_{i \in s} w_i \cdot y_i}{\sum_{i \in s} w_i} = \frac{\hat{Y}_{HT}}{\hat{N}}$$

donde $\hat{N} = \sum_{i \in s} w_i$ es la estimación del tamaño poblacional.

**Propiedades:**
- Aproximadamente insesgado (razón de estimadores HT)
- Consistente bajo diseño
- Más estable que HT puro cuando los pesos varían mucho

---

### 1.3 Estimador de una Proporción

Para una variable binaria $Y$ (0/1), la proporción poblacional se estima como:

$$\hat{p} = \frac{\sum_{i \in s} w_i \cdot y_i}{\sum_{i \in s} w_i}$$

**Ejemplo CASEN:** Proporción de hogares en situación de pobreza.

---

## 2. VARIANZAS BAJO DISEÑO ESTRATIFICADO BIETÁPICO

### 2.1 Varianza del Estimador HT (Total)

Para un diseño estratificado bietápico con UPM seleccionadas con PPT y elementos seleccionados con MAS en segunda etapa:

$$V(\hat{Y}_{HT}) = \sum_{h=1}^{H} \left[ \left(1 - \frac{n_h}{N_h}\right) \frac{1}{n_h(n_h-1)} \sum_{i=1}^{n_h} (z_{hi} - \bar{z}_h)^2 \right]$$

donde:
- $H$ = número de estratos
- $n_h$ = número de UPM seleccionadas en el estrato $h$
- $N_h$ = número total de UPM en el estrato $h$ (del marco)
- $z_{hi}$ = valor linealizado para la UPM $i$ del estrato $h$
- $\bar{z}_h = \frac{1}{n_h} \sum_{i=1}^{n_h} z_{hi}$

**Nota:** El término $(1 - n_h/N_h)$ es la **corrección por población finita (fpc)**.

---

### 2.2 Varianza del Estimador de la Media (Linealización de Taylor)

Para el estimador de la media $\hat{\bar{Y}}$, usando linealización de Taylor:

$$V(\hat{\bar{Y}}) \approx \sum_{h=1}^{H} \frac{1-f_h}{n_h} \cdot \frac{1}{n_h-1} \sum_{i=1}^{n_h} (e_{hi} - \bar{e}_h)^2$$

donde:
- $f_h = n_h/N_h$ = fracción de muestreo
- $e_{hi} = y_{hi} - \hat{\bar{Y}}$ = residuo linealizado (forma simplificada)

**Versión completa con pesos:**

$$e_{hi} = \frac{w_i(y_i - \hat{\bar{Y}})}{\sum_{i \in s} w_i}$$

---

### 2.3 Enfoque EVCU/WR (CASEN 2022)

CASEN 2022 usa el enfoque **EVCU (Elemento de Variación en Conglomerados Últimos)** con aproximación **WR (With Replacement)**.

**Implicaciones:**
1. Se ignora la selección de segunda etapa (viviendas dentro de UPM) para el cálculo de varianzas
2. La variabilidad total se atribuye a la primera etapa (UPM)
3. Esto produce estimaciones **conservadoras** de las varianzas (tienden a sobreestimar)

**Fórmula EVCU/WR para la media:**

$$\hat{V}(\hat{\bar{Y}}) = \sum_{h=1}^{H} \frac{1}{n_h(n_h-1)} \sum_{i=1}^{n_h} (z_{hi} - \bar{z}_h)^2$$

donde $z_{hi} = \sum_{j \in UPM_i} w_{hij} y_{hij}$ es el **total ponderado** de la variable en la UPM $i$.

**Referencia:** Diseño Muestral CASEN 2022, ecuaciones (45)–(47).

---

## 3. ERROR ESTÁNDAR Y EFECTO DE DISEÑO

### 3.1 Error Estándar

El **error estándar (EE)** es la raíz cuadrada de la varianza estimada:

$$\hat{EE}(\hat{\bar{Y}}) = \sqrt{\hat{V}(\hat{\bar{Y}})}$$

---

### 3.2 Efecto de Diseño (DEFF)

El **efecto de diseño** mide cuánto aumenta la varianza debido a la complejidad del diseño muestral comparado con MAS:

$$DEFF = \frac{V_{diseño}(\hat{\bar{Y}})}{V_{MAS}(\hat{\bar{Y}})}$$

donde:
- $V_{diseño}$ = varianza bajo el diseño complejo real
- $V_{MAS} = \frac{S^2}{n}$ = varianza bajo MAS del mismo tamaño

**Interpretación:**
- DEFF = 1 → No hay efecto del diseño (equivalente a MAS)
- DEFF > 1 → Pérdida de precisión por conglomeración/estratificación
- DEFF < 1 → Ganancia de precisión (poco común, salvo estratificación muy efectiva)

**Típicamente en CASEN:** DEFF entre 1.5 y 3.0 para variables socioeconómicas.

---

### 3.3 Tamaño de Muestra Efectivo

$$n_{eff} = \frac{n}{DEFF}$$

donde $n$ es el tamaño de muestra real.

**Interpretación:** Una muestra de $n$ observaciones bajo diseño complejo tiene la misma precisión que una muestra MAS de tamaño $n_{eff}$.

---

## 4. INTERVALOS DE CONFIANZA

### 4.1 IC para la Media (distribución t)

$$IC_{95\%}(\hat{\bar{Y}}) = \hat{\bar{Y}} \pm t_{df, 0.975} \cdot \hat{EE}(\hat{\bar{Y}})$$

donde:
- $t_{df, 0.975}$ = cuantil de la distribución t-Student
- $df$ = grados de libertad del diseño

**Grados de libertad en diseño estratificado:**

$$df = \sum_{h=1}^{H} n_h - H$$

(número total de UPM menos número de estratos)

**Para muestras grandes:** $t_{df, 0.975} \approx 1.96$ (aproximación normal).

---

### 4.2 IC para una Proporción

Para una proporción $\hat{p}$, el IC se calcula de forma similar:

$$IC_{95\%}(\hat{p}) = \hat{p} \pm t_{df, 0.975} \cdot \hat{EE}(\hat{p})$$

**Nota:** Para proporciones extremas (cercanas a 0 o 1), considerar métodos alternativos (Wilson, Clopper-Pearson con ajuste por diseño).

---

## 5. REGRESIÓN LINEAL CON DISEÑO COMPLEJO

### 5.1 Modelo de Regresión Ponderado

$$y_i = \beta_0 + \beta_1 x_{i1} + \beta_2 x_{i2} + \cdots + \beta_p x_{ip} + \epsilon_i$$

**Estimación por Mínimos Cuadrados Ponderados (WLS):**

$$\hat{\boldsymbol{\beta}} = (\mathbf{X}^T \mathbf{W} \mathbf{X})^{-1} \mathbf{X}^T \mathbf{W} \mathbf{y}$$

donde:
- $\mathbf{W}$ = matriz diagonal con pesos $w_i$ (factores de expansión)
- $\mathbf{X}$ = matriz de diseño (variables independientes)
- $\mathbf{y}$ = vector de variable dependiente

---

### 5.2 Varianza de los Coeficientes (Linealización de Taylor)

$$\hat{V}(\hat{\boldsymbol{\beta}}) = (\mathbf{X}^T \mathbf{W} \mathbf{X})^{-1} \left[ \sum_{h=1}^{H} \frac{1-f_h}{n_h(n_h-1)} \sum_{i=1}^{n_h} \mathbf{e}_{hi} \mathbf{e}_{hi}^T \right] (\mathbf{X}^T \mathbf{W} \mathbf{X})^{-1}$$

donde:
- $\mathbf{e}_{hi}$ = vector de residuos linealizados para la UPM $i$ del estrato $h$

**En `survey::svyglm()`:** Esta varianza se calcula automáticamente.

---

### 5.3 Pruebas de Hipótesis para Coeficientes

**Estadístico t:**

$$t = \frac{\hat{\beta}_j}{\hat{EE}(\hat{\beta}_j)}$$

**Distribución:** $t \sim t_{df}$ bajo $H_0: \beta_j = 0$

**P-value:** $p = 2 \cdot P(T_{df} > |t|)$

---

## 6. REGRESIÓN LOGÍSTICA CON DISEÑO COMPLEJO

### 6.1 Modelo Logístico

Para una variable binaria $Y$ (0/1):

$$\log\left(\frac{P(Y_i=1)}{1-P(Y_i=1)}\right) = \beta_0 + \beta_1 x_{i1} + \cdots + \beta_p x_{ip}$$

**Estimación:** Máxima verosimilitud ponderada (pseudo-likelihood).

---

### 6.2 Odds Ratio

$$OR = \exp(\beta_j)$$

**Interpretación:** Por cada unidad de aumento en $x_j$, las chances de $Y=1$ se multiplican por $OR$.

**IC 95% para OR:**

$$IC_{95\%}(OR_j) = \exp\left(\hat{\beta}_j \pm t_{df, 0.975} \cdot \hat{EE}(\hat{\beta}_j)\right)$$

---

## 7. ERRORES ESTÁNDAR ROBUSTOS (CLUSTER)

### 7.1 Varianza Cluster-Robust (HC-Cluster)

Para modelos fuera de `svyglm`, se pueden calcular errores estándar robustos a **heterocedasticidad** y **correlación intra-cluster** (UPM):

$$\hat{V}_{CR}(\hat{\boldsymbol{\beta}}) = (\mathbf{X}^T \mathbf{X})^{-1} \left[ \sum_{c=1}^{C} \mathbf{X}_c^T \mathbf{u}_c \mathbf{u}_c^T \mathbf{X}_c \right] (\mathbf{X}^T \mathbf{X})^{-1}$$

donde:
- $C$ = número de clusters (UPM)
- $\mathbf{X}_c$ = matriz de diseño para el cluster $c$
- $\mathbf{u}_c$ = vector de residuos para el cluster $c$

**Implementación en R:**
```r
library(sandwich)
vcovCL(modelo, cluster = ~upm)
```

**Nota:** Este enfoque **no** incorpora estratificación ni factores de expansión de forma completa. Usar `svyglm()` es preferible.

---

## 8. IMPUTACIÓN MÚLTIPLE (MI)

### 8.1 Reglas de Rubin para Combinar Estimaciones

Sea $\hat{\theta}_m$ la estimación del parámetro $\theta$ en la imputación $m$ (de $M$ imputaciones totales).

**Estimación combinada:**

$$\hat{\theta}_{MI} = \frac{1}{M} \sum_{m=1}^{M} \hat{\theta}_m$$

**Varianza combinada:**

$$V_{MI}(\hat{\theta}) = \bar{V}_W + \left(1 + \frac{1}{M}\right) V_B$$

donde:
- $\bar{V}_W = \frac{1}{M} \sum_{m=1}^{M} V_m$ = varianza **dentro** de imputaciones (promedio de varianzas)
- $V_B = \frac{1}{M-1} \sum_{m=1}^{M} (\hat{\theta}_m - \hat{\theta}_{MI})^2$ = varianza **entre** imputaciones

**Grados de libertad ajustados:**

$$df_{MI} = (M-1) \left[1 + \frac{\bar{V}_W}{(1 + 1/M) V_B}\right]^2$$

**En R:**
```r
library(mitools)
MIcombine(lista_de_modelos)
```

---

## 9. AJUSTES POR COMPARACIONES MÚLTIPLES

### 9.1 Benjamini-Hochberg (FDR)

Para controlar la **tasa de falsos descubrimientos** (FDR) al nivel $\alpha$:

**Procedimiento:**
1. Ordenar p-values: $p_{(1)} \leq p_{(2)} \leq \cdots \leq p_{(m)}$
2. Encontrar el mayor $k$ tal que: $p_{(k)} \leq \frac{k}{m} \alpha$
3. Rechazar $H_0$ para todas las hipótesis con p-values $p_{(1)}, \ldots, p_{(k)}$

**P-values ajustados (BH):**

$$p_{adj}^{BH}(i) = \min\left(1, \min_{j \geq i} \left\{\frac{m \cdot p_{(j)}}{j}\right\}\right)$$

**En R:**
```r
p.adjust(p_raw, method = "BH")
```

---

### 9.2 Holm-Bonferroni

Para control estricto del **error familiar (FWER)** al nivel $\alpha$:

**Procedimiento:**
1. Ordenar p-values: $p_{(1)} \leq p_{(2)} \leq \cdots \leq p_{(m)}$
2. Para $i = 1, \ldots, m$:
   - Si $p_{(i)} > \frac{\alpha}{m - i + 1}$, detener y NO rechazar $H_0$ para $i$ ni ninguna hipótesis posterior
   - Si $p_{(i)} \leq \frac{\alpha}{m - i + 1}$, rechazar $H_0$ y continuar

**P-values ajustados (Holm):**

$$p_{adj}^{Holm}(i) = \max\left(p_{adj}^{Holm}(i-1), (m-i+1) \cdot p_{(i)}\right)$$

**En R:**
```r
p.adjust(p_raw, method = "holm")
```

---

## 10. DOMINIOS DE ESTIMACIÓN CASEN 2022

| Dominio | Representatividad | Notas |
|---------|------------------|-------|
| Nacional (total) | ✅ Garantizada | Toda la población en viviendas particulares ocupadas |
| Nacional Urbano | ✅ Garantizada | Agregación de zonas urbanas |
| Nacional Rural | ✅ Garantizada | Agregación de zonas rurales |
| Regional (16 regiones) | ✅ Garantizada | Cada región por separado |
| Región × Área (urbano/rural) | ⚠️ NO garantizada oficialmente | Puede ser viable empíricamente en algunas regiones |
| Provincial | ⚠️ Limitada | Solo para algunas provincias grandes |
| Comunal | ❌ NO garantizada | No es objetivo del diseño |

**Fuente:** Nota Técnica N°3 CASEN 2022.

---

## 11. REFERENCIAS BIBLIOGRÁFICAS

1. **Ministerio de Desarrollo Social y Familia (2023).** *Diseño Muestral CASEN 2022.* [Link](https://observatorio.ministeriodesarrollosocial.gob.cl/storage/docs/casen/2022/Diseno_Muestral_Casen_2022.pdf)

2. **Ministerio de Desarrollo Social y Familia (2023).** *Nota Técnica N°3: Desempeño del trabajo de campo y revisión de calibración CASEN 2022.* [Link](https://observatorio.ministeriodesarrollosocial.gob.cl/storage/docs/casen/2022/Nota_tecnica_N3_Desempeno_trabajo_campo_Casen_2022.pdf)

3. **Lumley, T. (2010).** *Complex Surveys: A Guide to Analysis Using R.* John Wiley & Sons.

4. **Lohr, S. L. (2019).** *Sampling: Design and Analysis* (3rd ed.). Chapman and Hall/CRC.

5. **Särndal, C. E., Swensson, B., & Wretman, J. (1992).** *Model Assisted Survey Sampling.* Springer-Verlag.

6. **Rubin, D. B. (1987).** *Multiple Imputation for Nonresponse in Surveys.* John Wiley & Sons.

7. **Benjamini, Y., & Hochberg, Y. (1995).** Controlling the false discovery rate: A practical and powerful approach to multiple testing. *Journal of the Royal Statistical Society: Series B*, 57(1), 289–300.

8. **R Core Team.** *survey: analysis of complex survey samples.* [CRAN](https://cran.r-project.org/web/packages/survey/)

9. **Zeileis, A.** *sandwich: Robust Covariance Matrix Estimators.* [CRAN](https://cran.r-project.org/web/packages/sandwich/)

10. **van Buuren, S., & Groothuis-Oudshoorn, K. (2011).** mice: Multivariate Imputation by Chained Equations in R. *Journal of Statistical Software*, 45(3), 1–67.

---

**Documento generado:** 9 de noviembre de 2025  
**Autor:** Esteban  
**Propósito:** Material de referencia técnica para análisis CASEN 2022 con diseño muestral complejo
