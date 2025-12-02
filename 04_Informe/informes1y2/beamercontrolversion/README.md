# 📊 Estructura Modular Beamer - Control de Versiones

Esta carpeta contiene la estructura modular de la presentación Beamer, diseñada para facilitar el control de versiones y la colaboración.

## 📁 Estructura de Archivos

```
beamercontrolversion/
├── beamer_principal.tex          # Archivo PRINCIPAL para compilar
├── 00_preambulo_beamer.tex       # Configuración, paquetes y colores
├── 01_Secciones/                 # Secciones modulares
│   ├── 01_portada.tex           # Portada de la presentación
│   ├── 02_contenido.tex         # Tabla de contenidos
│   ├── 03_introduccion.tex      # Introducción a CASEN
│   ├── 04_diseno_muestral.tex   # Diseño muestral completo
│   ├── 05_plan_analisis.tex     # Objetivos y plan de análisis
│   ├── 06_metodologia_detallada.tex  # Métodos estadísticos
│   └── 07_cierre.tex            # Slide de cierre y preguntas
└── README.md                     # Este archivo
```

## 🚀 Cómo Compilar

### Compilación Completa

Para compilar toda la presentación:

```powershell
cd beamercontrolversion
pdflatex -interaction=nonstopmode beamer_principal.tex
```

### Doble Compilación (para referencias y TOC)

Para actualizar referencias cruzadas y tabla de contenidos:

```powershell
pdflatex -interaction=nonstopmode beamer_principal.tex
pdflatex -interaction=nonstopmode beamer_principal.tex
```

## ✏️ Cómo Trabajar con la Estructura Modular

### 1. Editar una Sección Específica

Para modificar contenido, edita directamente el archivo de la sección:

- **Introducción**: `01_Secciones/03_introduccion.tex`
- **Diseño Muestral**: `01_Secciones/04_diseno_muestral.tex`
- **Plan de Análisis**: `01_Secciones/05_plan_analisis.tex`
- etc.

### 2. Agregar una Nueva Sección

1. Crea un nuevo archivo en `01_Secciones/`, por ejemplo: `08_nueva_seccion.tex`
2. Agrega el contenido:
   ```latex
   \section{Nueva Sección}
   
   \begin{frame}{Título del Frame}
   Contenido aquí...
   \end{frame}
   ```
3. Incluye la sección en `beamer_principal.tex`:
   ```latex
   \input{01_Secciones/08_nueva_seccion.tex}
   ```

### 3. Modificar Colores o Configuración

Edita `00_preambulo_beamer.tex` para cambiar:
- Colores del tema
- Información de autores
- Configuración de plantillas
- Paquetes adicionales

## 🎨 Paleta de Colores

Los colores institucionales PUC están definidos en el preámbulo:

- `celesteprincipal`: RGB(0,150,200) - Color principal
- `celesteoscuro`: RGB(0,105,148) - Títulos y énfasis
- `celestesuave`: RGB(135,206,235) - Elementos secundarios
- `celesteclaro`: RGB(173,216,230) - Fondos ligeros
- `celestefondo`: RGB(230,245,255) - Fondo de bloques
- `grisoscuro`: RGB(64,64,64) - Texto secundario

## 📋 Ventajas de esta Estructura

✅ **Modularidad**: Cada sección es independiente y fácil de editar
✅ **Control de versiones**: Git puede rastrear cambios por sección
✅ **Colaboración**: Múltiples personas pueden trabajar en secciones diferentes
✅ **Mantenibilidad**: Código organizado y fácil de mantener
✅ **Reutilización**: Las secciones pueden reutilizarse en otras presentaciones
✅ **Testing**: Puedes comentar secciones para compilar más rápido durante desarrollo

## 🔧 Solución de Problemas

### Error: "File not found"

- Asegúrate de estar en el directorio `beamercontrolversion/`
- Verifica que las rutas relativas estén correctas
- El logo debe estar en `../03_Logos/logo_kovan.jpg`

### Cambios no se reflejan

- Compila dos veces para actualizar referencias
- Borra archivos `.aux`, `.nav`, `.toc`, `.out` y vuelve a compilar

### Falta un paquete

```powershell
tlmgr install <nombre-del-paquete>
```

## 📝 Notas Importantes

- **NO** edites `beamer_principal.tex` para contenido (solo para estructura)
- Mantén la coherencia de colores usando los definidos en el preámbulo
- Usa `\textcolor{celesteoscuro}{}` para énfasis importantes
- Los bloques usan automáticamente los colores del tema

## 🎯 Próximos Pasos

Para mejorar secuencialmente las secciones:

1. Identifica la sección a mejorar
2. Abre el archivo correspondiente en `01_Secciones/`
3. Realiza los cambios
4. Compila `beamer_principal.tex` para ver los resultados
5. Commit los cambios con git

## 📧 Contacto

**Grupo 4 - EYP2417 Muestreo**
- Alexander Pinto
- Esteban Román
- Julián Vargas
- Francisca Sepúlveda

Pontificia Universidad Católica de Chile
