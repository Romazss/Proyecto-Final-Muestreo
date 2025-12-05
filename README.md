# Proyecto Final EYP2417 - Muestreo (Grupo 4)
## Análisis de Desigualdad Territorial y Brecha Salarial de Género en Chile
### Encuesta CASEN 2022

**Estado:** ✅ **COMPLETADO**  
**Entrega:** 3 de diciembre de 2025  
**Profesor:** Guillermo Marshall Rivera  
**Profesor Asistente:** Esteban Grawe  
**Institución:** Pontificia Universidad Católica de Chile

---

## 📋 Estructura del Proyecto

```
📦 Proyecto-Final-Muestreo
├── 📂 00_Documentacion/              ← Guías, manuales CASEN y entregas
│   ├── Documentos_Casen/             ← Documentación oficial CASEN 2022
│   └── Entregas_equipo/              ← Entregas parciales del equipo
├── 📂 02_Data/                       ← Base de datos CASEN 2022
├── 📂 03_Scripts/                    ← Código de análisis
│   ├── Python/                       ← Notebooks de análisis
│   │   ├── Analisis_casen.ipynb      ← Análisis principal
│   │   └── mapa.ipynb                ← Generación de mapas
│   └── R/                            ← Scripts R para diseño muestral
│       └── Muestreo_Casen/           ← Análisis con diseño complejo
│           ├── codigos_analisis_mejorado.R
│           ├── figuras/              ← Gráficos generados (10 figuras)
│           └── resultados/           ← Tablas CSV exportadas
├── 📂 04_Informe/                    ← Documentos LaTeX
│   ├── Informe_Final/                ← 📄 INFORME PRINCIPAL
│   │   ├── informe_principal.tex     ← Documento maestro
│   │   ├── 00_preambulo.tex          ← Configuración y paquetes
│   │   ├── 01_resumen.tex            ← Resumen ejecutivo
│   │   ├── 02_introduccion.tex       ← Marco teórico
│   │   ├── 03_metodos.tex            ← Metodología
│   │   ├── 04_resultados.tex         ← Resultados
│   │   ├── 05_discusion.tex          ← Discusión
│   │   ├── 06_conclusiones.tex       ← Conclusiones
│   │   ├── 07_referencias.tex        ← Bibliografía
│   │   └── Imagenes/                 ← Figuras del informe
│   └── informes1y2/                  ← Entregas anteriores
├── 📂 notebook_verificacion/         ← Validación de resultados
├── README.md                         ← Este archivo
├── PROYECTO.md                       ← Especificaciones del proyecto
└── requirements.txt                  ← Dependencias Python
```

---

## 👥 Integrantes del Grupo 4

| Nombre | Rol |
|--------|-----|
| **Esteban Román** | Análisis de pobreza territorial y coordinación |
| **Francisca Sepúlveda** | Análisis de brecha salarial de género |
| **Alexander Pinto** | Revisión y validación |
| **Julián Vargas** | Documentación y presentación |

---

## 🎯 Resumen del Proyecto

Este estudio analiza dos fenómenos de desigualdad socioeconómica en Chile utilizando datos de la **Encuesta CASEN 2022** (n = 72,056 jefes de hogar):

### Eje 1: Distribución de la Pobreza
- **Hallazgo principal:** La pobreza rural (8.37%) es significativamente mayor que la urbana (5.28%)
- **Mediación:** La menor escolaridad rural explica el **44.9%** del efecto sobre la pobreza
- **Test estadístico:** χ² Rao-Scott = 131.79, p < 0.001

### Eje 2: Brecha Salarial de Género
- **Brecha bruta:** 20.7% (diferencia de $290,353 CLP)
- **Brecha ajustada:** 18.2% controlando por educación, edad y ocupación
- **Patrón no lineal:** Máxima en técnico superior (21.1%) y postgrado (20.8%)

---

## 🔬 Metodología

### Diseño Muestral Complejo
Se implementó el diseño muestral completo de CASEN 2022:

```r
diseno_casen <- svydesign(
  ids = ~varunit,      # 12,545 conglomerados (UPM)
  strata = ~varstrat,  # 764 estratos
  weights = ~expr,     # Factor de expansión
  data = jefes,
  nest = TRUE
)
```

### Análisis Realizados
- ✅ Estimaciones ponderadas con IC 95%
- ✅ Tests Chi-cuadrado de Rao-Scott
- ✅ Modelos logísticos (quasibinomial)
- ✅ Análisis de mediación (Test de Sobel)
- ✅ Modelos log-lineales para brecha salarial

---

## 📊 Resultados Principales

| Indicador | Valor | IC 95% |
|-----------|-------|--------|
| Pobreza urbana | 5.28% | [5.04%, 5.52%] |
| Pobreza rural | 8.37% | [7.79%, 8.95%] |
| Brecha salarial bruta | 20.7% | p < 0.001 |
| Brecha salarial ajustada | 18.2% | p < 0.001 |
| Proporción mediada (educación) | 44.9% | Z = 16.80 |

### Regiones con Mayor Pobreza
1. La Araucanía: 9.97%
2. Ñuble: 9.97%
3. Tarapacá: 9.36%

### Regiones con Menor Pobreza
1. Magallanes: 2.73%
2. Aysén: 3.38%
3. Metropolitana: 3.73%

---

## 📁 Outputs Generados

### Figuras (en `03_Scripts/R/Muestreo_Casen/figuras/`)
- `g1_pobreza_region.png` - Pobreza por región
- `g2_ingreso_educacion_sexo.png` - Ingreso por educación y sexo
- `g3_brecha_educacion.png` - Brecha salarial por educación
- `g4_pobreza_urbano_rural.png` - Comparación urbano/rural
- `g5_distribucion_ingreso_sexo.png` - Distribución de ingresos
- `g6_escolaridad_zona.png` - Escolaridad por zona
- `g7_pobreza_region_zona.png` - Pobreza por región y zona
- `g8_brecha_edad.png` - Brecha por edad
- `g9_forest_plot_pobreza.png` - Odds ratios
- `g10_diagrama_mediacion.png` - Análisis de mediación

### Tablas CSV (en `03_Scripts/R/Muestreo_Casen/resultados/`)
- `pobreza_por_region.csv`
- `pobreza_por_area.csv`
- `ingreso_por_sexo.csv`
- `brecha_por_educacion.csv`
- `brecha_por_edad.csv`

---

## 🛠️ Herramientas Utilizadas

| Herramienta | Versión | Uso |
|------------|---------|-----|
| **R** | 4.x | Análisis estadístico principal |
| **survey** | - | Diseño muestral complejo |
| **srvyr** | - | Interfaz tidyverse para survey |
| **ggplot2** | - | Visualizaciones |
| **Python** | 3.x | Análisis complementario |
| **LaTeX** | TeX Live 2025 | Redacción del informe |

---

## 📝 Compilar el Informe

```bash
cd 04_Informe/Informe_Final
pdflatex -interaction=nonstopmode informe_principal.tex
pdflatex -interaction=nonstopmode informe_principal.tex  # Segunda pasada
```

El PDF final tiene **16 páginas** con todas las figuras y tablas integradas.

---

## 📚 Referencias Principales

- Ministerio de Desarrollo Social y Familia (2023). *Informe de Resultados CASEN 2022*
- Lumley, T. (2010). *Complex Surveys: A Guide to Analysis Using R*
- Baron, R. M., & Kenny, D. A. (1986). The moderator-mediator variable distinction
- Thompson, S. K. (2012). *Sampling* (3rd ed.)

---

## 📞 Contacto

**Repositorio:** [github.com/Romazss/Proyecto-Final-Muestreo](https://github.com/Romazss/Proyecto-Final-Muestreo)

---

**Última actualización:** 3 de diciembre de 2025  
**Estado:** ✅ Completado y entregado
