# Especificaciones Técnicas del Proyecto - EYP2417 Muestreo (Grupo 4)

**Fecha de Entrega:** Viernes 24 de octubre de 2025  
**Formato Requerido:** PDF de 3-4 páginas en LaTeX  
**Profesor Responsable:** Guillermo Marshall Rivera  

---

## 1. OBJETIVO GENERAL

**"Entender la realidad chilena a partir de la encuesta CASEN"**

Este objetivo general permite al equipo moverse entre diferentes áreas temáticas y desarrollar múltiples objetivos específicos complementarios sin limitarse a una única dimensión de análisis.

---

## 2. EJES TEMÁTICOS DEL GRUPO 4

### EJE 1: BRECHA SALARIAL DE GÉNERO
**Responsable:** Francisca Sepúlveda

#### Objetivo Específico
Analizar las diferencias salariales entre jefes de hogar hombres y mujeres, controlando por factores educacionales, demográficos y ocupacionales.

#### Preguntas de Investigación
1. ¿Cuál es la diferencia salarial promedio entre jefes de hogar hombres y mujeres?
2. ¿Cómo varía la brecha salarial según nivel educacional?
3. ¿Persiste la brecha en todas las regiones de Chile?
4. ¿Cuáles son los factores que más explican la brecha salarial?

#### Variables Clave

| Variable | Código | Tipo | Descripción |
|----------|--------|------|-------------|
| Ingreso trabajo principal | `yoprinc` | Cuantitativa | Ingreso mensual del trabajo principal (pesos) |
| Sexo jefe hogar | `sexo` | Cualitativa | 1=Hombre, 2=Mujer |
| Escolaridad | `esc` | Cuantitativa | Años de educación formal completados |
| Edad | `edad` | Cuantitativa | Edad del jefe de hogar (años) |
| Región | `region` | Cualitativa | Región administrativa de residencia |
| Zona | `area` | Cualitativa | 1=Urbano, 2=Rural |
| Factor de expansión | `expr` | Cuantitativa | Ponderador para análisis representativos |
| Ocupación | `ocup` | Cualitativa | Categoría ocupacional |
| Sector económico | `rama` | Cualitativa | Rama de actividad económica |

#### Enfoque Metodológico

1. **Estadística Descriptiva:**
   - Ingreso promedio y mediano por sexo
   - Desviación estándar, percentiles
   - Tablas estratificadas por región y educación
   - Cálculos PONDERADOS usando `expr`

2. **Análisis de Regresión:**
   - Modelo: `log(yoprinc) = β₀ + β₁*sexo + β₂*esc + β₃*edad + ...`
   - Controlar por: educación, edad, región, sector
   - Incluir términos de interacción si es relevante
   - Interpretar coeficientes como diferencias porcentuales

3. **Análisis Estratificado:**
   - Por región
   - Por nivel educacional
   - Por sector económico
   - Por tipo de ocupación

4. **Diseño Muestral:**
   - Aplicar factor de expansión `expr` en todas las estimaciones
   - Considerar estructura estratificada en intervalos de confianza
   - Usar `survey` estimators cuando sea apropiado

#### Outputs Esperados

- Tabla: Ingresos promedio por sexo (total y ponderado)
- Tabla: Brecha salarial por nivel educacional
- Tabla: Brecha salarial por región
- Figura: Gráfico de brecha salarial por educación
- Figura: Gráfico de brecha salarial por región
- Tabla: Resultados de regresión (con coeficientes e interpretación)
- Insight: ¿Cuánto se explica la brecha por variables observadas?

---

### EJE 2: DISTRIBUCIÓN DE LA POBREZA EN CHILE
**Responsable:** Esteban Román

#### Objetivo Específico
Caracterizar la distribución geográfica y demográfica de la pobreza en Chile, identificando patrones según región, zona de residencia y características socioeconómicas del hogar.

#### Preguntas de Investigación
1. ¿Cuál es la incidencia de pobreza por región?
2. ¿Existen diferencias significativas entre zonas urbanas y rurales?
3. ¿Cuáles son las características demográficas comunes de la población pobre?
4. ¿Qué relación existe entre educación del jefe de hogar y pobreza?
5. ¿Cómo se relaciona el tipo de vivienda con la condición de pobreza?

#### Variables Clave

| Variable | Código | Tipo | Descripción |
|----------|--------|------|-------------|
| Condición de pobreza | `pobreza` | Cualitativa | 1=No pobre, 2=Pobre, 3=Extremadamente pobre |
| Región | `region` | Cualitativa | Región administrativa (1-16) |
| Zona | `area` | Cualitativa | 1=Urbano, 2=Rural |
| Ingreso total hogar | `ytotcorh` | Cuantitativa | Ingreso total corregido del hogar (pesos) |
| Escolaridad jefe | `esc` | Cuantitativa | Años de educación formal del jefe |
| Edad jefe | `edad` | Cuantitativa | Edad del jefe de hogar |
| Tamaño hogar | `tot_per_h` | Cuantitativa | Total de personas en el hogar |
| Tipo vivienda | `tipovivienda` | Cualitativa | Casa, departamento, etc. |
| Tenencia vivienda | `ten_viv` | Cualitativa | Propia pagada, propia pagándose, arrendada, etc. |
| Hacinamiento | `ind_hacina` | Cuantitativa | Indicador de hacinamiento |
| Factor de expansión | `expr` | Cuantitativa | Ponderador para análisis representativos |

#### Enfoque Metodológico

1. **Estadística Descriptiva:**
   - Incidencia de pobreza nacional (%)
   - Incidencia por región (tablas y mapas)
   - Comparación urbano-rural
   - Cálculos PONDERADOS usando `expr`

2. **Tablas Estratificadas:**
   - Pobreza por educación del jefe
   - Pobreza por edad del jefe
   - Pobreza por tamaño del hogar
   - Pobreza por tenencia de vivienda

3. **Análisis Multivariado:**
   - Modelo logit: `P(pobre=1) = f(educación, edad, región, zona, tipo_vivienda)`
   - Odds ratios e interpretación
   - Efectos marginales

4. **Análisis Geográfico:**
   - Identificar regiones de mayor incidencia
   - Diferencias urbano-rural por región
   - Concentración de pobreza

5. **Diseño Muestral:**
   - Aplicar factor de expansión `expr` en todas las estimaciones
   - Intervalos de confianza ajustados por diseño complejo
   - Errores estándar de Taylor

#### Outputs Esperados

- Tabla: Incidencia de pobreza nacional y por región
- Tabla: Comparación urbano-rural por región
- Tabla: Características demográficas de pobres vs no pobres
- Figura: Incidencia de pobreza por región (gráfico de barras)
- Figura: Comparación urbano-rural por región
- Tabla: Análisis de regresión logit
- Insight: Principales factores asociados a la pobreza

---

## 3. DATOS UTILIZADOS: ENCUESTA CASEN 2022

### Descripción General
- **Nombre Completo:** Encuesta de Caracterización Socioeconómica Nacional (CASEN) 2022
- **Institución Responsable:** Ministerio de Desarrollo Social y Familia
- **Año de Levantamiento:** 2022
- **Versión Base de Datos:** 18 de marzo de 2024
- **Cobertura Geográfica:** Nacional, regional, provincial, comunal
- **Población Objetivo:** Hogares residentes en viviendas particulares

### Tamaño y Representatividad
- **Personas Encuestadas:** ~202,000 (202.260 aproximadamente)
- **Hogares:** ~70,000 aproximadamente
- **Representatividad:** Nacional y regional

### Diseño Muestral (Thompson, Cap. 8-9)

**Tipo:** Estratificado polietápico

**Estructura:**
1. **Estratificación:** Por región y zona (urbano/rural)
2. **Primera etapa:** Selección de Unidades Primarias de Muestreo (UPM) - Secciones censales
3. **Segunda etapa:** Selección de viviendas dentro de UPM
4. **Tercera etapa:** Selección de personas dentro de viviendas (en algunos módulos)

**Ponderación:**
- Variable: `expr` (factor de expansión)
- Ajusta por:
  - Probabilidades de selección en etapas múltiples
  - No-respuesta
  - Calibración a benchmarks demográficos

**Implicaciones para el Análisis:**
- TODAS las estimaciones deben usar `expr` para representatividad nacional/regional
- Los errores estándar deben ajustarse por diseño complejo
- Usar métodos de "survey statistics" (paquetes `survey` en R, `survey` en Python)

### Archivo de Datos
- **Nombre:** `Base de datos Casen 2022 STATA_18 marzo 2024.dta`
- **Formato:** STATA (.dta)
- **Tamaño:** ~500 MB aproximadamente
- **Variables:** ~300+ variables

### Documentación Disponible
- Libro de códigos (Excel)
- Manual Metodológico CASEN 2022
- Manual del Investigador
- Cuestionario en terreno

---

## 4. ESTRUCTURA DEL INFORME FINAL (3-4 páginas)

El informe debe incluir:

### 1. **Portada** (0.5 página)
- Título del proyecto
- Nombre de grupo y curso
- Profesor y fecha

### 2. **Introducción** (0.5 página)
- Motivación y relevancia
- Objetivo general
- Estructura del informe

### 3. **Metodología** (0.5-0.75 páginas)
- Descripción CASEN 2022
- Diseño muestral
- Variables utilizadas
- Métodos de análisis (con referencia a Thompson, 2012)

### 4. **Resultados** (1.5-2 páginas)

#### 4.1 Brecha Salarial de Género
- Tabla con ingresos promedio por sexo
- Análisis de regresión (coeficientes principales)
- Interpretación de resultados
- Gráfico ilustrativo

#### 4.2 Distribución de Pobreza
- Tabla de incidencia de pobreza por región
- Análisis urbano-rural
- Tabla de factores asociados
- Gráfico ilustrativo

### 5. **Conclusiones** (0.5 página)
- Hallazgos principales de cada eje
- Implicaciones
- Limitaciones del estudio
- Líneas de investigación futura

### 6. **Referencias** (0.25 página)
- Bibliografía mínima de Thomson, Lohr, Lumley, Särndal et al.
- Referencias CASEN y fuentes oficiales

---

## 5. ESPECIFICACIONES TÉCNICAS DEL ANÁLISIS

### 5.1 Análisis Ponderado

**IMPORTANTE:** Todas las estimaciones de características poblacionales deben ser ponderadas usando `expr`:

```python
# Ejemplo: Ingreso promedio nacional
ingreso_ponderado = (df['ytotcorh'] * df['expr']).sum() / df['expr'].sum()

# Ingreso promedio por sexo (ponderado)
ingreso_por_sexo = df.groupby('sexo').apply(
    lambda x: (x['ytotcorh'] * x['expr']).sum() / x['expr'].sum()
)
```

### 5.2 Intervalos de Confianza

Para encuestas complejas, los intervalos deben ajustarse por:
- Diseño estratificado
- Diseño multietápico
- Factor de conglomeración

**Opción 1:** Usar método de replicación (bootstrap)
```python
# Calcular IC mediante bootstrap ponderado
```

**Opción 2:** Usar fórmula de Taylor (si paquete survey disponible)
```python
# Usar statsmodels survey estimators
```

### 5.3 Análisis de Regresión

Para modelos de regresión con datos de encuesta:

```python
# Especificar: 
# 1. Matriz de diseño (con estratos y conglomerados si aplica)
# 2. Ponderadores (expr)
# 3. Usar errores estándar robustos
```

Referencia: Thompson (2012), Cap. 12 sobre estimación en muestreo complejo.

### 5.4 Comparaciones Estadísticas

Cuando se comparen dos grupos (ej: hombres vs mujeres):
- Usar test t ponderado
- Calcular p-valores considerando diseño muestral
- Reportar tamaño de efecto (diferencia media o razón de odds)

---

## 6. CHECKLIST DE CALIDAD

Antes de entregar, verificar:

### Análisis
- [ ] Todas las estimaciones usan factor de expansión `expr`
- [ ] Se reportan intervalos de confianza (o al menos errores estándar)
- [ ] Se citan métodos de Thompson (2012) o libros de curso
- [ ] Se valida que n sea suficiente para conclusiones
- [ ] Se describe completitud de datos (valores faltantes)

### Informe LaTeX
- [ ] Portada correcta con datos del grupo
- [ ] Secciones bien estructuradas (Intro-Método-Resultados-Conclusiones)
- [ ] Tablas con etiquetas y fuentes
- [ ] Figuras claras y referenciadas en texto
- [ ] Referencias bibliográficas formales
- [ ] Extensión: 3-4 páginas (sin contar portada)
- [ ] Sin errores ortográficos

### Código
- [ ] Notebooks reproducibles
- [ ] Comentarios claros explicando análisis
- [ ] Funciones reutilizables en scripts
- [ ] Git con commits meaningfull

---

## 7. CRONOGRAMA DE TRABAJO

| Fase | Fecha | Responsable | Status |
|------|-------|-------------|--------|
| Exploración datos | 21-22 oct | Ambos ejes | ⏳ |
| Análisis preliminar | 22-23 oct | Esteban/Francisca | ⏳ |
| Generación figuras/tablas | 23-24 oct | Ambos ejes | ⏳ |
| Redacción metodología | 23 oct | Esteban | ⏳ |
| Integración resultados | 24 oct (mañana) | Ambos ejes | ⏳ |
| Revisión final | 24 oct (tarde) | Todos | ⏳ |
| **ENTREGA** | **24 oct, 23:59** | **Todos** | ⏳ |

---

## 8. BIBLIOGRAFÍA REQUERIDA (Mínimo)

### Muestreo y Diseño Complejo
1. **Thompson, S. K. (2012).** *Sampling*, 3rd ed. Wiley.
   - Cap. 2: Conceptos fundamentales
   - Cap. 8-9: Diseños multietápicos
   - Cap. 12: Análisis de datos de encuesta

2. **Lohr, S. L. (2009).** *Sampling: Design and Analysis*, 2nd ed. Brooks/Cole.

3. **Lumley, T. (2010).** *Complex surveys: A guide to analysis using R*. Wiley.

4. **Särndal, C. E., Swensson, B., & Wretman, J. (2013).** *Model Assisted Survey Sampling*. Springer.

### CASEN y Contexto Chileno
5. Ministerio de Desarrollo Social y Familia. (2023). *Manual Metodológico CASEN 2022*.

6. Ministerio de Desarrollo Social y Familia. (2023). *Manual del Investigador CASEN 2022*.

7. Observatorio Social. *CASEN: Base de Datos*. [Disponible en sitio web oficial]

---

## 9. CONTACTO Y DUDAS

**Profesor del Curso:** Guillermo Marshall Rivera  
**Responsable del Proyecto (Grupo 4):** Esteban Román  

Para preguntas sobre:
- **Estructura del proyecto:** Contactar a Esteban Román
- **Metodología de muestreo:** Revisar Thompson (2012) y consultar con profesor
- **Acceso a datos CASEN:** Revisitar manual metodológico

---

**Documento actualizado:** 23 de octubre de 2025  
**Versión:** 1.0  
**Estado:** FINAL - LISTO PARA TRABAJO
