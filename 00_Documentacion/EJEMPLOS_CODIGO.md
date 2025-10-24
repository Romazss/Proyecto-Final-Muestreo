# 💻 EJEMPLOS DE CÓDIGO - COPY-PASTE LISTOS

Aquí hay fragmentos de código que puedes copiar directamente en tus notebooks.

---

## 📊 1. CONFIGURACIÓN INICIAL DEL NOTEBOOK

```python
# =============================================================================
# CELDA 1: Importaciones y configuración
# =============================================================================

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import sys
import warnings

warnings.filterwarnings('ignore')

# Configurar visualización
plt.style.use('default')
sns.set_palette("husl")
plt.rcParams['figure.figsize'] = (12, 6)

# Importar módulo de scripts
sys.path.insert(0, '../../../03_Scripts')
from casen_utils import *

print("✅ Librerías cargadas correctamente")
print("✅ Módulo casen_utils importado")
```

---

## 📁 2. CARGAR DATOS

```python
# =============================================================================
# CELDA 2: Carga de datos CASEN 2022
# =============================================================================

# Ruta del archivo (ajusta según tu ubicación)
ruta_datos = '../../../01_Datos/Base de datos Casen 2022 STATA_18 marzo 2024.dta'

# Cargar usando función modular
casen = cargar_casen(ruta_datos, verbose=True)

# Resumen exploratorio rápido
print("\n" + "="*70)
print("INFORMACIÓN GENERAL DEL DATASET".center(70))
print("="*70)
print(f"Observaciones: {len(casen):,}")
print(f"Variables: {casen.columns.size}")
print(f"Primeras filas:\n{casen.head()}")
```

---

## ✔️ 3. VALIDAR VARIABLES

```python
# =============================================================================
# CELDA 3: Validar disponibilidad de variables
# =============================================================================

# Variables necesarias para análisis de pobreza
variables_requeridas = [
    'pobreza',      # Condición de pobreza
    'region',       # Región
    'area',         # Urbano/Rural
    'esc',          # Escolaridad
    'ytotcorh',     # Ingreso total hogar
    'expr',         # Factor de expansión
    'edad',         # Edad del jefe
    'tot_per_h',    # Tamaño hogar
    'tipohogar',    # Tipo de hogar
    'ten_viv'       # Tenencia vivienda
]

# Validar
validar_variables_presentes(casen, variables_requeridas, verbose=True)

# Ver completitud
print("\n" + "="*70)
completitud = completitud_datos(casen, variables_requeridas, verbose=False)
print(completitud.to_string(index=False))
```

---

## 📊 4. ANÁLISIS EXPLORATORIO

```python
# =============================================================================
# CELDA 4: Exploración inicial de pobreza
# =============================================================================

# Resumen general
resumen_exploratorio(casen)

# Distribución de pobreza
print("\n" + "="*70)
print("DISTRIBUCIÓN DE POBREZA - FRECUENCIAS".center(70))
print("="*70)

etiquetas_pobreza = {1: "No pobre", 2: "Pobre", 3: "Extremadamente pobre"}
dist_pobreza = casen['pobreza'].value_counts().sort_index()

for categoria, cantidad in dist_pobreza.items():
    pct = (cantidad / len(casen)) * 100
    etiqueta = etiquetas_pobreza.get(categoria, f"Código {categoria}")
    print(f"  {etiqueta:25s}: {cantidad:7,} ({pct:5.1f}%)")

# Análisis por región
print("\n" + "="*70)
print("DISTRIBUCIÓN DE REGIONES".center(70))
print("="*70)

region_dist = casen['region'].value_counts().sort_index().head(10)
for region, cantidad in region_dist.items():
    pct = (cantidad / len(casen)) * 100
    print(f"  Región {int(region):2d}: {cantidad:7,} observaciones ({pct:5.1f}%)")

# Estadísticas de ingresos
print("\n" + "="*70)
print("ESTADÍSTICAS DE INGRESOS - SIN PONDERAR".center(70))
print("="*70)

ingresos_validos = casen['ytotcorh'].dropna()
print(f"  N válidos:      {len(ingresos_validos):,}")
print(f"  Promedio:       ${ingresos_validos.mean():,.0f}")
print(f"  Mediana:        ${ingresos_validos.median():,.0f}")
print(f"  Mín:            ${ingresos_validos.min():,.0f}")
print(f"  Máx:            ${ingresos_validos.max():,.0f}")
print(f"  Desv. Est.:     ${ingresos_validos.std():,.0f}")
```

---

## 🎯 5. ANÁLISIS PONDERADO - TABLA POBREZA POR REGIÓN

```python
# =============================================================================
# CELDA 5: TABLA PRINCIPAL - Pobreza por región (PONDERADA)
# =============================================================================

print("\n" + "="*70)
print("INCIDENCIA DE POBREZA POR REGIÓN - CASEN 2022".center(70))
print("="*70)

# Generar tabla ponderada
tabla_pobreza = tabla_pobreza_region(casen, ordenar_por='pct_pobre')

# Mostrar tabla
print(f"\n{tabla_pobreza.to_string(index=False)}")

# Guardar tabla para usar en LaTeX
tabla_pobreza.to_csv('../../../05_Outputs/tabla_pobreza_region.csv', index=False)
print(f"\n✅ Tabla guardada en: 05_Outputs/tabla_pobreza_region.csv")

# Estadísticas resumen
print("\n" + "="*70)
print("RESUMEN NACIONAL".center(70))
print("="*70)

pct_pobre_nacional = (casen['pobreza'] >= 2).mean() * 100
pct_extremo_nacional = (casen['pobreza'] == 3).mean() * 100

print(f"  % Pobres nacional:              {pct_pobre_nacional:.1f}%")
print(f"  % Extremadamente pobres:        {pct_extremo_nacional:.1f}%")
print(f"  Región con mayor incidencia:    {tabla_pobreza.iloc[0]['nombre_region']} ({tabla_pobreza.iloc[0]['pct_pobre']:.1f}%)")
print(f"  Región con menor incidencia:    {tabla_pobreza.iloc[-1]['nombre_region']} ({tabla_pobreza.iloc[-1]['pct_pobre']:.1f}%)")
print(f"  Diferencia regional:            {tabla_pobreza.iloc[0]['pct_pobre'] - tabla_pobreza.iloc[-1]['pct_pobre']:.1f} pp")
```

---

## 🌆 6. ANÁLISIS URBANO-RURAL

```python
# =============================================================================
# CELDA 6: Comparación Urbano-Rural (PONDERADA)
# =============================================================================

print("\n" + "="*70)
print("COMPARACIÓN URBANO-RURAL".center(70))
print("="*70)

tabla_ur = tabla_urbano_rural(casen)
print(f"\n{tabla_ur.to_string(index=False)}")

# Guardar
tabla_ur.to_csv('../../../05_Outputs/tabla_urbano_rural.csv', index=False)

# Análisis por región urbano-rural
print("\n" + "="*70)
print("TOP 5 REGIONES - COMPARACIÓN URBANO-RURAL".center(70))
print("="*70)

for region in [13, 5, 8, 6, 7]:  # RM, Valparaíso, Biobío, O'Higgins, Maule
    datos_region = casen[casen['region'] == region]
    
    urbano = datos_region[datos_region['area'] == 1]
    rural = datos_region[datos_region['area'] == 2]
    
    pct_pobre_urbano = (urbano['pobreza'] >= 2).mean() * 100 if len(urbano) > 0 else 0
    pct_pobre_rural = (rural['pobreza'] >= 2).mean() * 100 if len(rural) > 0 else 0
    
    print(f"  Región {int(region):2d}: Urbano {pct_pobre_urbano:5.1f}% vs Rural {pct_pobre_rural:5.1f}%")
```

---

## 📈 7. GRÁFICO: POBREZA POR REGIÓN

```python
# =============================================================================
# CELDA 7: Gráfico - Incidencia de pobreza por región
# =============================================================================

fig, ax = plt.subplots(figsize=(14, 8))

# Preparar datos para gráfico (top 12 regiones)
top_regiones = tabla_pobreza.head(12)

# Crear gráfico
colores = ['#d62728' if x > 15 else '#ff7f0e' if x > 10 else '#2ca02c' 
           for x in top_regiones['pct_pobre']]

barras = ax.barh(range(len(top_regiones)), top_regiones['pct_pobre'], color=colores)

# Configurar etiquetas
ax.set_yticks(range(len(top_regiones)))
ax.set_yticklabels(top_regiones['nombre_region'])
ax.set_xlabel('% de Población Pobre', fontsize=12, fontweight='bold')
ax.set_title('Incidencia de Pobreza por Región - CASEN 2022', 
             fontsize=14, fontweight='bold', pad=20)

# Agregar valores en las barras
for i, (idx, row) in enumerate(top_regiones.iterrows()):
    ax.text(row['pct_pobre'] + 0.3, i, f"{row['pct_pobre']:.1f}%", 
            va='center', fontsize=10, fontweight='bold')

# Añadir línea de promedio nacional
prom_nacional = (casen['pobreza'] >= 2).mean() * 100
ax.axvline(prom_nacional, color='blue', linestyle='--', linewidth=2, label=f'Nacional: {prom_nacional:.1f}%')

ax.legend()
ax.grid(axis='x', alpha=0.3)
plt.tight_layout()

# Guardar
plt.savefig('../../../05_Outputs/01_pobreza_por_region.pdf', dpi=300, bbox_inches='tight')
plt.savefig('../../../05_Outputs/01_pobreza_por_region.png', dpi=150, bbox_inches='tight')
print("✅ Gráfico guardado: 05_Outputs/01_pobreza_por_region.pdf")
plt.show()
```

---

## 🏠 8. GRÁFICO: URBANO vs RURAL

```python
# =============================================================================
# CELDA 8: Gráfico - Comparación Urbano-Rural
# =============================================================================

# Análisis por región
regiones_analisis = [13, 5, 8, 6, 7, 4, 12, 1]  # Top 8 por población
datos_ur_region = []

for region in regiones_analisis:
    datos_region = casen[casen['region'] == region]
    if len(datos_region) > 0:
        urbano = datos_region[datos_region['area'] == 1]
        rural = datos_region[datos_region['area'] == 2]
        
        pct_u = (urbano['pobreza'] >= 2).mean() * 100 if len(urbano) > 0 else 0
        pct_r = (rural['pobreza'] >= 2).mean() * 100 if len(rural) > 0 else 0
        
        datos_ur_region.append({
            'region': int(region),
            'urbano': pct_u,
            'rural': pct_r,
            'diferencia': pct_r - pct_u
        })

df_ur_region = pd.DataFrame(datos_ur_region)

# Gráfico
fig, ax = plt.subplots(figsize=(12, 6))

x = np.arange(len(df_ur_region))
width = 0.35

barras1 = ax.bar(x - width/2, df_ur_region['urbano'], width, label='Urbano', color='#2ca02c')
barras2 = ax.bar(x + width/2, df_ur_region['rural'], width, label='Rural', color='#d62728')

ax.set_xlabel('Región', fontsize=12, fontweight='bold')
ax.set_ylabel('% de Población Pobre', fontsize=12, fontweight='bold')
ax.set_title('Incidencia de Pobreza: Urbano vs Rural', fontsize=14, fontweight='bold')
ax.set_xticks(x)
ax.set_xticklabels([f"R{r}" for r in df_ur_region['region']])
ax.legend()
ax.grid(axis='y', alpha=0.3)

plt.tight_layout()
plt.savefig('../../../05_Outputs/02_urbano_rural.pdf', dpi=300, bbox_inches='tight')
print("✅ Gráfico guardado: 05_Outputs/02_urbano_rural.pdf")
plt.show()
```

---

## 📋 9. ANÁLISIS DE FACTORES ASOCIADOS

```python
# =============================================================================
# CELDA 9: Factores asociados a la pobreza
# =============================================================================

print("\n" + "="*70)
print("ANÁLISIS DE FACTORES ASOCIADOS A LA POBREZA".center(70))
print("="*70)

# Crear categorías de educación
casen['cat_educacion'] = pd.cut(casen['esc'],
                                bins=[0, 8, 12, 16, 100],
                                labels=['Básica', 'Media', 'Técnica', 'Universitaria'])

# Pobreza por educación
print("\n1. POBREZA POR NIVEL EDUCACIONAL DEL JEFE:")
print("-" * 50)

for cat in ['Básica', 'Media', 'Técnica', 'Universitaria']:
    datos_cat = casen[casen['cat_educacion'] == cat]
    pct_pobre = (datos_cat['pobreza'] >= 2).mean() * 100
    n_obs = len(datos_cat)
    print(f"  {cat:15s}: {pct_pobre:5.1f}% pobres (n={n_obs:,})")

# Pobreza por tamaño del hogar
print("\n2. POBREZA POR TAMAÑO DEL HOGAR:")
print("-" * 50)

casen['tam_hogar'] = pd.cut(casen['tot_per_h'], 
                             bins=[0, 2, 4, 6, 20],
                             labels=['1-2 personas', '3-4 personas', '5-6 personas', '7+ personas'])

for tam in ['1-2 personas', '3-4 personas', '5-6 personas', '7+ personas']:
    datos_tam = casen[casen['tam_hogar'] == tam]
    pct_pobre = (datos_tam['pobreza'] >= 2).mean() * 100
    n_obs = len(datos_tam)
    print(f"  {tam:15s}: {pct_pobre:5.1f}% pobres (n={n_obs:,})")

# Pobreza por tenencia de vivienda
print("\n3. POBREZA POR TENENCIA DE VIVIENDA:")
print("-" * 50)

etiquetas_vivienda = {
    1: "Propia pagada",
    2: "Propia pagándose",
    3: "Arrendada",
    4: "Cedida"
}

for cod, etiqueta in etiquetas_vivienda.items():
    datos_viv = casen[casen['ten_viv'] == cod]
    if len(datos_viv) > 0:
        pct_pobre = (datos_viv['pobreza'] >= 2).mean() * 100
        n_obs = len(datos_viv)
        print(f"  {etiqueta:18s}: {pct_pobre:5.1f}% pobres (n={n_obs:,})")
```

---

## 💾 10. EXPORTAR RESULTADOS

```python
# =============================================================================
# CELDA 10: Guardar resultados para LaTeX
# =============================================================================

import os

# Crear diccionario con resultados principales
resultados = {
    'pct_pobre_nacional': round((casen['pobreza'] >= 2).mean() * 100, 1),
    'pct_extremo_nacional': round((casen['pobreza'] == 3).mean() * 100, 1),
    'region_mayor_incidencia': tabla_pobreza.iloc[0]['nombre_region'],
    'pct_mayor_incidencia': round(tabla_pobreza.iloc[0]['pct_pobre'], 1),
    'region_menor_incidencia': tabla_pobreza.iloc[-1]['nombre_region'],
    'pct_menor_incidencia': round(tabla_pobreza.iloc[-1]['pct_pobre'], 1)
}

print("\n" + "="*70)
print("RESULTADOS PRINCIPALES PARA INFORME".center(70))
print("="*70)
for clave, valor in resultados.items():
    print(f"  {clave:30s}: {valor}")

# Guardar en JSON para fácil acceso
import json
with open('../../../05_Outputs/resultados_pobreza.json', 'w', encoding='utf-8') as f:
    json.dump(resultados, f, ensure_ascii=False, indent=2)

print(f"\n✅ Resultados guardados en: 05_Outputs/resultados_pobreza.json")

# Verificar que todos los archivos están en 05_Outputs/
outputs_dir = '../../../05_Outputs'
print(f"\n📁 Archivos generados:")
if os.path.exists(outputs_dir):
    for archivo in os.listdir(outputs_dir):
        ruta = os.path.join(outputs_dir, archivo)
        tamaño = os.path.getsize(ruta) / 1024  # KB
        print(f"   ✅ {archivo} ({tamaño:.1f} KB)")
```

---

## 🎨 11. INSERTAR TABLA EN LaTeX

Una vez tengas los resultados, inserta esta tabla en `04_Informe/01_Estructura/resultados_pobreza.tex`:

```latex
\subsection{Incidencia de Pobreza por Región}

En la Tabla \ref{tab:pobreza_region} se presenta la incidencia de pobreza por región, 
ordenada de mayor a menor porcentaje de pobres.

\begin{table}[H]
\centering
\caption{Incidencia de pobreza por región - CASEN 2022}
\label{tab:pobreza_region}
\small
\begin{tabular}{lrrrr}
\toprule
\rowcolor{celestefondo}
\textbf{Región} & \textbf{Hogares} & \textbf{\% Pobres} & \textbf{\% Extremo} & \textbf{Ing. Prom.} \\
\midrule
% Aquí van las filas de la tabla (datos de tabla_pobreza_region.csv)
\bottomrule
\end{tabular}
\end{table}

Los resultados muestran que...
```

---

## 🚀 INSTRUCCIONES PARA USAR

1. **Copia todo el código** de la celda que necesites
2. **Pega en tu notebook** Jupyter
3. **Ajusta las rutas** si es necesario
4. **Ejecuta** (Shift + Enter)
5. **Itera** según tus necesidades

---

**¡Ahora tienes todo listo para comenzar tu análisis!** 💪
