# Compilación del Informe LaTeX - Guía Rápida

## ✅ Estado Actual

El informe ha sido compilado exitosamente con **18 páginas** e incluye:

✅ **Portada** con logo UC  
✅ **Tabla de contenidos** automática  
✅ **Objetivo General** - Problema a estudiar y relevancia  
✅ **Encuesta CASEN 2022** - Descripción completa  
✅ **Objetivos Específicos** - 3 preguntas de investigación por eje  
✅ **Revisión de Antecedentes** - Referencias bibliográficas previas  
✅ **Metodología** - Diseño muestral y métodos analíticos  
✅ **Resultados** - Plantillas para ambos ejes (Pobreza y Brecha Salarial)  
✅ **Conclusiones** - Sección final  
✅ **Referencias** - Bibliografía completa  

---

## 🔧 Cómo Compilar

### Opción 1: Con XeLaTeX (Recomendado - Soporta mejor formatos)

```bash
cd 04_Informe
xelatex -interaction=nonstopmode informe_principal.tex
```

**Segunda compilación** (para referencias cruzadas):
```bash
xelatex -interaction=nonstopmode informe_principal.tex
```

### Opción 2: Con pdfLaTeX (Si XeLaTeX no está disponible)

```bash
cd 04_Informe
pdflatex -interaction=nonstopmode informe_principal.tex
pdflatex -interaction=nonstopmode informe_principal.tex
```

### Opción 3: Compilación Automática (Latexmk)

```bash
cd 04_Informe
latexmk -xelatex -interaction=nonstopmode informe_principal.tex
```

---

## 📊 Estructura del Documento

```
informe_principal.pdf (18 páginas)
├── Portada (página 1-2)
│   └── Logo UC
├── Tabla de Contenidos (página 2)
├── Objetivo General (página 3)
├── Encuesta CASEN 2022 (páginas 4-5)
│   ├── Descripción institucional
│   ├── Variables de interés
│   ├── Accesibilidad
│   └── Tabla de variables
├── Objetivos Específicos (página 6)
│   ├── Eje 1: Pobreza
│   ├── Eje 2: Brecha Salarial
│   └── Preguntas transversales
├── Revisión de Antecedentes (páginas 7-9)
│   ├── Estudios sobre pobreza
│   ├── Estudios sobre brecha salarial
│   └── Metodología de muestreo
├── Metodología (páginas 10-12)
│   ├── Diseño muestral CASEN 2022
│   ├── Marco teórico Thompson
│   ├── Métodos analíticos
│   └── Control de calidad
├── Resultados (páginas 13-14)
│   ├── Pobreza (PLANTILLA para llenar)
│   └── Brecha Salarial (PLANTILLA para llenar)
├── Conclusiones (página 15)
└── Referencias (página 16)
```

---

## 📁 Logos Disponibles

Los logos están en `04_Informe/03_Logos/`:

- **logo_uc.png** (ACTUAL) - Logo oficial UC
- **logo_1_uc.svg** - Alternativa 1 (SVG)
- **logo_2_uc.svg** - Alternativa 2 (SVG)
- **logo_3_uc.svg** - Alternativa 3 (SVG)

### Cambiar Logo

Edita `01_Estructura/portada.tex` y cambia:

```latex
\includegraphics[width=0.12\textwidth]{03_Logos/logo_uc.png}
```

Por cualquiera de:
```latex
\includegraphics[width=0.15\textwidth]{03_Logos/logo_1_uc.svg}
\includegraphics[width=0.15\textwidth]{03_Logos/logo_2_uc.svg}
\includegraphics[width=0.15\textwidth]{03_Logos/logo_3_uc.svg}
```

Luego recompila con `xelatex`.

---

## 🎨 Personalización Rápida

### Cambiar Colores

Edita `00_preambulo.tex`:

```latex
% Definición de colores PUC (celestes)
\definecolor{celesteprincipal}{RGB}{0,150,200}
\definecolor{celesteoscuro}{RGB}{0,105,148}
```

### Cambiar Márgenes

```latex
\geometry{left=2.5cm, right=2.5cm, top=2.8cm, bottom=2.8cm}
```

### Cambiar Espaciado

```latex
\onehalfspacing  % 1.5 espacios
% O usar: \doublespacing (doble) o \singlespacing (simple)
```

---

## 📝 Cómo Completar las Secciones de Resultados

### 1. Análisis de Pobreza

Edita: `01_Estructura/resultados_pobreza.tex`

```latex
\section{Resultados: Distribución de la Pobreza}

\subsection{Incidencia por Región}

[AQUÍ: Agregar tabla con incidencia de pobreza por región, 
con ponderador expr, desde casen_utils.tabla_pobreza_region()]

\subsection{Comparación Urbano-Rural}

[AQUÍ: Agregar tabla comparativa urban/rural]

\subsection{Factores Asociados}

[AQUÍ: Agregar análisis de variables asociadas]
```

### 2. Análisis de Brecha Salarial

Edita: `01_Estructura/resultados_brecha.tex`

```latex
\section{Resultados: Brecha Salarial de Género}

\subsection{Brecha por Región}

[AQUÍ: Tabla de ingresos por género]

\subsection{Estratificación por Educación}

[AQUÍ: Tabla brecha por nivel educativo]

\subsection{Modelos de Regresión}

[AQUÍ: Resultados de modelo explicativo]
```

---

## 🚀 Flujo de Trabajo Recomendado

1. **Semana 1-2**: Completar análisis en Jupyter/Python
   - `02_Analisis/01_Pobreza/` 
   - `02_Analisis/02_Brecha_Salarial/`

2. **Generar resultados**:
   ```python
   from scripts import cargar_casen, tabla_pobreza_region, tabla_urbano_rural
   casen = cargar_casen('01_Datos/Base de datos Casen 2022 STATA_18 marzo 2024.dta')
   
   # Para pobreza
   tabla_pobreza = tabla_pobreza_region(casen)
   tabla_pobreza.to_csv('05_Outputs/tabla_pobreza_region.csv')
   
   # Para brecha
   tabla_brecha = tabla_ingresos_sexo(casen)
   tabla_brecha.to_csv('05_Outputs/tabla_brecha_sexo.csv')
   ```

3. **Copiar resultados a LaTeX**:
   - Incluir tablas generadas en `resultados_pobreza.tex`
   - Incluir tablas generadas en `resultados_brecha.tex`
   - Agregar figuras/gráficos en `02_Figuras/`

4. **Compilar PDF final**:
   ```bash
   cd 04_Informe
   xelatex -interaction=nonstopmode informe_principal.tex
   xelatex -interaction=nonstopmode informe_principal.tex
   ```

5. **Entregar antes del 24 de octubre 23:59**

---

## 🐛 Solución de Problemas

### Problema: "File not found" para logo

**Solución**: Verifica que el archivo existe en `04_Informe/03_Logos/`

```bash
ls -la 04_Informe/03_Logos/
```

### Problema: Referencias cruzadas incompletas

**Solución**: Ejecuta compilación dos veces:

```bash
xelatex -interaction=nonstopmode informe_principal.tex
xelatex -interaction=nonstopmode informe_principal.tex
```

### Problema: Caracteres especiales no se ven

**Solución**: Asegúrate de usar `xelatex` en lugar de `pdflatex`

```bash
which xelatex  # Verificar que está instalado
```

### Problema: Tablas muy anchas

**Solución**: Usa `\small` o `\tiny` en la tabla:

```latex
\begin{table}[H]
\small
\centering
\caption{Tabla...}
...
\end{table}
```

---

## 📞 Contacto

- **Problemas técnicos**: Esteban Román
- **Contenido de análisis**: Grupo 4 (Francisca, Alexander, Julian)
- **Plazo de entrega**: 24 de octubre de 2025, 23:59

---

**Última actualización**: 23 de octubre de 2025  
**Estado**: ✅ LISTO PARA USAR  
**PDF generado**: 18 páginas
