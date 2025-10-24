# 🚀 Cómo Usar Este Proyecto (GitHub)

**Proyecto Final EYP2417 - Muestreo | Grupo 4**

Este documento explica cómo clonar, configurar y usar este proyecto desde GitHub.

---

## 📥 PASO 1: Clonar el Repositorio

```bash
# Clonar el proyecto
git clone https://github.com/Romazss/Proyecto-Final-Muestreo.git
cd Proyecto-Final-Muestreo

# Listar estructura
ls -la
```

---

## 📊 PASO 2: Descargar Datos CASEN 2022

**⚠️ IMPORTANTE:** La base de datos CASEN 2022 no está incluida en el repositorio (es muy pesada).

### Opción A: Descargar desde sitio oficial

```bash
# Ir a carpeta de datos
cd 01_Datos/

# Descargar desde:
# https://www.ministeriodesarrollosocial.gob.cl/casen/

# Guardar archivo como:
# "Base de datos Casen 2022 STATA_18 marzo 2024.dta"

# Verificar que está en 01_Datos/
ls -lh
```

### Opción B: Usar link si fue compartido

Si alguien compartió el archivo (ej. Dropbox, Drive):
```bash
# Descargar y guardar en 01_Datos/
wget [URL_DEL_ARCHIVO] -O "Base de datos Casen 2022 STATA_18 marzo 2024.dta"
```

---

## 🐍 PASO 3: Configurar Python

### 3.1 Crear entorno virtual (RECOMENDADO)

```bash
# En macOS/Linux
python3 -m venv venv
source venv/bin/activate

# En Windows
python -m venv venv
venv\Scripts\activate
```

### 3.2 Instalar dependencias

```bash
# Instalar paquetes necesarios
pip install pandas numpy matplotlib seaborn scipy statsmodels jupyter openpyxl

# O usar archivo de requisitos si existe
pip install -r requirements.txt
```

### 3.3 Verificar instalación

```bash
# Abrir Python e importar módulos
python -c "import pandas; print('✅ pandas OK')"
python -c "import jupyter; print('✅ jupyter OK')"
```

---

## 📖 PASO 4: Leer Documentación

Comienza leyendo en este orden:

```bash
# 1. Descripción general (5 min)
cat README.md

# 2. Especificaciones técnicas (15 min)
cat PROYECTO.md | less

# 3. Guía rápida (5 min)
cat 00_Documentacion/INICIO_RAPIDO.md

# 4. Índice de documentación
cat 00_Documentacion/INDICE.md
```

---

## 💻 PASO 5: Comenzar Análisis

### Opción A: Usar Jupyter Notebook

```bash
# Activar entorno virtual (si no está activo)
source venv/bin/activate

# Iniciar Jupyter
jupyter notebook

# Navegar a:
# 02_Analisis/01_Pobreza/01_exploratorio.ipynb
```

### Opción B: Usar scripts Python

```bash
# Ejecutar script de ejemplo
cd 02_Analisis/01_Pobreza/
python tu_script.py
```

---

## 🔍 VERIFICAR ESTRUCTURA

```bash
# Ver estructura completa
tree -L 3 -I '__pycache__|*.pyc'

# O si no tienes tree:
find . -type d -not -path '*/\.*' | head -20
```

Debería ver:
```
Proyecto-Final-Muestreo/
├── 00_Documentacion/       ← Guías y especificaciones
├── 01_Datos/               ← Aquí coloca CASEN 2022
├── 02_Analisis/            ← Tus notebooks
├── 03_Scripts/             ← Código reutilizable
├── 04_Informe/             ← LaTeX del informe
└── 05_Outputs/             ← Resultados generados
```

---

## 📝 HACER CAMBIOS Y COMPARTIR

### Si realizas cambios:

```bash
# 1. Ver cambios
git status

# 2. Agregar cambios
git add .

# 3. Hacer commit con mensaje descriptivo
git commit -m "Agrego análisis exploratorio de pobreza"

# 4. Subir cambios
git push origin main
```

### Qué se subirá (según .gitignore):

✅ **Se subirá:**
- Código Python (.py)
- Documentación (.md)
- Archivos LaTeX (.tex)
- Configuraciones

❌ **NO se subirá:**
- Datos CASEN (.dta) - muy pesado
- Archivos compilados
- Checkpoints de Jupyter
- Archivos del sistema

---

## 🛠️ RESOLVER PROBLEMAS COMUNES

### Problema: "No encuentro archivo CASEN"

```bash
# Verificar que el archivo está en 01_Datos/
ls -lh 01_Datos/

# Si no está, descargar desde:
# https://www.ministeriodesarrollosocial.gob.cl/casen/
```

### Problema: "Error al importar pandas"

```bash
# Asegurar que el entorno virtual está activado
which python  # Debe mostrar ruta con "venv"

# Reinstalar dependencias
pip install --upgrade pandas numpy matplotlib
```

### Problema: "Jupyter no inicia"

```bash
# Verificar instalación
pip install --upgrade jupyter

# O instalar desde cero
pip install jupyter
```

### Problema: ".dta file is corrupted"

```bash
# Verificar integridad del archivo
file 01_Datos/*.dta

# Si está dañado, descargar nuevamente
```

---

## 📚 DOCUMENTACIÓN DISPONIBLE

| Archivo | Propósito |
|---------|----------|
| README.md | Descripción general del proyecto |
| PROYECTO.md | Especificaciones técnicas completas |
| 00_Documentacion/INICIO_RAPIDO.md | Guía para comenzar (5 min) |
| 00_Documentacion/INDICE.md | Índice completo de documentación |
| 00_Documentacion/CHECKLIST.md | Lista de tareas por fase |
| 00_Documentacion/EJEMPLOS_CODIGO.md | 11 ejemplos copy-paste |
| 03_Scripts/casen_utils.py | Funciones Python reutilizables |

---

## 🔑 COMANDOS ÚTILES

```bash
# Ver cambios sin hacer commit
git diff

# Ver historial de commits
git log --oneline

# Deshacer cambios en un archivo
git checkout -- archivo.py

# Ver estado del repositorio
git status

# Actualizar repositorio local (obtener cambios de otros)
git pull origin main

# Ver configuración de git
git config --list
```

---

## 💾 TAMAÑO DEL REPOSITORIO

Sin datos CASEN:
- **Código + Documentación:** ~5 MB
- **Fácil de clonar y mantener**

Con datos CASEN (.dta):
- **Total:** ~500 MB+
- **Difícil de gestionar en GitHub**

**Por eso los datos NO están versionados** ✅

---

## 🔐 SEGURIDAD

Este `.gitignore` protege:
- ✅ Datos sensibles de CASEN
- ✅ Archivos temporales de compilación
- ✅ Credenciales (si existen)
- ✅ Archivos del sistema

Puedes trabajar con seguridad sin preocuparte de subir datos pesados.

---

## 📞 PROBLEMAS CON GIT

### Si necesitas ayuda:

```bash
# Ver ayuda de git
git help

# Ver ayuda de comando específico
git help commit
git help push
```

### Deshacer último commit (si cometes error):

```bash
# Si ya no has hecho push
git reset --soft HEAD~1

# Si ya hiciste push (más cuidado)
git revert HEAD
git push origin main
```

---

## ✨ RESUMEN RÁPIDO

```bash
# 1. Clonar
git clone https://github.com/Romazss/Proyecto-Final-Muestreo.git
cd Proyecto-Final-Muestreo

# 2. Descargar datos
# [Ir a 01_Datos/ y descargar CASEN 2022]

# 3. Instalar dependencias
pip install pandas numpy matplotlib jupyter

# 4. Empezar a trabajar
jupyter notebook

# 5. Guardar cambios
git add .
git commit -m "Mi cambio"
git push origin main
```

---

## 📋 CHECKLIST DE CONFIGURACIÓN

- [ ] Cloné el repositorio
- [ ] Descargué CASEN 2022 a 01_Datos/
- [ ] Creé entorno virtual
- [ ] Instalé dependencias
- [ ] Leí documentación básica
- [ ] Verifiqué que puedo ejecutar código
- [ ] Hice primer commit (opcional)

---

## 🎉 ¡LISTO!

Ya puedes:
✅ Explorar datos CASEN 2022  
✅ Ejecutar análisis  
✅ Generar tablas y gráficos  
✅ Escribir documentación  
✅ Compartir cambios por Git  

**Cualquier duda, revisa la documentación en `00_Documentacion/`**

---

**Última actualización:** 23 de octubre de 2025  
**Versión:** 1.0  
**Estado:** ✅ LISTO PARA GITHUB
