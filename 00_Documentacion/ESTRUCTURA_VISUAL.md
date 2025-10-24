# 📊 Estructura del Proyecto Visualizada

```
🎯 PROYECTO FINAL EYP2417 - MUESTREO
│
├─ 🎓 OBJETIVO GENERAL
│  └─ "Entender la realidad chilena a partir de la encuesta CASEN"
│
├─ 📊 ENTIDAD DE DATOS
│  └─ CASEN 2022 (202K personas, 70K hogares, diseño muestral complejo)
│
├─ 🔬 DOS EJES DE ANÁLISIS
│  │
│  ├─ 📍 EJE 1: DISTRIBUCIÓN DE POBREZA (Esteban Román)
│  │  ├─ Pregunta: ¿Cómo se distribuye la pobreza en Chile?
│  │  ├─ Variables clave: pobreza, region, area, esc, ytotcorh
│  │  ├─ Análisis:
│  │  │  ├─ Incidencia nacional (%)
│  │  │  ├─ Tabla: Pobreza por región
│  │  │  ├─ Comparación: Urbano vs Rural
│  │  │  └─ Factores asociados
│  │  └─ Outputs:
│  │     ├─ Tablas en 05_Outputs/
│  │     ├─ Figuras: pobreza_por_region.pdf, urbano_rural.pdf
│  │     └─ Sección en LaTeX: 04_Informe/01_Estructura/resultados_pobreza.tex
│  │
│  └─ 💼 EJE 2: BRECHA SALARIAL DE GÉNERO (Francisca Sepúlveda)
│     ├─ Pregunta: ¿Cuál es la diferencia salarial hombre-mujer?
│     ├─ Variables clave: sexo, yoprinc, esc, edad, region
│     ├─ Análisis:
│     │  ├─ Ingresos promedio por sexo
│     │  ├─ Brecha: Diferencia absoluta y %
│     │  ├─ Tabla: Brecha por educación
│     │  └─ Modelo de regresión
│     └─ Outputs:
│        ├─ Tablas en 05_Outputs/
│        ├─ Figuras: brecha_educacion.pdf, brecha_region.pdf
│        └─ Sección en LaTeX: 04_Informe/01_Estructura/resultados_brecha.tex
│
├─ 🛠️ FLUJO DE TRABAJO
│  │
│  ├─ PHASE 1: EXPLORACIÓN [Notebook: 01_exploratorio.ipynb]
│  │  ├─ Cargar datos CASEN
│  │  ├─ Verificar variables clave
│  │  ├─ Explorar datos faltantes
│  │  └─ Crear gráficos exploratorios
│  │
│  ├─ PHASE 2: ANÁLISIS FORMAL [Notebook: 02_analisis_[eje].ipynb]
│  │  ├─ Estadística descriptiva ponderada
│  │  ├─ Tablas estratificadas (región, zona, educación)
│  │  ├─ Gráficos ilustrativos
│  │  └─ Modelos (si aplica)
│  │
│  ├─ PHASE 3: FUNCIONES REUTILIZABLES [Scripts: 03_Scripts/]
│  │  ├─ casen_utils.py: Funciones para cálculos
│  │  │  ├─ cargar_casen()
│  │  │  ├─ promedio_ponderado()
│  │  │  ├─ tabla_pobreza_region()
│  │  │  ├─ tabla_urbano_rural()
│  │  │  └─ tabla_ingresos_sexo()
│  │  └─ __init__.py: Importación de módulo
│  │
│  ├─ PHASE 4: REPORTERÍA [LaTeX: 04_Informe/]
│  │  ├─ informe_principal.tex [Archivo maestro]
│  │  ├─ 00_preambulo.tex [Paquetes y colores]
│  │  └─ 01_Estructura/
│  │     ├─ portada.tex
│  │     ├─ introduccion.tex
│  │     ├─ metodologia.tex
│  │     ├─ resultados_pobreza.tex ← TU SECCIÓN
│  │     ├─ resultados_brecha.tex
│  │     ├─ conclusiones.tex
│  │     └─ referencias.tex
│  │
│  └─ PHASE 5: ENTREGA
│     └─ PDF final (3-4 páginas)
│
├─ 📁 ESTRUCTURA DE CARPETAS
│  │
│  ├─ 00_Documentacion/
│  │  ├─ README.md ...................... Descripción general
│  │  ├─ PROYECTO.md .................... Especificaciones técnicas DETALLADAS
│  │  ├─ INICIO_RAPIDO.md ............... Guía para comenzar (5 min)
│  │  └─ CHECKLIST.md ................... Tareas y progreso
│  │
│  ├─ 01_Datos/
│  │  └─ Base de datos Casen 2022.dta .. ← AQUÍ VAN LOS DATOS
│  │
│  ├─ 02_Analisis/
│  │  ├─ 01_Pobreza/ .................... Tu análisis
│  │  │  ├─ 01_exploratorio.ipynb ....... Exploración inicial
│  │  │  ├─ 02_analisis_pobreza.ipynb ... Análisis formal
│  │  │  └─ figuras/ .................... Gráficos generados
│  │  │
│  │  └─ 02_Brecha_Salarial/ ............ Análisis de Francisca
│  │     ├─ 01_exploratorio.ipynb
│  │     ├─ 02_analisis_brecha.ipynb
│  │     └─ figuras/
│  │
│  ├─ 03_Scripts/
│  │  ├─ __init__.py .................... Módulo importable
│  │  └─ casen_utils.py ................. Funciones reutilizables
│  │
│  ├─ 04_Informe/
│  │  ├─ 00_preambulo.tex ............... Configuración común
│  │  ├─ informe_principal.tex .......... ARCHIVO A COMPILAR
│  │  ├─ 01_Estructura/ ................ Secciones modulares
│  │  │  ├─ portada.tex
│  │  │  ├─ introduccion.tex
│  │  │  ├─ metodologia.tex
│  │  │  ├─ resultados_pobreza.tex ..... TU SECCIÓN (COMPLETA)
│  │  │  ├─ resultados_brecha.tex ...... Sección de Francisca
│  │  │  ├─ conclusiones.tex
│  │  │  └─ referencias.tex
│  │  └─ 02_Figuras/ ................... Gráficos para incluir
│  │
│  └─ 05_Outputs/
│     ├─ tabla_pobreza_region.xlsx
│     ├─ tabla_urbano_rural.xlsx
│     ├─ tabla_ingresos_sexo.xlsx
│     ├─ pobreza_por_region.pdf
│     ├─ urbano_rural.pdf
│     ├─ brecha_educacion.pdf
│     └─ [otros resultados]
│
└─ 📅 CRONOGRAMA (23-24 OCT)
   │
   ├─ 23 OCT 8am:  Leer documentación (10 min)
   ├─ 23 OCT 9am:  Exploración datos (3 horas)
   ├─ 23 OCT 1pm:  Scripts Python (2 horas)
   ├─ 23 OCT 3pm:  Análisis formal (2 horas)
   ├─ 23 OCT 5pm:  Generar figuras (1 hora)
   ├─ 23 OCT 6pm:  Redacción LaTeX (2 horas)
   ├─ 24 OCT 8am:  Integración de resultados (3 horas)
   ├─ 24 OCT 11am: Revisión y ajustes (2 horas)
   └─ 24 OCT 8pm:  ENTREGA FINAL ✅
```

---

## 🎯 PUNTOS CLAVE PARA TI (Esteban Román)

### Tus Responsabilidades:
1. **Análisis de Pobreza**: Completa notebooks en `02_Analisis/01_Pobreza/`
2. **Tablas y Figuras**: Genera resultados en `05_Outputs/`
3. **LaTeX**: Completa sección `04_Informe/01_Estructura/resultados_pobreza.tex`

### Lo que YA ESTÁ LISTO:
- ✅ Estructura de carpetas
- ✅ Documentación de especificaciones
- ✅ Scripts Python reutilizables (`casen_utils.py`)
- ✅ Estructura LaTeX modular
- ✅ Checklist de tareas

### Lo que DEBES HACER:
- [ ] Cargar datos en `01_Datos/`
- [ ] Crear notebooks en `02_Analisis/01_Pobreza/`
- [ ] Usar funciones de `03_Scripts/casen_utils.py`
- [ ] Generar tablas y figuras en `05_Outputs/`
- [ ] Completar sección LaTeX con tus resultados

---

## 💡 CÓMO USAR LOS SCRIPTS

```python
# En tu notebook:
import sys
sys.path.insert(0, '../../../03_Scripts')

from casen_utils import (
    cargar_casen,
    promedio_ponderado,
    tabla_pobreza_region,
    tabla_urbano_rural,
    resumen_exploratorio
)

# Cargar datos
casen = cargar_casen('01_Datos/Base de datos Casen 2022 STATA_18 marzo 2024.dta')

# Exploración rápida
resumen_exploratorio(casen)

# Generar tabla de pobreza por región (PONDERADA)
tabla_pobreza = tabla_pobreza_region(casen)
print(tabla_pobreza)

# Comparación urbano-rural
tabla_ur = tabla_urbano_rural(casen)
print(tabla_ur)
```

---

## 🚀 PRÓXIMA ACCIÓN

1. Lee `00_Documentacion/INICIO_RAPIDO.md` (5 min)
2. Lee `00_Documentacion/CHECKLIST.md` (5 min)
3. Coloca archivo .dta en `01_Datos/` (1 min)
4. Crea `02_Analisis/01_Pobreza/01_exploratorio.ipynb` (30 min)
5. ¡Comienza el análisis! 🎯

---

**Recuerda:** La estructura está lista, solo necesitas llenarla con tu análisis.  
**Dudas?** Revisa la documentación o contacta a Esteban.

¡Adelante! 💪
