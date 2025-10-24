"""
__init__.py
===========
Inicializa el módulo scripts para importación.

Permite importar funciones como:
  from scripts import cargar_casen, promedio_ponderado, ...
"""

from .casen_utils import (
    # Carga y validación
    cargar_casen,
    validar_variables_presentes,
    completitud_datos,
    
    # Cálculos ponderados
    promedio_ponderado,
    desv_est_ponderada,
    percentil_ponderado,
    
    # Tablas estratificadas
    tabla_pobreza_region,
    tabla_urbano_rural,
    tabla_ingresos_sexo,
    tabla_brecha_educacion,
    
    # Resúmenes
    resumen_exploratorio
)

__all__ = [
    'cargar_casen',
    'validar_variables_presentes',
    'completitud_datos',
    'promedio_ponderado',
    'desv_est_ponderada',
    'percentil_ponderado',
    'tabla_pobreza_region',
    'tabla_urbano_rural',
    'tabla_ingresos_sexo',
    'tabla_brecha_educacion',
    'resumen_exploratorio'
]

__version__ = '1.0.0'
__author__ = 'Grupo 4 - EYP2417 Muestreo'
