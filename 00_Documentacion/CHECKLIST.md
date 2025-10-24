# Checklist del Proyecto - EYP2417 Muestreo (Grupo 4)

Usa este archivo para trackear el progreso. Marca ✅ o ⏳ según corresponda.

**Entrega Final:** Viernes 24 de octubre, 23:59 hrs

---

## 📋 FASE 1: PREPARACIÓN (23 oct - HECHO)

### Estructura de Carpetas
- [x] 00_Documentacion/
- [x] 01_Datos/
- [x] 02_Analisis/ (01_Pobreza/ y 02_Brecha_Salarial/)
- [x] 03_Scripts/
- [x] 04_Informe/
- [x] 05_Outputs/

### Documentación
- [x] README.md
- [x] PROYECTO.md (especificaciones técnicas)
- [x] INICIO_RAPIDO.md
- [x] CHECKLIST.md (este archivo)

---

## 🔬 FASE 2: ANÁLISIS DE POBREZA (Esteban Román)

### 📊 Exploración de Datos
- [ ] Crear: `02_Analisis/01_Pobreza/01_exploratorio.ipynb`
- [ ] Cargar datos CASEN 2022
- [ ] Identificar variables de pobreza:
  - [ ] `pobreza` (valores: 1, 2, 3)
  - [ ] `region` (1-16)
  - [ ] `area` (1=urbano, 2=rural)
  - [ ] `ytotcorh` (ingreso)
  - [ ] `expr` (factor expansión)
  - [ ] `esc` (escolaridad)
- [ ] Verificar datos faltantes
- [ ] Crear tablas descriptivas básicas

### 📈 Análisis Formal
- [ ] Crear: `02_Analisis/01_Pobreza/02_analisis_pobreza.ipynb`
- [ ] **Incidencia de pobreza nacional** (PONDERADA)
  - [ ] % total pobre
  - [ ] % pobre extremo
  - [ ] Intervalo de confianza
- [ ] **Pobreza por región**
  - [ ] Tabla ranking de regiones
  - [ ] Gráfico: Incidencia por región
- [ ] **Urbano vs Rural**
  - [ ] Tabla comparativa
  - [ ] Gráfico: Diferencias urbano-rural
- [ ] **Factores asociados**
  - [ ] Pobreza por educación del jefe
  - [ ] Pobreza por tamaño del hogar
  - [ ] Pobreza por tipo de vivienda
- [ ] **Modelo multivariado** (opcional)
  - [ ] Regresión logit o similar
  - [ ] Interpretación de coeficientes

### 📊 Figuras y Tablas
- [ ] Tabla 1: Incidencia nacional y por región
- [ ] Tabla 2: Comparación urbano-rural
- [ ] Tabla 3: Factores asociados
- [ ] Figura 1: Gráfico incidencia por región
- [ ] Figura 2: Comparación urbano-rural
- [ ] Guardar en: `05_Outputs/`

---

## 💼 FASE 3: ANÁLISIS BRECHA SALARIAL (Francisca Sepúlveda)

### 📊 Exploración de Datos
- [ ] Crear: `02_Analisis/02_Brecha_Salarial/01_exploratorio.ipynb`
- [ ] Identificar variables clave:
  - [ ] `yoprinc` (ingreso trabajo principal)
  - [ ] `sexo` (1=hombre, 2=mujer)
  - [ ] `esc` (escolaridad)
  - [ ] `edad`
  - [ ] `region`
  - [ ] `expr` (factor expansión)
  - [ ] `ocup`, `rama` (si aplica)
- [ ] Verificar datos faltantes
- [ ] Crear histogramas de ingresos por sexo

### 📈 Análisis Formal
- [ ] Crear: `02_Analisis/02_Brecha_Salarial/02_analisis_brecha.ipynb`
- [ ] **Brecha salarial básica** (PONDERADA)
  - [ ] Ingreso promedio hombre
  - [ ] Ingreso promedio mujer
  - [ ] Diferencia absoluta y %
  - [ ] Intervalo de confianza
- [ ] **Brecha por educación**
  - [ ] Tabla: Brecha según nivel educativo
  - [ ] Gráfico: Brecha por educación
- [ ] **Brecha por región**
  - [ ] Tabla: Brecha por región
  - [ ] Gráfico: Variabilidad regional
- [ ] **Análisis de regresión**
  - [ ] Modelo: log(yoprinc) = sexo + educación + edad + ...
  - [ ] Interpretación de coeficientes
  - [ ] Pruebas de significancia

### 📊 Figuras y Tablas
- [ ] Tabla 1: Ingresos por sexo (nacional y ponderado)
- [ ] Tabla 2: Brecha salarial por educación
- [ ] Tabla 3: Brecha salarial por región
- [ ] Tabla 4: Resultados de regresión
- [ ] Figura 1: Brecha por educación
- [ ] Figura 2: Brecha por región
- [ ] Guardar en: `05_Outputs/`

---

## 🛠️ FASE 4: SCRIPTS MODULARES

### Python Utilities (`03_Scripts/`)
- [ ] `__init__.py` (archivo vacío para importación)
- [ ] `casen_utils.py` - Funciones para CASEN
  - [ ] `cargar_casen()` - Carga archivo .dta
  - [ ] `estadistica_ponderada()` - Calcula promedios con expr
  - [ ] `tabla_pobreza_region()` - Tabla pobreza por región
  - [ ] `tabla_urbano_rural()` - Comparación urbano-rural
  - [ ] `tabla_ingresos_sexo()` - Ingresos por sexo
  - [ ] `tabla_brecha_educacion()` - Brecha por educación
- [ ] `muestreo_utils.py` - Funciones para análisis muestral
  - [ ] `calcular_intervalo_confianza()` - IC para diseño complejo
  - [ ] `test_t_ponderado()` - Test t ajustado por diseño

---

## 📄 FASE 5: INFORME LaTeX (`04_Informe/`)

### Estructura de Archivos
- [ ] `00_preambulo.tex` - Paquetes y configuración común
- [ ] `informe_principal.tex` - Archivo maestro que incluye todo
- [ ] `01_Estructura/portada.tex` - Portada
- [ ] `01_Estructura/introduccion.tex` - Introducción
- [ ] `01_Estructura/metodologia.tex` - Metodología
- [ ] `01_Estructura/resultados_pobreza.tex` - Resultados eje 1
- [ ] `01_Estructura/resultados_brecha.tex` - Resultados eje 2
- [ ] `01_Estructura/conclusiones.tex` - Conclusiones
- [ ] `01_Estructura/referencias.tex` - Bibliografía

### Contenidos

#### Portada
- [ ] Título del proyecto
- [ ] Nombres de integrantes
- [ ] Curso: EYP2417 Muestreo
- [ ] Profesor: Guillermo Marshall Rivera
- [ ] Fecha: 24 de octubre de 2025
- [ ] Logo PUC (si disponible)

#### Introducción (0.5 página)
- [ ] Motivación: Por qué importa entender la realidad chilena
- [ ] Objetivo general del grupo
- [ ] Descripción de dos ejes temáticos
- [ ] Estructura del informe

#### Metodología (0.5-0.75 páginas)
- [ ] Descripción de encuesta CASEN 2022
- [ ] Diseño muestral (estratificado polietápico)
- [ ] Variable de expansión `expr`
- [ ] Variables utilizadas (tablas)
- [ ] Métodos estadísticos
- [ ] Referencia a Thompson (2012)

#### Resultados Eje 1: Pobreza (0.75-1 página)
- [ ] Tabla: Incidencia pobreza por región
- [ ] Figura: Gráfico incidencia por región
- [ ] Tabla: Comparación urbano-rural
- [ ] Análisis de factores asociados
- [ ] Interpretación de hallazgos

#### Resultados Eje 2: Brecha Salarial (0.75-1 página)
- [ ] Tabla: Ingresos por sexo
- [ ] Tabla: Brecha salarial
- [ ] Figura: Brecha por educación
- [ ] Tabla o resumen: Resultados de regresión
- [ ] Interpretación de hallazgos

#### Conclusiones (0.5 página)
- [ ] Resumen hallazgos principales (ambos ejes)
- [ ] Implicaciones políticas
- [ ] Limitaciones del estudio
- [ ] Líneas de investigación futura

#### Referencias (0.25 página)
- [ ] Thompson (2012) Sampling
- [ ] Lohr (2009)
- [ ] Lumley (2010)
- [ ] Särndal et al. (2013)
- [ ] Ministerio de Desarrollo Social (CASEN)
- [ ] Otras referencias según corresponda

### Compilación
- [ ] LaTeX compila sin errores
- [ ] Todas las referencias cruzadas funcionan
- [ ] Tamaño final: 3-4 páginas (sin portada ni referencias)
- [ ] PDF se ve profesional

---

## 🔍 FASE 6: CALIDAD Y VALIDACIÓN

### Análisis
- [ ] Todas las estimaciones usan `expr`
- [ ] Se reportan intervalos de confianza (al menos algunos)
- [ ] Resultados son lógicos y coherentes
- [ ] No hay valores faltantes no reportados
- [ ] Se cita Thompson (2012) o metodología de encuesta

### Código
- [ ] Notebooks reproducibles (sin errores)
- [ ] Scripts bien comentados
- [ ] Funciones reutilizables
- [ ] Commits meaningfull en Git

### Informe
- [ ] Sin errores ortográficos ni gramaticales
- [ ] Tablas y figuras numeradas
- [ ] Leyendas claras en figuras
- [ ] Referencias bibliográficas formales
- [ ] Extensión correcta (3-4 páginas)

### Final
- [ ] Revisar versión PDF una última vez
- [ ] Verificar que PDF abre correctamente
- [ ] Enviar a integrantes del grupo para revisión

---

## 📤 FASE 7: ENTREGA

### Archivos a Entregar
- [ ] `informe_principal.pdf` - Documento final
- [ ] Notebooks de análisis (comprimidos si es necesario)
- [ ] Scripts Python
- [ ] Archivo Git con historial completo

### Formato de Entrega
- [ ] Formato PDF de 3-4 páginas
- [ ] Nombre: `Grupo4_EYP2417_Muestreo_Entrega1.pdf`
- [ ] En: [Sistema de entrega del curso]

### Checklist Final
- [ ] Revisar especificaciones del profesor (3-4 páginas ✓)
- [ ] Verificar que incluye ambos ejes temáticos ✓
- [ ] Confirmar que usa CASEN 2022 ✓
- [ ] Verificar que menciona diseño muestral ✓

---

## 🎯 CRONOGRAMA REALISTA

| Fecha | Tiempo | Actividad | Responsable |
|-------|--------|-----------|-------------|
| 23 oct, 8h-9h | 1h | Leer documentación | Todos |
| 23 oct, 9h-12h | 3h | Exploración datos | Esteban/Francisca |
| 23 oct, 12h-13h | 1h | Pausa almuerzo | - |
| 23 oct, 13h-15h | 2h | Funciones Python | Ambos |
| 23 oct, 15h-17h | 2h | Análisis formal | Ambos |
| 23 oct, 17h-18h | 1h | Generar figuras | Ambos |
| 23 oct, 18h-20h | 2h | Redacción LaTeX | Todos |
| 24 oct, 8h-11h | 3h | Integración resultados | Todos |
| 24 oct, 11h-12h | 1h | Revisión metodología | Todos |
| 24 oct, 12h-14h | 2h | Ajustes finales | Todos |
| 24 oct, 14h-15h | 1h | Compilar PDF final | Esteban |
| 24 oct, 15h-20h | 5h | Buffer/contingencias | - |
| 24 oct, 20h-23:59 | 4h | Entrega antes de límite | Todos |

---

## ✅ VERSIÓN MÍNIMA VIABLE (Si no hay tiempo)

Si estás corriendo corto de tiempo, prioriza:

1. **OBLIGATORIO:**
   - Tabla: Pobreza por región (eje Esteban)
   - Tabla: Ingreso promedio por sexo (eje Francisca)
   - Metodología breve en LaTeX
   - Una figura por eje

2. **MUY IMPORTANTE:**
   - Gráficos mostrando resultados
   - Breve interpretación de resultados
   - Referencias formales

3. **DESEABLE (si hay tiempo):**
   - Análisis de regresión
   - Múltiples comparaciones (educación, región)
   - Análisis urbano-rural

4. **NICE-TO-HAVE:**
   - Intervalos de confianza complejos
   - Modelos multivariados sofisticados

---

## 🆘 PLAN B (Si algo falla)

| Problema | Plan B |
|----------|--------|
| Datos no cargan | Usar versión convertida a CSV |
| LaTeX no compila | Usar Overleaf en línea |
| Faltan datos variables | Usar subset disponible |
| Función no funciona | Copiar código directamente en notebook |
| Sin tiempo para modelos | Reportar solo estadística descriptiva |

---

## 📞 ASIGNACIÓN DE TAREAS

### Esteban Román (Distribución de Pobreza)
- [ ] Análisis exploratorio de variables de pobreza
- [ ] Tabla de incidencia por región
- [ ] Gráfico de pobreza por región
- [ ] Análisis urbano-rural
- [ ] Redacción de resultados en LaTeX

### Francisca Sepúlveda (Brecha Salarial de Género)
- [ ] Análisis exploratorio de ingresos
- [ ] Tabla de ingresos por sexo
- [ ] Análisis de brecha por educación
- [ ] Gráfico de brecha salarial
- [ ] Redacción de resultados en LaTeX

### Todos
- [ ] Metodología
- [ ] Introducción
- [ ] Conclusiones
- [ ] Revisión final

---

## 📊 ESTADO ACTUAL

**Última actualización:** 23 de octubre, 2025

| Componente | Estado | % |
|-----------|--------|---|
| Documentación | ✅ LISTO | 100% |
| Estructura de carpetas | ✅ LISTO | 100% |
| Análisis Pobreza | ⏳ EN PROGRESO | 10% |
| Análisis Brecha Salarial | ⏳ EN PROGRESO | 10% |
| Scripts Python | ⏳ EN PROGRESO | 20% |
| Informe LaTeX | ⏳ EN PROGRESO | 5% |
| **TOTAL** | **⏳** | **24%** |

---

**Imprime este checklist y marca ✅ conforme avances. ¡Tú puedes! 💪**

Recuerda: La entrega es mañana (24 de octubre) a las 23:59 hrs
