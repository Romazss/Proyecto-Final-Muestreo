# Gaps Informacionales Cubiertos - CASEN 2022

Este documento detalla todos los gaps informacionales identificados y cómo fueron integrados en el beamer presentation (carpeta `01_SeccionesC`).

## Fecha de actualización
9 de noviembre de 2025

---

## 1. DISEÑO MUESTRAL Y MARCO

### Gap 1.1: Explicación de cómo se calcularon los errores (fórmulas)
**Estado:** ✅ CUBIERTO

**Ubicación:** `06_metodologia_detallada.tex` - Frame "Método de Estimación de Varianzas"

**Contenido agregado:**
- CASEN estima varianzas con el enfoque **EVCU/WR** (conglomerado último / with-replacement)
- Usa **linealización de Taylor**
- Fórmula de varianza estratificada incluida
- Referencia: Diseño Muestral CASEN 2022, ecuaciones (45)–(47)

### Gap 1.2: Fecha de actualización del marco (¿MMV-2020 está actualizado para 2022?)
**Estado:** ✅ CUBIERTO

**Ubicación:** `04_diseno_muestral.tex` - Frame "Marco Muestral: Detalles Técnicos"

**Contenido agregado:**
- Marco muestral es el **MMV 2020**, construido desde Censo 2017 con actualización al año 2020
- Para CASEN 2022 se usa ese marco con **verificación/enumeración previa** de UPM y viviendas
- No es un MMV 2022, pero hay ajustes locales antes del levantamiento

### Gap 1.3: Número total de UPM en el marco
**Estado:** ✅ CUBIERTO (seleccionadas)

**Ubicación:** `04_diseno_muestral.tex` - Frame "Marco Muestral: Detalles Técnicos"

**Contenido agregado:**
- Total de **12.545 UPM seleccionadas**:
  - 10.602 UPM urbanas
  - 1.943 UPM rurales
- **764 estratos de selección** tras ajustes

**Nota:** El total de UPM en el marco (no seleccionadas) no está publicado en documentos oficiales.

### Gap 1.4: Cobertura del marco (¿qué % de la población?)
**Estado:** ✅ CUBIERTO (con exclusiones explícitas)

**Ubicación:** `03_introduccion.tex` - Frame "Cobertura y Exclusiones"

**Contenido agregado:**
- Cobertura nacional sobre viviendas particulares ocupadas
- **10 comunas completas excluidas:** Ollagüe, Juan Fernández, Isla de Pascua, Cochamó, Chaitén, Futaleufú, Hualaihué, Palena, Guaitecas, O'Higgins, Antártica Chilena
- **UPM específicas excluidas:**
  - General Lagos (4 UPM)
  - Colchane (5 UPM)
  - Tortel (1 UPM)
  - Cabo de Hornos (1 UPM)

**Nota:** El % exacto de población excluida no está reportado oficialmente. Puede estimarse ex-post con datos censales.

---

## 2. NIVELES DE INFERENCIA

### Gap 2.1: Niveles específicos de inferencia
**Estado:** ✅ CUBIERTO

**Ubicación:** `04_diseno_muestral.tex` - Frame "Niveles de Representatividad"

**Contenido agregado:**
- **Representatividad garantizada:**
  - Nacional (total país)
  - Nacional Urbano
  - Nacional Rural
  - Regional (16 regiones)
- **NO** hay representatividad **comunal** por diseño
- Fuente: Nota Técnica N°3 CASEN 2022

### Gap 2.2: ¿Se puede inferir a nivel de zona urbana/rural por región?
**Estado:** ✅ CUBIERTO (con limitación explícita)

**Ubicación:** `04_diseno_muestral.tex` - Frame "Niveles de Representatividad"

**Contenido agregado:**
- El diseño asegura nacional-urbano y nacional-rural, y regional (total)
- La cruz **"región × área (urbana/rural)" no está garantizada** como dominio oficial
- Algunas regiones podrían ser viables empíricamente, pero no está establecida como dominio oficial

### Gap 2.3: Limitaciones de inferencia explícitas
**Estado:** ✅ CUBIERTO

**Ubicación:** `04_diseno_muestral.tex` - Frame "Niveles de Representatividad"

**Contenido agregado en alertblock:**
- No representatividad **comunal**
- Exclusión de **áreas especiales** y **SDPA** del análisis de pobreza
- Población objetivo: residentes en viviendas particulares ocupadas

---

## 3. METODOLOGÍA DE ANÁLISIS

### Gap 3.1: ¿Cómo se incorpora el diseño complejo en las regresiones?
**Estado:** ✅ CUBIERTO

**Ubicación:** `06_metodologia_detallada.tex` - Frames "Diseño Complejo en Regresiones" y "Modelos GLM con Diseño Complejo"

**Contenido agregado:**
- Declarar el diseño (estratos, UPM/PSU y factores de expansión) **antes** de estimar
- En R: `survey::svyglm()` usa **linealización de Taylor**
- Código de ejemplo para regresión lineal, logística y Poisson
- Python: aproximación con `statsmodels` (no reproduce inferencia completa por diseño)

**Código de ejemplo incluido:**
```r
library(survey)
des <- svydesign(ids = ~upm, strata = ~estrato,
                 weights = ~expr, data = casen, nest = TRUE)
fit_lin <- svyglm(y ~ x1 + x2, design = des)
fit_log <- svyglm(ybin ~ x1 + x2, design = des, family = quasibinomial())
fit_pois <- svyglm(count ~ x1 + offset(log(exp_t)), design = des, family = quasipoisson())
```

### Gap 3.2: ¿Qué paquetes de R/Python se usarán para cada método?
**Estado:** ✅ CUBIERTO

**Ubicación:** `06_metodologia_detallada.tex` - Frames "Software y Herramientas" y "Herramientas en Python"

**Contenido agregado:**

**R (diseño e inferencia):**
- `survey` y `srvyr` (estimaciones bajo diseño complejo)
- `mice` y `mitools` (imputación múltiple + integración con survey)
- `sandwich` y `lmtest` (errores robustos/cluster)
- `ggplot2` y `dplyr` (visualización/procesamiento)

**Python (QA descriptivo):**
- `pandas` (manipulación)
- `numpy` (cálculos)
- `matplotlib` y `seaborn` (visualización)
- `statsmodels` (análisis estadístico - aproximación)

**Nota metodológica explícita:** Python se usará solo para QA descriptivo; la inferencia por diseño complejo se realizará en R con `survey`.

### Gap 3.3: ¿Cómo se calculan errores estándar robustos?
**Estado:** ✅ CUBIERTO

**Ubicación:** `06_metodologia_detallada.tex` - Frame "Errores Estándar Robustos"

**Contenido agregado:**
- Con diseño complejo: `svyglm()` ya entrega **EE por diseño** (Taylor o réplicas)
- No necesitas "agregar" robustos: ya lo son a nivel de diseño
- Como análisis de sensibilidad: errores **cluster-robust por UPM** con `sandwich::vcovCL()`

**Código de ejemplo incluido:**
```r
library(sandwich); library(lmtest)
m  <- lm(y ~ x1 + x2, data = casen)
Vc <- vcovCL(m, cluster = ~upm)
coeftest(m, vcov = Vc)
```

### Gap 3.4: Nivel de significancia para pruebas de hipótesis
**Estado:** ✅ CUBIERTO

**Ubicación:** `06_metodologia_detallada.tex` - Frame "Pruebas de Hipótesis y Significancia"

**Contenido agregado:**
- **Pre-registrado**: α = 0.05 como estándar
- Para encuestas complejas, reportamos:
  - Estimadores y errores estándar
  - Estadístico t (o z) **por diseño**
  - P-value por diseño
  - **Intervalos de confianza al 95%**
- Nota: Los grados de libertad se ajustan según el diseño (número de UPM - número de estratos)

### Gap 3.5: ¿Cómo se manejan valores missing?
**Estado:** ✅ CUBIERTO

**Ubicación:** `06_metodologia_detallada.tex` - Frames "Manejo de Valores Missing" y "Imputación Múltiple con Diseño Complejo"

**Contenido agregado:**

**Estrategia:**
1. Definición previa por variable (faltantes verdaderos vs. no elegibles/"No sabe/No responde")
2. **Análisis por diseño:** filtrar *dentro del diseño*, no antes (preservar pesos/varianzas)
3. **Imputación múltiple** cuando el missingness sea sustantivo y (al menos) MAR

**Código de ejemplo incluido:**
```r
# 1. Filtrado dentro del diseño
des_ok <- subset(des, !is.na(y) & !is.na(x1))

# 2. Imputación múltiple
library(mice); library(mitools)
imp <- mice(casen, m=20, method="pmm", maxit=20, seed=123)
il  <- imputationList(complete(imp, "all"))

# 3. Integración con survey
des_mi <- svydesign(ids=~upm, strata=~estrato, weights=~expr, data=il, nest=TRUE)
fits <- with(des_mi, svyglm(y ~ x1 + x2))
MIcombine(fits)   # Reglas de Rubin
```

### Gap 3.6: ¿Se harán ajustes por comparaciones múltiples?
**Estado:** ✅ CUBIERTO

**Ubicación:** `06_metodologia_detallada.tex` - Frame "Ajustes por Comparaciones Múltiples"

**Contenido agregado:**

**Política propuesta:**
- Para **exploración amplia**: Benjamini–Hochberg (BH/FDR)
- Para **tests confirmatorios críticos**: Holm–Bonferroni

**Código de ejemplo incluido:**
```r
p_raw <- summary(fit)$coefficients[-1,4]
p_adj <- p.adjust(p_raw, method = "BH")  # o "holm", "bonferroni"
```

**Documentación:** Se debe reportar el **tamaño de la familia** y justificar el método elegido.

---

## 4. INTEGRACIÓN EN PLAN DE ANÁLISIS

### Objetivo 1: Brecha Salarial de Género
**Estado:** ✅ ACTUALIZADO

**Ubicación:** `05_plan_analisis.tex` - Frame "Metodología - Objetivo 1"

**Cambios realizados:**
- Análisis descriptivo usa `svymean()`
- Modelo de regresión lineal **con diseño complejo**: `svyglm()` con linealización de Taylor
- Reporta IC 95% por diseño

### Objetivo 2: Distribución de la Pobreza
**Estado:** ✅ ACTUALIZADO

**Ubicación:** `05_plan_analisis.tex` - Frame "Metodología - Objetivo 2"

**Cambios realizados:**
- Porcentaje de hogares en pobreza usa `svymean()`
- Comparación de ingresos con `svyby()`
- Pruebas de hipótesis por diseño (α=0.05) con `svyttest()`
- Modelo de regresión logística con `svyglm(family=quasibinomial())`

---

## 5. CHECKLIST METODOLÓGICO FINAL

**Ubicación:** `06_metodologia_detallada.tex` - Frame "Resumen: Checklist Metodológico"

Se creó una diapositiva de resumen con todos los elementos metodológicos clave:

✅ **Declaración del diseño:** `survey` (R) con ids=UPM, estratos oficiales, factor de expansión; varianzas por Taylor; IC95% por diseño

✅ **Modelos:** Regresiones con `svyglm` (lineal, logística, Poisson); Python solo para QA descriptivo

✅ **Robustos:** EE por diseño; sensibilidad con HC1 y cluster por UPM

✅ **Significancia:** α=0.05 pre-registrado; IC95% por diseño

✅ **Missing:** Subsetting dentro del diseño; MI (`mice` + `mitools`) si relevante

✅ **Múltiples comparaciones:** FDR (BH) o Holm–Bonferroni

---

## 6. REFERENCIAS AGREGADAS

Todas las diapositivas actualizadas incluyen referencias a:

- Diseño Muestral CASEN 2022 (ecuaciones 45-47)
- Nota Técnica N°3 CASEN 2022 (trabajo de campo y dominios de inferencia)
- Documentación de paquetes R: `survey`, `sandwich`, `mice`, `mitools`
- Páginas oficiales: observatorio.ministeriodesarrollosocial.gob.cl

---

## 7. ARCHIVOS MODIFICADOS

1. `03_introduccion.tex` - Agregado frame "Cobertura y Exclusiones"
2. `04_diseno_muestral.tex` - Agregados frames:
   - "Marco Muestral: Detalles Técnicos"
   - "Niveles de Representatividad"
3. `05_plan_analisis.tex` - Actualizados frames de metodología para ambos objetivos
4. `06_metodologia_detallada.tex` - Agregados frames:
   - "Método de Estimación de Varianzas"
   - "Diseño Complejo en Regresiones"
   - "Modelos GLM con Diseño Complejo"
   - "Errores Estándar Robustos"
   - "Manejo de Valores Missing"
   - "Imputación Múltiple con Diseño Complejo"
   - "Pruebas de Hipótesis y Significancia"
   - "Ajustes por Comparaciones Múltiples"
   - "Resumen: Checklist Metodológico"
   - Actualizado "Software y Herramientas"
   - Actualizado "Herramientas en Python"

---

## 8. PRÓXIMOS PASOS SUGERIDOS

1. **Compilar beamer_principal.tex** para verificar que todas las diapositivas se renderizan correctamente
2. **Revisar numeración** y flujo de presentación
3. **Agregar ejemplos de salidas** en un apéndice (tablas de regresión con diseño complejo)
4. **Crear documento técnico complementario** (opcional) con:
   - Ecuaciones completas de Horvitz-Thompson y Hájek
   - Detalles de EVCU y Taylor linearization
   - Tabla de dominios de inferencia
5. **Validar código R** con datos CASEN 2022 reales
6. **Documentar limitaciones** no resueltas (e.g., % exacto de población excluida)

---

## Notas Finales

- Todos los gaps críticos han sido cubiertos con información oficial de CASEN 2022
- Se han agregado referencias específicas a documentos técnicos
- Se incluye código de ejemplo listo para implementar
- Las limitaciones metodológicas están explícitamente declaradas
- El documento mantiene rigor técnico sin perder claridad expositiva

**Documento generado:** 9 de noviembre de 2025  
**Autor:** Esteban (con asistencia de GitHub Copilot)  
**Repositorio:** Proyecto-Final-Muestreo (branch: v2)
