# 📊 GUÍA RÁPIDA: Cómo Comenzar

Esta guía te ayudará a empezar con el análisis del proyecto en 5 minutos.

---

## 1️⃣ ESTRUCTURA DEL PROYECTO (Lee esto primero)

```
Proyecto-Final-Muestreo/
├── 📋 README.md              ← Descripción general del proyecto
├── 📋 PROYECTO.md            ← Especificaciones técnicas DETALLADAS
├── 📋 INICIO_RAPIDO.md       ← Este archivo
│
├── 📂 00_Documentacion/       ← Guías y especificaciones
├── 📂 01_Datos/               ← Base CASEN 2022 (.dta) - AQUÍ VAN LOS DATOS
├── 📂 02_Analisis/            ← Tus notebooks de análisis
│   ├── 01_Pobreza/           ← TU CARPETA: Análisis de distribución de pobreza
│   │   ├── exploratorio.ipynb
│   │   ├── analisis_final.ipynb
│   │   └── figuras/
│   └── 02_Brecha_Salarial/   ← Carpeta de Francisca
│
├── 📂 03_Scripts/             ← Funciones Python reutilizables
│   ├── __init__.py
│   ├── casen_utils.py        ← Funciones auxiliares para CASEN
│   └── muestreo_utils.py     ← Funciones para diseño muestral
│
├── 📂 04_Informe/             ← TU INFORME LaTeX
│   ├── informe_principal.tex ← ARCHIVO PRINCIPAL que compila todo
│   ├── 01_Estructura/        ← Secciones separadas por módulo
│   │   ├── portada.tex
│   │   ├── metodologia.tex
│   │   ├── resultados_pobreza.tex
│   │   ├── resultados_brecha.tex
│   │   └── conclusiones.tex
│   └── 02_Figuras/           ← Aquí van los gráficos generados
│
└── 📂 05_Outputs/             ← Resultados finales (tablas, gráficos)
```

---

## 2️⃣ LO QUE DEBES HACER HOY (Prioridad)

### ✅ Paso 1: Léete la documentación rápido
```
Tiempo: 10 minutos
Archivos: README.md y PROYECTO.md
Por qué: Necesitas entender qué hace el grupo y qué espera el profesor
```

### ✅ Paso 2: Coloca el archivo de datos en la carpeta correcta
```
Acción: Mover "Base de datos Casen 2022 STATA_18 marzo 2024.dta" 
        a la carpeta 01_Datos/

Tiempo: 1 minuto
```

### ✅ Paso 3: Crea tu primer notebook para explorar los datos
```
Ubicación: 02_Analisis/01_Pobreza/01_exploratorio.ipynb

Incluye:
- Cargar los datos
- Verificar variables clave para pobreza
- Primeras estadísticas descriptivas
- Identificar datos faltantes

Tiempo: 20-30 minutos
```

### ✅ Paso 4: Crea un script Python modular
```
Ubicación: 03_Scripts/casen_utils.py

Incluye funciones para:
- Cargar y validar datos CASEN
- Aplicar factores de expansión (expr)
- Crear tablas ponderadas
- Comparaciones urbano-rural

Tiempo: 20-30 minutos
```

---

## 3️⃣ ESTRUCTURA DE TU ANÁLISIS (Distribución de Pobreza)

### Notebook: `01_exploratorio.ipynb`
**Objetivo:** Entender los datos

```python
# Sección 1: Carga de datos
# - Importar pandas, numpy, etc
# - Cargar archivo .dta
# - Verificar dimensiones y variables

# Sección 2: Variables de interés
# - Verificar disponibilidad de:
#   * pobreza
#   * region, area
#   * esc, edad
#   * ytotcorh, expr

# Sección 3: Datos faltantes
# - % de datos completos por variable
# - Estrategia de manejo

# Sección 4: Estadísticas descriptivas
# - Frecuencias de pobreza
# - Distribución de ingresos
# - Composición demográfica
```

### Notebook: `02_analisis_pobreza.ipynb`
**Objetivo:** Análisis formal de pobreza

```python
# Sección 1: Pobreza nacional (PONDERADO)
# - Incidencia de pobreza usando expr
# - Intervalo de confianza

# Sección 2: Pobreza por región
# - Tabla con pobreza por región
# - Gráfico: Incidencia por región

# Sección 3: Urbano vs Rural
# - Comparación ponderada
# - Por región: tabla y gráfico

# Sección 4: Factores asociados
# - Pobreza por educación
# - Pobreza por tamaño hogar
# - Modelo logit si tienes tiempo

# Sección 5: Figuras finales
# - Gráficos listos para LaTeX
# - Exportar a 05_Outputs/
```

---

## 4️⃣ ESTRUCTURA DE TU INFORME LaTeX (en 04_Informe/)

### Archivo principal: `informe_principal.tex`
```tex
\documentclass[12pt,letterpaper]{article}

% Cargar preámbulo común
\input{00_preambulo.tex}

\begin{document}

% Portada
\input{01_Estructura/portada.tex}

% Secciones
\input{01_Estructura/introduccion.tex}
\input{01_Estructura/metodologia.tex}
\input{01_Estructura/resultados_pobreza.tex}
\input{01_Estructura/resultados_brecha.tex}
\input{01_Estructura/conclusiones.tex}
\input{01_Estructura/referencias.tex}

\end{document}
```

### Archivo: `01_Estructura/metodologia.tex`
```tex
\section{Metodología}

\subsection{Encuesta CASEN 2022}
- Descripción de encuesta
- Diseño muestral estratificado polietápico
- Variable de expansión expr

\subsection{Variables Utilizadas}
% Tabla con variables por eje

\subsection{Métodos Estadísticos}
- Estadística descriptiva ponderada
- Comparaciones por región/zona
- Modelos de regresión (si corresponde)
```

---

## 5️⃣ CÓDIGO PARA COMENZAR

### `03_Scripts/casen_utils.py`

```python
import pandas as pd
import numpy as np
from typing import Tuple

def cargar_casen(ruta_archivo: str) -> pd.DataFrame:
    """
    Carga datos CASEN 2022 desde archivo .dta
    
    Args:
        ruta_archivo: ruta al archivo .dta
    
    Returns:
        DataFrame con datos CASEN
    """
    print(f"📁 Cargando archivo: {ruta_archivo}")
    df = pd.read_stata(ruta_archivo, convert_categoricals=False)
    print(f"✅ Datos cargados: {df.shape[0]:,} observaciones, {df.shape[1]} variables")
    return df


def estadistica_ponderada(df: pd.DataFrame, variable: str, 
                         ponderador: str = 'expr') -> Tuple[float, float]:
    """
    Calcula promedio ponderado de una variable
    
    Args:
        df: DataFrame con datos
        variable: nombre de variable a promediar
        ponderador: nombre de variable de expansión
    
    Returns:
        (promedio_ponderado, desv_estándar)
    """
    validos = df[[variable, ponderador]].dropna()
    promedio = (validos[variable] * validos[ponderador]).sum() / validos[ponderador].sum()
    varianza = ((validos[variable] - promedio)**2 * validos[ponderador]).sum() / validos[ponderador].sum()
    desv_est = np.sqrt(varianza)
    return promedio, desv_est


def tabla_pobreza_region(df: pd.DataFrame, ponderador: str = 'expr') -> pd.DataFrame:
    """
    Crea tabla de incidencia de pobreza por región (PONDERADA)
    
    Returns:
        DataFrame con estadísticas por región
    """
    resultado = df.groupby('region').apply(
        lambda x: pd.Series({
            'total_hogares': x[ponderador].sum(),
            'pct_pobre': (x['pobreza'] >= 2).sum() / len(x) * 100,
            'pct_extremo': (x['pobreza'] == 3).sum() / len(x) * 100,
            'ingreso_promedio': (x['ytotcorh'] * x[ponderador]).sum() / x[ponderador].sum()
        })
    ).reset_index()
    
    return resultado.sort_values('pct_pobre', ascending=False)


def tabla_urbano_rural(df: pd.DataFrame, ponderador: str = 'expr') -> pd.DataFrame:
    """
    Compara pobreza urbana vs rural
    """
    etiquetas = {1: 'Urbano', 2: 'Rural'}
    
    resultado = df.groupby('area').apply(
        lambda x: pd.Series({
            'total_hogares': x[ponderador].sum(),
            'pct_pobre': (x['pobreza'] >= 2).sum() / len(x) * 100,
            'ingresos_prom': (x['ytotcorh'] * x[ponderador]).sum() / x[ponderador].sum()
        })
    ).reset_index()
    
    resultado['area_nombre'] = resultado['area'].map(etiquetas)
    return resultado[['area_nombre', 'total_hogares', 'pct_pobre', 'ingresos_prom']]
```

---

## 6️⃣ PRÓXIMAS ACCIONES

### HOY (23 de octubre)
- [ ] Leer README.md y PROYECTO.md (10 min)
- [ ] Mover datos a 01_Datos/ (1 min)
- [ ] Crear 01_exploratorio.ipynb (30 min)
- [ ] Crear casen_utils.py con funciones básicas (30 min)

### MAÑANA TEMPRANO (24 de octubre)
- [ ] Completar 02_analisis_pobreza.ipynb (2 horas)
- [ ] Generar tablas y figuras (1 hora)
- [ ] Integrar resultados en LaTeX (1 hora)
- [ ] Revisar y ajustar informe (30 min)
- [ ] **ENTREGAR PDF a las 23:59** ✅

---

## 7️⃣ TIPS CLAVE PARA EL ÉXITO

### ✓ Siempre usa `expr` (factor de expansión)
```python
# ❌ MAL: ignorar ponderador
promedio = df['ytotcorh'].mean()

# ✅ BIEN: usar ponderador
promedio = (df['ytotcorh'] * df['expr']).sum() / df['expr'].sum()
```

### ✓ Organiza tu código en funciones reutilizables
```python
# Así es más fácil integrar resultados en LaTeX
def tabla_resultados() -> pd.DataFrame:
    # Tu código aquí
    return tabla_final
```

### ✓ Exporta figuras en formato PDF o PNG
```python
plt.savefig('05_Outputs/figura_pobreza.pdf', dpi=300, bbox_inches='tight')
```

### ✓ Documenta variables en comentarios
```python
# pobreza: 1=No pobre, 2=Pobre, 3=Extremadamente pobre
# region: 1-16 (códigos de región)
# expr: Factor de expansión para representatividad nacional
```

---

## 8️⃣ COMANDOS ÚTILES

### Compilar informe LaTeX
```bash
cd 04_Informe
pdflatex -interaction=nonstopmode informe_principal.tex
```

### Ver estructura del proyecto
```bash
tree -L 3 -I '__pycache__|*.pyc'
```

### Verificar tamaño de archivo de datos
```bash
ls -lh 01_Datos/*.dta
```

---

## 🆘 SI NECESITAS AYUDA

| Problema | Solución |
|----------|----------|
| No puedo cargar el archivo .dta | Verifica ruta en `01_Datos/` |
| Las estadísticas no coinciden con datos publicados | ¿Estás usando `expr`? |
| LaTeX no compila | Verifica rutas de \input{} |
| No veo diferencias significativas entre grupos | Quizás necesitas más variables de control |

---

## 📚 REFERENCIAS RÁPIDAS

- **Thompson (2012):** Diseño muestral multietápico → Cap. 8-9
- **CASEN 2022 Manual:** Descripción de variables → Manual Metodológico
- **Factor de expansión:** Ver sección 5 de PROYECTO.md

---

**¡Ahora sí, a trabajar! 💪**

Recuerda: La estructura está lista, solo necesitas llenar los contenidos.

Cualquier duda → Contacta a Esteban Román
