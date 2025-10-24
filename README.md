# Proyecto Final EYP2417 - Muestreo (Grupo 4)
## "Entender la realidad chilena a partir de la encuesta CASEN"

**Entrega:** Viernes 24 de octubre de 2025  
**Formato:** PDF de 3-4 páginas en LaTeX  
**Profesor:** Guillermo Marshall Rivera  
**Institución:** Pontificia Universidad Católica de Chile

---

## 📋 Estructura del Proyecto

```
📦 Proyecto-Final-Muestreo
├── 📂 00_Documentacion/          ← Guías y especificaciones
├── 📂 01_Datos/                  ← Base de datos CASEN 2022
├── 📂 02_Analisis/               ← Notebooks y análisis exploratorios
│   ├── 01_Pobreza/               ← Análisis de distribución de pobreza (Esteban)
│   └── 02_Brecha_Salarial/       ← Análisis brecha salarial de género (Francisca)
├── 📂 03_Scripts/                ← Funciones reutilizables en Python
├── 📂 04_Informe/                ← Documento LaTeX modular
│   ├── 01_Estructura/            ← Archivos .tex por sección
│   └── 02_Figuras/               ← Gráficos y tablas generadas
├── 📂 05_Outputs/                ← Resultados finales
├── README.md                     ← Este archivo
└── PROYECTO.md                   ← Especificaciones técnicas detalladas
```

---

## 👥 Integrantes del Grupo 4

| Nombre | Responsabilidad | Email |
|--------|-----------------|-------|
| **Francisca Sepúlveda** | Brecha salarial de género | - |
| **Esteban Román** | Distribución de pobreza | esteban.roman@uc.cl |
| **Alexander Pinto** | - | - |
| **Julian Vargas** | - | - |

---

## 🎯 Objetivos Específicos del Proyecto

### 1️⃣ **BRECHA SALARIAL DE GÉNERO** (Francisca Sepúlveda)
Analizar diferencias salariales entre jefes de hogar hombres y mujeres

**Variables clave:**
- `sexo`: Sexo del jefe de hogar
- `yoprinc`: Ingreso del trabajo principal
- `esc`: Escolaridad (variable de control)
- `edad`: Edad (variable de control)
- `region`: Región de residencia

**Preguntas de investigación:**
- ¿Cuál es la diferencia salarial promedio entre hombres y mujeres jefas de hogar?
- ¿Persiste la brecha después de controlar por educación y experiencia?
- ¿Varía la brecha entre regiones?

---

### 2️⃣ **DISTRIBUCIÓN DE LA POBREZA EN CHILE** (Esteban Román)
Caracterizar la distribución geográfica y demográfica de la pobreza

**Variables clave:**
- `pobreza`: Situación de pobreza (no pobre/pobre/extremadamente pobre)
- `region`: Región de residencia
- `area`: Zona (urbano/rural)
- `esc`: Escolaridad
- `ytotcorh`: Ingreso total corregido del hogar

**Preguntas de investigación:**
- ¿Cómo se distribuye la pobreza geográficamente en Chile?
- ¿Cuáles son las características demográficas de la población pobre?
- ¿Existen diferencias significativas entre zonas urbanas y rurales?

---

## 📊 Datos Utilizados

**Encuesta CASEN 2022**
- Institución: Ministerio de Desarrollo Social y Familia
- Cobertura: Nacional, regional, comunal
- Tamaño: ~202,000 personas (~70,000 hogares)
- Diseño: Estratificado polietápico (Thompson, Cap. 8-9)
- Archivo: `Base de datos Casen 2022 STATA_18 marzo 2024.dta`

### Características del diseño muestral:
- **UPM (Unidades Primarias):** Secciones censales
- **US (Unidades Secundarias):** Viviendas
- **Ponderadores:** Variable `expr` (factor de expansión)
- **Estratificación:** Región, zona (urbano/rural)

---

## 🔄 Flujo de Trabajo

### Fase 1: Exploración y limpieza de datos
- ✅ Cargar base CASEN 2022
- ⏳ Identificar variables relevantes
- ⏳ Verificar completitud de datos
- ⏳ Crear variables derivadas si es necesario

### Fase 2: Análisis descriptivo ponderado
- ⏳ Estadísticas descriptivas usando factor `expr`
- ⏳ Tablas de contingencia ponderadas
- ⏳ Análisis estratificado por región/zona

### Fase 3: Análisis inferencial
- ⏳ Modelos de regresión (considerando diseño muestral)
- ⏳ Intervalos de confianza ajustados por diseño
- ⏳ Contrastes de hipótesis

### Fase 4: Redacción del informe
- ⏳ Integrar resultados en LaTeX
- ⏳ Generar figuras y tablas
- ⏳ Revisión y ajustes finales

---

## 📚 Bibliografía de Referencia

**Muestreo (Thompson, 2012):**
- Cap. 8: Diseños multietápicos
- Cap. 9: Estimación en muestreo multietápico
- Cap. 2: Fundamentos de muestreo

**Métodos con datos complejos:**
- Lumley, T. (2010). Complex surveys
- Lohr, S. L. (2009). Sampling: Design and analysis
- Särndal, C. E., Swensson, B., & Wretman, J. (2013). Model assisted survey sampling

**CASEN:**
- Ministerio de Desarrollo Social y Familia (2023). Manual metodológico CASEN 2022
- Manual del Investigador CASEN 2022

---

## 🛠️ Herramientas Técnicas

| Herramienta | Función |
|------------|---------|
| **Python 3.x** | Análisis de datos, visualizaciones |
| **pandas** | Manipulación de datos |
| **numpy** | Cálculos numéricos |
| **matplotlib/seaborn** | Visualizaciones |
| **statsmodels/scipy** | Análisis estadístico |
| **LaTeX** | Redacción del informe |
| **Git** | Control de versiones |

---

## 📝 Cómo Usar Este Repositorio

### 1. Clonar el repositorio
```bash
git clone https://github.com/Romazss/Proyecto-Final-Muestreo.git
cd Proyecto-Final-Muestreo
```

### 2. Instalar dependencias
```bash
pip install pandas numpy matplotlib seaborn scipy statsmodels
```

### 3. Ejecutar análisis
```bash
# Análisis de pobreza
jupyter notebook 02_Analisis/01_Pobreza/analisis_pobreza.ipynb

# Análisis brecha salarial
jupyter notebook 02_Analisis/02_Brecha_Salarial/analisis_brecha.ipynb
```

### 4. Compilar informe
```bash
cd 04_Informe
pdflatex -interaction=nonstopmode informe_principal.tex
```

---

## 📈 Próximos Pasos

- [ ] Completar análisis exploratorio en notebooks
- [ ] Generar tablas y figuras principales
- [ ] Redactar metodología en LaTeX
- [ ] Integrar resultados en informe final
- [ ] Revisión final y validación

---

## 📞 Contacto

**Responsable:** Esteban Román  
**Email:** esteban.roman@uc.cl  
**GitHub:** @Romazss  

Para preguntas o cambios en la estructura, contactar al responsable del proyecto.

---

**Última actualización:** 23 de octubre de 2025  
**Estado:** En desarrollo 🔄
