# 📖 ÍNDICE COMPLETO DE DOCUMENTACIÓN

**Bienvenido a la documentación del Proyecto Final EYP2417 - Muestreo (Grupo 4)**

Aquí encontrarás guías para cada necesidad. Selecciona la tuya:

---

## 🚀 EMPEZAR AHORA (5 minutos)

### Si tienes 5 minutos:
📄 **[INICIO_RAPIDO.md](INICIO_RAPIDO.md)** - Guía para comenzar en 5 minutos

### Si tienes 10 minutos:
📄 **[SINTESIS_FINAL.md](SINTESIS_FINAL.md)** - Resumen ejecutivo de todo lo creado

### Si tienes 15 minutos:
📄 **[ESTRUCTURA_VISUAL.md](ESTRUCTURA_VISUAL.md)** - Diagrama visual del proyecto

---

## 📚 DOCUMENTACIÓN TEMÁTICA

### Necesito entender...

#### 🎯 El proyecto en general
- **[README.md](../README.md)** - Descripción general, estructura, equipo
- **[PROYECTO.md](../PROYECTO.md)** - Especificaciones técnicas COMPLETAS

#### 📊 Mi eje temático (Esteban - Pobreza)
1. Lee sección "EJE 2: DISTRIBUCIÓN DE LA POBREZA" en **[PROYECTO.md](../PROYECTO.md)**
2. Busca sección "Distribución de Pobreza" en **[CHECKLIST.md](CHECKLIST.md)**
3. Usa ejemplos en **[EJEMPLOS_CODIGO.md](EJEMPLOS_CODIGO.md)** (Celdas 5-9)

#### 💼 El eje temático de Francisca (Brecha Salarial)
1. Lee sección "EJE 1: BRECHA SALARIAL DE GÉNERO" en **[PROYECTO.md](../PROYECTO.md)**
2. Busca sección "Análisis Brecha Salarial" en **[CHECKLIST.md](CHECKLIST.md)**
3. Usa ejemplos en **[EJEMPLOS_CODIGO.md](EJEMPLOS_CODIGO.md)** (adaptados)

---

## 💻 CÓDIGO Y EJEMPLOS

### Quiero escribir código:
📄 **[EJEMPLOS_CODIGO.md](EJEMPLOS_CODIGO.md)** - 11 ejemplos listos para copiar-pegar

**Ejemplos incluyen:**
- Celda 1: Importaciones y configuración
- Celda 2: Cargar datos CASEN
- Celda 3: Validar variables
- Celda 4: Análisis exploratorio
- Celda 5: **Tabla principal - Pobreza por región**
- Celda 6: Análisis urbano-rural
- Celda 7: Gráfico - Pobreza por región
- Celda 8: Gráfico - Urbano vs Rural
- Celda 9: Factores asociados
- Celda 10: Exportar resultados
- Celda 11: Insertar tablas en LaTeX

### Quiero usar funciones Python:
📄 **[../03_Scripts/casen_utils.py](../03_Scripts/casen_utils.py)** - Módulo con 12+ funciones

**Funciones disponibles:**
- `cargar_casen()` - Cargar datos
- `promedio_ponderado()` - Calcula promedios con `expr`
- `tabla_pobreza_region()` - Tabla de pobreza por región
- `tabla_urbano_rural()` - Comparación urbano/rural
- `tabla_ingresos_sexo()` - Ingresos por sexo
- `tabla_brecha_educacion()` - Brecha por educación
- Y más... (ver docstrings en archivo)

---

## ✅ TAREAS Y PROGRESO

### Quiero saber qué hacer:
📄 **[CHECKLIST.md](CHECKLIST.md)** - Lista completa de 150+ tareas

**Secciones:**
- FASE 1: Preparación ✅ (COMPLETADA)
- FASE 2: Análisis de Pobreza (TU SECCIÓN)
- FASE 3: Análisis Brecha Salarial (FRANCISCA)
- FASE 4: Scripts modulares
- FASE 5: Informe LaTeX
- FASE 6: Calidad y validación
- FASE 7: Entrega

---

## 🏗️ ESTRUCTURA

### Quiero entender la estructura:
📄 **[ESTRUCTURA_VISUAL.md](ESTRUCTURA_VISUAL.md)** - Diagrama visual

O lee estructura en **[INICIO_RAPIDO.md](INICIO_RAPIDO.md)** sección 1

---

## 📝 ESPECIFICACIONES TÉCNICAS

### Quiero detalles exactos:
📄 **[../PROYECTO.md](../PROYECTO.md)** - 3,500+ líneas de especificaciones

**Contiene:**
- Rol y contexto del proyecto
- Objetivo general y específicos
- Variables clave con descripción
- Métodos estadísticos a usar
- Especificaciones de LaTeX
- Checklist de calidad
- Cronograma
- Bibliografía requerida

---

## 📍 ESTRUCTURA DE CARPETAS

### Quiero ver dónde va cada cosa:
```
Proyecto-Final-Muestreo/
│
├─ 📖 00_Documentacion/         ← ESTÁS AQUÍ
│  ├─ README.md
│  ├─ PROYECTO.md
│  ├─ INICIO_RAPIDO.md
│  ├─ CHECKLIST.md
│  ├─ ESTRUCTURA_VISUAL.md
│  ├─ RESUMEN_EJECUTIVO.md
│  ├─ EJEMPLOS_CODIGO.md
│  ├─ SINTESIS_FINAL.md
│  ├─ GAPS_INFORMACIONALES_CUBIERTOS.md  ← NUEVO
│  ├─ REFERENCIAS_TECNICAS_DISEÑO_COMPLEJO.md  ← NUEVO
│  ├─ INDICE.md (este archivo)
│  ├─ ESTRATEGIA_GIT.md
│  ├─ README_GITHUB.md
│  └─ VERIFICACION_GITHUB.md
│
├─ 📂 01_Datos/                 ← Aquí va CASEN 2022
│
├─ 📂 02_Analisis/
│  ├─ 01_Pobreza/              ← TU CARPETA (Esteban)
│  └─ 02_Brecha_Salarial/      ← Carpeta de Francisca
│
├─ 📂 03_Scripts/
│  ├─ casen_utils.py           ← Funciones Python
│  └─ __init__.py
│
├─ 📂 04_Informe/
│  ├─ 00_preambulo.tex
│  ├─ informe_principal.tex    ← Archivo a compilar
│  ├─ 01_Estructura/
│  │  ├─ portada.tex
│  │  ├─ introduccion.tex
│  │  ├─ metodologia.tex
│  │  ├─ resultados_pobreza.tex ← Tu sección
│  │  ├─ resultados_brecha.tex
│  │  ├─ conclusiones.tex
│  │  └─ referencias.tex
│  └─ 02_Figuras/              ← Guardar gráficos aquí
│
└─ 📂 05_Outputs/              ← Guardar resultados aquí
```

---

## 🔍 BÚSQUEDA POR TEMA

### Análisis de Pobreza
- Especificaciones: **[PROYECTO.md](../PROYECTO.md)** sección "EJE 2"
- Tareas: **[CHECKLIST.md](CHECKLIST.md)** sección "FASE 2"
- Ejemplos código: **[EJEMPLOS_CODIGO.md](EJEMPLOS_CODIGO.md)** celdas 5-9
- LaTeX template: **[../04_Informe/01_Estructura/resultados_pobreza.tex](../04_Informe/01_Estructura/resultados_pobreza.tex)**
- Funciones Python: **[../03_Scripts/casen_utils.py](../03_Scripts/casen_utils.py)** `tabla_pobreza_region()`

### Análisis de Brecha Salarial
- Especificaciones: **[PROYECTO.md](../PROYECTO.md)** sección "EJE 1"
- Tareas: **[CHECKLIST.md](CHECKLIST.md)** sección "FASE 3"
- Ejemplos código: **[EJEMPLOS_CODIGO.md](EJEMPLOS_CODIGO.md)** (adaptables)
- LaTeX template: **[../04_Informe/01_Estructura/resultados_brecha.tex](../04_Informe/01_Estructura/resultados_brecha.tex)**
- Funciones Python: **[../03_Scripts/casen_utils.py](../03_Scripts/casen_utils.py)** `tabla_ingresos_sexo()`

### Metodología de Muestreo
- Conceptos: **[PROYECTO.md](../PROYECTO.md)** sección "METODOLOGÍA"
- Diseño CASEN: **[PROYECTO.md](../PROYECTO.md)** sección "ESPECIFICACIONES TÉCNICAS"
- Referencias: Thompson (2012), Lohr (2009)

### LaTeX
- Estructura: **[../04_Informe/informe_principal.tex](../04_Informe/informe_principal.tex)**
- Plantillas: **[../04_Informe/01_Estructura/](../04_Informe/01_Estructura/)**
- Configuración: **[../04_Informe/00_preambulo.tex](../04_Informe/00_preambulo.tex)**

---

## 📅 CRONOGRAMA

**Necesito saber cuándo debo hacer qué:**

→ Ver **[CHECKLIST.md](CHECKLIST.md)** sección "CRONOGRAMA"  
→ O **[INICIO_RAPIDO.md](INICIO_RAPIDO.md)** sección "PRÓXIMAS ACCIONES"

---

## 🆘 PREGUNTAS FRECUENTES

### P: ¿Por dónde empiezo?
**R:** Lee **[INICIO_RAPIDO.md](INICIO_RAPIDO.md)** (5 minutos)

### P: ¿Qué necesito analizar exactamente?
**R:** Lee tu eje temático en **[PROYECTO.md](../PROYECTO.md)**

### P: ¿Tienes ejemplos de código?
**R:** Sí, 11 ejemplos en **[EJEMPLOS_CODIGO.md](EJEMPLOS_CODIGO.md)** (copy-paste)

### P: ¿Qué funciones Python tengo disponibles?
**R:** 12+ en **[../03_Scripts/casen_utils.py](../03_Scripts/casen_utils.py)**

### P: ¿Cómo uso el módulo Python?
**R:** Ejemplos en **[EJEMPLOS_CODIGO.md](EJEMPLOS_CODIGO.md)** Celdas 1-3

### P: ¿Cómo inserto mis resultados en LaTeX?
**R:** Ver **[EJEMPLOS_CODIGO.md](EJEMPLOS_CODIGO.md)** Celda 11

### P: ¿Cuánto tiempo tengo?
**R:** Hasta mañana (24 octubre) 23:59 hrs. Ver **[CHECKLIST.md](CHECKLIST.md)** cronograma

### P: ¿Qué es importante recordar?
**R:** Leer **[INICIO_RAPIDO.md](INICIO_RAPIDO.md)** sección "TIPS CLAVE"

---

## 📊 NIVEL DE DETALLE POR DOCUMENTO

| Documento | Nivel | Audiencia | Tiempo |
|-----------|-------|-----------|--------|
| INICIO_RAPIDO.md | Beginner | Todos | 5 min |
| ESTRUCTURA_VISUAL.md | Beginner | Todos | 3 min |
| EJEMPLOS_CODIGO.md | Intermediate | Programadores | 10 min |
| CHECKLIST.md | Intermediate | Todos | Variable |
| SINTESIS_FINAL.md | Intermediate | Todos | 10 min |
| PROYECTO.md | Advanced | Analistas | 30 min |
| casen_utils.py | Advanced | Programadores | 15 min |

---

## 🎯 RUTAS RECOMENDADAS SEGÚN NECESIDAD

### Ruta A: "Empezar lo antes posible"
1. INICIO_RAPIDO.md (5 min)
2. EJEMPLOS_CODIGO.md Celdas 1-4 (5 min)
3. Comenzar notebook (Ahora)

### Ruta B: "Entender todo primero"
1. INICIO_RAPIDO.md (5 min)
2. PROYECTO.md tu eje (15 min)
3. ESTRUCTURA_VISUAL.md (3 min)
4. Comenzar análisis (Informado)

### Ruta C: "Tengo dudas específicas"
1. Busca en CHECKLIST.md tu fase
2. Encuentra respuesta en PROYECTO.md
3. Mira ejemplo en EJEMPLOS_CODIGO.md
4. Consulta función en casen_utils.py

---

## 💾 DESCARGAR/COPIAR DOCUMENTACIÓN

Todos estos archivos están en:
```
00_Documentacion/
├── README.md
├── PROYECTO.md
├── INICIO_RAPIDO.md
├── CHECKLIST.md
├── ESTRUCTURA_VISUAL.md
├── RESUMEN_EJECUTIVO.md
├── EJEMPLOS_CODIGO.md
├── SINTESIS_FINAL.md
└── INDICE.md (este archivo)
```

Cópialos a tu dispositivo si quieres consultarlos offline.

---

## 🔗 REFERENCIAS CRUZADAS

Para ir de un documento a otro:

- **README.md** ← Inicio general
  - → PROYECTO.md (detalles técnicos)
  - → INICIO_RAPIDO.md (comenzar)

- **PROYECTO.md** ← Especificaciones completas
  - → CHECKLIST.md (tareas)
  - → EJEMPLOS_CODIGO.md (cómo hacerlo)

- **INICIO_RAPIDO.md** ← Guía rápida
  - → EJEMPLOS_CODIGO.md (código)
  - → CHECKLIST.md (tareas)

- **CHECKLIST.md** ← Tareas por fase
  - → PROYECTO.md (qué es cada tarea)
  - → EJEMPLOS_CODIGO.md (cómo hacerlo)

- **EJEMPLOS_CODIGO.md** ← Código copy-paste
  - → casen_utils.py (más funciones)
  - → 04_Informe/01_Estructura/ (LaTeX templates)

---

## 📞 AYUDA

| Problema | Buscar en | Sección |
|----------|-----------|---------|
| No sé por dónde empezar | INICIO_RAPIDO.md | "Próximos Pasos" |
| No entiendo qué hacer | PROYECTO.md | Tu eje temático |
| Necesito código | EJEMPLOS_CODIGO.md | Celda relevante |
| No encuentro función | casen_utils.py | Docstrings |
| Necesito LaTeX | 04_Informe/ | Plantillas |
| Tengo dudas metodología | PROYECTO.md | "Métodos Estadísticos" |
| Debo entregar qué | CHECKLIST.md | "FASE 7: ENTREGA" |

---

## 📘 NUEVOS DOCUMENTOS METODOLÓGICOS (Nov 2025)

### Gaps Informacionales y Referencias Técnicas

**📄 [GAPS_INFORMACIONALES_CUBIERTOS.md](GAPS_INFORMACIONALES_CUBIERTOS.md)**
- Detalle completo de gaps identificados en diseño muestral CASEN 2022
- Cómo fueron integrados en el beamer presentation
- Cobertura del marco, niveles de inferencia, exclusiones
- Métodos de análisis con diseño complejo
- Referencias cruzadas a diapositivas específicas

**📄 [REFERENCIAS_TECNICAS_DISEÑO_COMPLEJO.md](REFERENCIAS_TECNICAS_DISEÑO_COMPLEJO.md)**
- Fórmulas completas: Horvitz-Thompson, Hájek, varianzas
- Método EVCU/WR y linealización de Taylor
- Regresión lineal y logística con diseño complejo
- Errores estándar robustos (cluster)
- Imputación múltiple (Reglas de Rubin)
- Ajustes por comparaciones múltiples (BH, Holm-Bonferroni)
- Dominios de estimación CASEN 2022
- Referencias bibliográficas completas

**Cuándo usar estos documentos:**
- Cuando necesites justificar metodología estadística
- Para incluir fórmulas en el informe LaTeX
- Al responder preguntas sobre diseño muestral
- Como material de referencia técnica
- Para entender limitaciones de inferencia

---

## 🏁 RESUMEN

Has recibido **10+ documentos** que cubren:
- ✅ Introducción rápida (5 min)
- ✅ Especificaciones completas (30 min)
- ✅ Ejemplos de código (15 min)
- ✅ Lista de tareas (variable)
- ✅ Estructura visual (3 min)
- ✅ Scripts Python reutilizables
- ✅ Plantillas LaTeX listas
- ✅ **Gaps informacionales cubiertos (NUEVO)**
- ✅ **Referencias técnicas completas (NUEVO)**

**Todo está aquí. Elige por dónde empezar.**

---

## 🚀 SIGUIENTE PASO

**Ahora reads:** [INICIO_RAPIDO.md](INICIO_RAPIDO.md) (5 minutos)

Luego comienza tu análisis con confianza 💪

---

**Índice actualizado:** 23 de octubre de 2025  
**Versión:** 1.0 FINAL  
**Estado:** ✅ LISTO
