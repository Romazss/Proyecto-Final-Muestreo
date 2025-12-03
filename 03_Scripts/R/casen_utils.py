"""
casen_utils.py
==============
Funciones reutilizables para análisis de datos CASEN 2022.

Módulo para:
- Carga y validación de datos CASEN
- Cálculos con factores de expansión (expr)
- Tablas ponderadas
- Comparaciones estratificadas

Autor: Grupo 4 - EYP2417 Muestreo
Fecha: Octubre 2025
"""

import pandas as pd
import numpy as np
from typing import Tuple, Dict, List, Optional
import warnings

warnings.filterwarnings('ignore')


# ============================================================================
# 1. FUNCIONES DE CARGA Y VALIDACIÓN
# ============================================================================

def cargar_casen(ruta_archivo: str, verbose: bool = True) -> pd.DataFrame:
    """
    Carga datos CASEN 2022 desde archivo .dta
    
    Args:
        ruta_archivo (str): Ruta completa al archivo .dta
        verbose (bool): Si mostrar mensajes de progreso
    
    Returns:
        pd.DataFrame: Base de datos CASEN 2022
    
    Ejemplo:
        >>> casen = cargar_casen('01_Datos/Base de datos Casen 2022.dta')
        >>> print(casen.shape)
    """
    if verbose:
        print(f"📁 Cargando archivo: {ruta_archivo}")
    
    try:
        df = pd.read_stata(ruta_archivo, convert_categoricals=False)
        
        if verbose:
            print(f"✅ Datos cargados exitosamente")
            print(f"   → {df.shape[0]:,} observaciones")
            print(f"   → {df.shape[1]} variables")
            
        return df
    
    except FileNotFoundError:
        print(f"❌ Error: No se encontró archivo {ruta_archivo}")
        raise
    except Exception as e:
        print(f"❌ Error cargando archivo: {e}")
        raise


def validar_variables_presentes(df: pd.DataFrame, 
                                variables_requeridas: List[str],
                                verbose: bool = True) -> bool:
    """
    Verifica que variables necesarias estén presentes en dataframe
    
    Args:
        df (pd.DataFrame): Base de datos
        variables_requeridas (List[str]): Lista de variables requeridas
        verbose (bool): Mostrar detalles
    
    Returns:
        bool: True si todas las variables existen
    
    Ejemplo:
        >>> requeridas = ['pobreza', 'region', 'expr']
        >>> validar_variables_presentes(casen, requeridas)
    """
    variables_faltantes = [v for v in variables_requeridas if v not in df.columns]
    
    if verbose:
        print(f"🔍 Validación de variables:")
        print(f"   Requeridas: {len(variables_requeridas)}")
        print(f"   Disponibles: {len([v for v in variables_requeridas if v in df.columns])}")
    
    if variables_faltantes:
        print(f"   ❌ Faltantes: {variables_faltantes}")
        return False
    else:
        if verbose:
            print(f"   ✅ Todas presentes")
        return True


def completitud_datos(df: pd.DataFrame, 
                      variables: List[str] = None,
                      verbose: bool = True) -> pd.DataFrame:
    """
    Calcula porcentaje de datos completos (no faltantes) por variable
    
    Args:
        df (pd.DataFrame): Base de datos
        variables (List[str]): Variables a revisar (None = todas)
        verbose (bool): Mostrar resumen
    
    Returns:
        pd.DataFrame: Tabla con completitud
    
    Ejemplo:
        >>> comp = completitud_datos(casen, ['pobreza', 'region', 'expr'])
    """
    if variables is None:
        variables = df.columns.tolist()
    
    resultados = []
    for var in variables:
        if var in df.columns:
            n_validos = df[var].notna().sum()
            n_total = len(df)
            pct_valido = (n_validos / n_total) * 100
            
            resultados.append({
                'variable': var,
                'validos': n_validos,
                'faltantes': n_total - n_validos,
                'pct_completo': pct_valido
            })
    
    resultado_df = pd.DataFrame(resultados)
    
    if verbose:
        print(f"📊 Completitud de datos:")
        print(resultado_df.to_string(index=False))
    
    return resultado_df


# ============================================================================
# 2. FUNCIONES PARA CÁLCULOS PONDERADOS
# ============================================================================

def promedio_ponderado(df: pd.DataFrame, 
                       variable: str, 
                       ponderador: str = 'expr',
                       decimales: int = 0) -> float:
    """
    Calcula promedio ponderado de una variable
    
    Fórmula: mean_w = Σ(x_i * w_i) / Σ(w_i)
    
    Args:
        df (pd.DataFrame): Base de datos
        variable (str): Nombre de variable a promediar
        ponderador (str): Nombre de ponderador (default: 'expr')
        decimales (int): Decimales a redondear
    
    Returns:
        float: Promedio ponderado
    
    Ejemplo:
        >>> ingreso_prom = promedio_ponderado(casen, 'ytotcorh', 'expr')
    """
    validos = df[[variable, ponderador]].dropna()
    
    if len(validos) == 0:
        print(f"⚠️ Advertencia: Sin datos válidos para {variable}")
        return np.nan
    
    promedio = (validos[variable] * validos[ponderador]).sum() / validos[ponderador].sum()
    
    return round(promedio, decimales)


def desv_est_ponderada(df: pd.DataFrame,
                       variable: str,
                       ponderador: str = 'expr',
                       decimales: int = 0) -> float:
    """
    Calcula desviación estándar ponderada de una variable
    
    Args:
        df (pd.DataFrame): Base de datos
        variable (str): Nombre de variable
        ponderador (str): Nombre de ponderador
        decimales (int): Decimales a redondear
    
    Returns:
        float: Desviación estándar ponderada
    """
    validos = df[[variable, ponderador]].dropna()
    
    if len(validos) < 2:
        return np.nan
    
    promedio = promedio_ponderado(validos, variable, ponderador)
    varianza = ((validos[variable] - promedio)**2 * validos[ponderador]).sum() / validos[ponderador].sum()
    desv_est = np.sqrt(varianza)
    
    return round(desv_est, decimales)


def percentil_ponderado(df: pd.DataFrame,
                        variable: str,
                        percentil: int = 50,
                        ponderador: str = 'expr') -> float:
    """
    Calcula percentil ponderado (incluyendo mediana como caso especial)
    
    Args:
        df (pd.DataFrame): Base de datos
        variable (str): Nombre de variable
        percentil (int): Percentil a calcular (1-100)
        ponderador (str): Nombre de ponderador
    
    Returns:
        float: Valor del percentil
    
    Ejemplo:
        >>> mediana = percentil_ponderado(casen, 'ytotcorh', 50)
        >>> q1 = percentil_ponderado(casen, 'ytotcorh', 25)
    """
    validos = df[[variable, ponderador]].dropna().copy()
    validos = validos.sort_values(variable).reset_index(drop=True)
    
    # Normalizar pesos
    pesos_norm = validos[ponderador] / validos[ponderador].sum()
    cumsum_pesos = pesos_norm.cumsum()
    
    # Encontrar índice donde se cumple el percentil
    target = (percentil / 100)
    idx = (cumsum_pesos >= target).idxmax()
    
    return validos[variable].iloc[idx]


# ============================================================================
# 3. FUNCIONES PARA TABLAS ESTRATIFICADAS
# ============================================================================

def tabla_pobreza_region(df: pd.DataFrame,
                         ponderador: str = 'expr',
                         ordenar_por: str = 'pct_pobre') -> pd.DataFrame:
    """
    Crea tabla de incidencia de pobreza por región (PONDERADA)
    
    Incluye:
    - Total de hogares expandidos
    - % de pobres
    - % de extremadamente pobres
    - Ingreso promedio
    
    Args:
        df (pd.DataFrame): Base de datos CASEN
        ponderador (str): Nombre de variable de expansión
        ordenar_por (str): Columna para ordenar resultado
    
    Returns:
        pd.DataFrame: Tabla con estadísticas por región
    
    Ejemplo:
        >>> tabla = tabla_pobreza_region(casen)
        >>> print(tabla)
    """
    # Diccionario de nombres de regiones (opcional)
    nombres_regiones = {
        1: "Tarapacá", 2: "Antofagasta", 3: "Atacama", 4: "Coquimbo",
        5: "Valparaíso", 6: "O'Higgins", 7: "Maule", 8: "Biobío",
        9: "La Araucanía", 10: "Los Lagos", 11: "Aysén", 12: "Magallanes",
        13: "Metropolitana", 14: "Los Ríos", 15: "Arica y Parinacota", 16: "Ñuble"
    }
    
    resultado_lista = []
    
    for region in df['region'].unique():
        if pd.isna(region):
            continue
        
        datos_region = df[df['region'] == region]
        pesos_region = datos_region[ponderador].sum()
        
        # Porcentaje de pobres (pobreza >= 2)
        pct_pobre = ((datos_region['pobreza'] >= 2).sum() / len(datos_region) * 100 
                     if len(datos_region) > 0 else 0)
        
        # Porcentaje de extremadamente pobres (pobreza == 3)
        pct_extremo = ((datos_region['pobreza'] == 3).sum() / len(datos_region) * 100
                       if len(datos_region) > 0 else 0)
        
        # Ingreso promedio ponderado
        ingreso_prom = promedio_ponderado(datos_region, 'ytotcorh', ponderador)
        
        resultado_lista.append({
            'region': int(region),
            'nombre_region': nombres_regiones.get(int(region), f"Región {region}"),
            'total_hogares': int(pesos_region),
            'pct_pobre': round(pct_pobre, 1),
            'pct_extremo': round(pct_extremo, 1),
            'ingreso_prom': int(ingreso_prom)
        })
    
    resultado = pd.DataFrame(resultado_lista)
    resultado = resultado.sort_values(ordenar_por, ascending=False)
    
    return resultado


def tabla_urbano_rural(df: pd.DataFrame,
                       variable_analisis: str = 'pobreza',
                       ponderador: str = 'expr') -> pd.DataFrame:
    """
    Compara características entre zonas urbanas y rurales
    
    Args:
        df (pd.DataFrame): Base de datos CASEN
        variable_analisis (str): Variable a analizar ('pobreza', 'ingresos', etc)
        ponderador (str): Nombre de variable de expansión
    
    Returns:
        pd.DataFrame: Tabla con comparación
    
    Ejemplo:
        >>> tabla_ur = tabla_urbano_rural(casen, 'pobreza')
    """
    etiquetas = {1: 'Urbano', 2: 'Rural'}
    resultado_lista = []
    
    for zona in [1, 2]:
        datos_zona = df[df['area'] == zona]
        
        resultado_lista.append({
            'zona': etiquetas[zona],
            'total_hogares': int(datos_zona[ponderador].sum()),
            'n_observaciones': len(datos_zona),
            'pct_pobre': round((datos_zona['pobreza'] >= 2).mean() * 100, 1),
            'pct_extremo': round((datos_zona['pobreza'] == 3).mean() * 100, 1),
            'ingreso_promedio': int(promedio_ponderado(datos_zona, 'ytotcorh', ponderador))
        })
    
    return pd.DataFrame(resultado_lista)


def tabla_ingresos_sexo(df: pd.DataFrame,
                        variable_ingreso: str = 'yoprinc',
                        ponderador: str = 'expr') -> pd.DataFrame:
    """
    Compara ingresos entre hombres y mujeres jefes de hogar
    
    Args:
        df (pd.DataFrame): Base de datos CASEN
        variable_ingreso (str): Variable de ingreso a analizar
        ponderador (str): Nombre de variable de expansión
    
    Returns:
        pd.DataFrame: Tabla con comparación
    """
    etiquetas = {1: 'Hombre', 2: 'Mujer'}
    resultado_lista = []
    
    for sexo in [1, 2]:
        datos_sexo = df[df['sexo'] == sexo].dropna(subset=[variable_ingreso])
        
        if len(datos_sexo) > 0:
            resultado_lista.append({
                'sexo': etiquetas[sexo],
                'n_observaciones': len(datos_sexo),
                'ingreso_promedio': int(promedio_ponderado(datos_sexo, variable_ingreso, ponderador)),
                'ingreso_mediana': int(percentil_ponderado(datos_sexo, variable_ingreso, 50, ponderador)),
                'desv_estandar': int(desv_est_ponderada(datos_sexo, variable_ingreso, ponderador))
            })
    
    resultado = pd.DataFrame(resultado_lista)
    
    # Calcular brecha salarial
    if len(resultado) == 2:
        brecha_abs = resultado.loc[resultado['sexo'] == 'Hombre', 'ingreso_promedio'].values[0] - \
                     resultado.loc[resultado['sexo'] == 'Mujer', 'ingreso_promedio'].values[0]
        
        ingreso_mujer = resultado.loc[resultado['sexo'] == 'Mujer', 'ingreso_promedio'].values[0]
        brecha_pct = (brecha_abs / ingreso_mujer * 100) if ingreso_mujer > 0 else 0
        
        print(f"\n💰 BRECHA SALARIAL:")
        print(f"   Diferencia absoluta: ${brecha_abs:,.0f}")
        print(f"   Diferencia porcentual: {brecha_pct:.1f}%")
    
    return resultado


def tabla_brecha_educacion(df: pd.DataFrame,
                           variable_ingreso: str = 'yoprinc',
                           ponderador: str = 'expr') -> pd.DataFrame:
    """
    Analiza brecha salarial por nivel educacional del jefe de hogar
    
    Args:
        df (pd.DataFrame): Base de datos CASEN
        variable_ingreso (str): Variable de ingreso
        ponderador (str): Nombre de variable de expansión
    
    Returns:
        pd.DataFrame: Tabla con brecha por educación
    """
    # Crear categorías de educación
    df_temp = df.copy()
    df_temp['cat_educacion'] = pd.cut(df_temp['esc'],
                                      bins=[0, 8, 12, 16, 100],
                                      labels=['Básica', 'Media', 'Técnica', 'Universitaria'])
    
    resultado_lista = []
    
    for cat in ['Básica', 'Media', 'Técnica', 'Universitaria']:
        for sexo_val, sexo_label in [(1, 'Hombre'), (2, 'Mujer')]:
            datos = df_temp[(df_temp['cat_educacion'] == cat) & 
                           (df_temp['sexo'] == sexo_val)].dropna(subset=[variable_ingreso])
            
            if len(datos) > 0:
                resultado_lista.append({
                    'educacion': cat,
                    'sexo': sexo_label,
                    'n_obs': len(datos),
                    'ingreso_promedio': int(promedio_ponderado(datos, variable_ingreso, ponderador))
                })
    
    resultado = pd.DataFrame(resultado_lista)
    
    # Pivotar para calcular brecha
    resultado_pivot = resultado.pivot(index='educacion', columns='sexo', values='ingreso_promedio')
    
    if 'Hombre' in resultado_pivot.columns and 'Mujer' in resultado_pivot.columns:
        resultado_pivot['Brecha_$'] = resultado_pivot['Hombre'] - resultado_pivot['Mujer']
        resultado_pivot['Brecha_%'] = (resultado_pivot['Brecha_$'] / resultado_pivot['Mujer'] * 100)
    
    return resultado_pivot


# ============================================================================
# 4. FUNCIONES PARA RESÚMENES
# ============================================================================

def resumen_exploratorio(df: pd.DataFrame, ponderador: str = 'expr') -> None:
    """
    Imprime resumen exploratorio rápido de la base CASEN
    
    Args:
        df (pd.DataFrame): Base de datos CASEN
        ponderador (str): Variable de expansión
    """
    print("=" * 70)
    print("RESUMEN EXPLORATORIO - CASEN 2022".center(70))
    print("=" * 70)
    
    print(f"\n📊 DIMENSIONES:")
    print(f"   Observaciones: {len(df):,}")
    print(f"   Variables: {len(df.columns)}")
    print(f"   Hogares expandidos: {df[ponderador].sum():,.0f}")
    
    print(f"\n🌍 COBERTURA GEOGRÁFICA:")
    print(f"   Regiones: {df['region'].nunique()}")
    print(f"   Urbano: {(df['area'] == 1).mean() * 100:.1f}%")
    print(f"   Rural: {(df['area'] == 2).mean() * 100:.1f}%")
    
    print(f"\n💰 INGRESOS (CASEN):")
    if 'ytotcorh' in df.columns:
        ingreso_prom = promedio_ponderado(df, 'ytotcorh', ponderador)
        print(f"   Promedio: ${ingreso_prom:,.0f}")
    
    print(f"\n📈 POBREZA:")
    if 'pobreza' in df.columns:
        pct_pobre = (df['pobreza'] >= 2).mean() * 100
        print(f"   % Pobres: {pct_pobre:.1f}%")
    
    print("\n" + "=" * 70)


# ============================================================================
# EJEMPLO DE USO
# ============================================================================

if __name__ == "__main__":
    # Ejemplo de uso de las funciones
    print("Este módulo contiene funciones para análisis de CASEN 2022")
    print("\nImportar como:")
    print("  from casen_utils import *")
    print("\nO cargar directamente:")
    print("  import casen_utils as cu")
    print("  df = cu.cargar_casen('01_Datos/Base de datos Casen 2022 STATA_18 marzo 2024.dta')")
