# 📤 ESTRATEGIA GIT - Proyecto Final EYP2417 Muestreo

**Documentación sobre cómo usar Git y GitHub de forma segura con este proyecto**

---

## 🎯 OBJETIVO

Versionar código y documentación sin subir:
- ❌ Datos pesados (CASEN 2022 - 500MB+)
- ❌ Archivos compilados
- ❌ Archivos temporales
- ✅ Código Python
- ✅ Documentación Markdown
- ✅ Archivos LaTeX

---

## 🛡️ CONFIGURACIÓN IMPLEMENTADA

### 1. `.gitignore` (Control de qué se versionea)

```
❌ Excluye:
  - 01_Datos/*.dta (base CASEN - 500MB+)
  - 05_Outputs/*.csv, *.pdf (resultados generados)
  - __pycache__/ (compilados Python)
  - *.ipynb_checkpoints/ (checkpoints Jupyter)
  - *.aux, *.log, etc. (archivos LaTeX temporales)
  - .DS_Store (archivos del sistema)

✅ Incluye (mediante excepciones):
  - *.md (documentación)
  - *.py (código Python)
  - *.tex (archivos LaTeX)
  - requirements.txt
  - .gitignore (este mismo archivo)
```

### 2. `.gitattributes` (Cómo Git trata archivos)

```
Normaliza saltos de línea:
  - Python, Markdown, LaTeX → LF (Unix)
  - Imágenes, binarios → Sin modificación
  - Notebooks Jupyter → Tratamiento especial para diffs

Ventajas:
  ✓ Compatibilidad macOS/Linux/Windows
  ✓ Diffs más limpios
  ✓ Evita conflictos por saltos de línea
```

### 3. `requirements.txt` (Dependencias)

Especifica todas las librerías necesarias:
```bash
# Otros pueden instalar fácilmente
pip install -r requirements.txt
```

---

## 📋 FLUJO DE TRABAJO

### 1. CLONAR EL REPOSITORIO

```bash
git clone https://github.com/Romazss/Proyecto-Final-Muestreo.git
cd Proyecto-Final-Muestreo
```

**Tamaño esperado:** ~5 MB (sin datos)

### 2. DESCARGAR DATOS MANUALMENTE

```bash
# Los datos NO están en GitHub - descargar por separado
# https://www.ministeriodesarrollosocial.gob.cl/casen/

# Guardar en:
mv "Base de datos Casen 2022 STATA_18 marzo 2024.dta" \
   "01_Datos/"

# Git ignorará automáticamente este archivo ✓
```

### 3. INSTALAR DEPENDENCIAS

```bash
pip install -r requirements.txt
```

### 4. HACER CAMBIOS

```bash
# Editar archivos
# Crear notebooks
# Escribir documentación
# etc.
```

### 5. SUBIR CAMBIOS

```bash
# Ver cambios
git status

# Ver diferencias
git diff

# Agregar cambios
git add .

# Hacer commit
git commit -m "Descripción clara de cambios"

# Subir
git push origin main
```

---

## ✅ VERIFICAR QUÉ SE SUBE

### Antes de hacer `push`:

```bash
# Ver qué archivos van a subirse
git add .
git status

# Debe mostrar SOLO:
# - Código Python (.py)
# - Documentación (.md)
# - LaTeX (.tex)
# - Configuraciones (requirements.txt, etc.)

# NO debe mostrar:
# - 01_Datos/
# - 05_Outputs/
# - __pycache__/
# - .ipynb_checkpoints/
```

### Si accidentalmente intentas subir datos:

```bash
# Git te lo impedirá automáticamente
# Si ya lo hiciste (por error), puedo recuperar
```

---

## 🔄 COLABORACIÓN CON OTROS MIEMBROS

### Trabajo en equipo:

```bash
# 1. Esteban: Trabaja en rama principal
git checkout main
# ... hace cambios en 02_Analisis/01_Pobreza/
git add .
git commit -m "Agrego análisis exploratorio de pobreza"
git push origin main

# 2. Francisca: Obtiene cambios de Esteban
git pull origin main
# ... ahora tiene los cambios de Esteban
# ... hace cambios en 02_Analisis/02_Brecha_Salarial/
git add .
git commit -m "Agrego análisis de brecha salarial"
git push origin main
```

### Evitar conflictos:

```bash
# Actualizar antes de trabajar
git pull origin main

# Trabajar en archivos diferentes
# Esteban → 02_Analisis/01_Pobreza/
# Francisca → 02_Analisis/02_Brecha_Salarial/

# Commit frecuente (cada 30 min)
git add .
git commit -m "Descripción clara"
```

### Si hay conflicto:

```bash
# Git te avisará
git status

# Resolver manualmente (abrir archivos conflictivos)
# Luego hacer commit

git add archivo_resuelto.py
git commit -m "Resuelvo conflicto en archivo_resuelto.py"
git push origin main
```

---

## 📊 TAMAÑO DE REPOSITORIO

### Sin datos CASEN:
```
Documentación:  ~1 MB
Código Python:  ~0.5 MB
LaTeX:          ~0.3 MB
Config/otros:   ~0.2 MB
─────────────────────
TOTAL:          ~2-3 MB  ✓ Fácil de clonar
```

### Con datos CASEN (no versionado):
```
Datos CASEN:    ~500 MB  ✗ No subir a GitHub
```

---

## 🚀 COMANDOS ÚTILES

### Ver historial:
```bash
git log --oneline
git log --graph --oneline --all
```

### Ver cambios sin hacer commit:
```bash
git diff                    # Cambios no staged
git diff --staged           # Cambios staged
git diff HEAD~1 HEAD        # Comparar últimos 2 commits
```

### Deshacer cambios:
```bash
git checkout -- archivo.py  # Deshacer cambios en archivo
git reset --soft HEAD~1     # Deshacer último commit (mantener cambios)
git revert HEAD             # Crear commit que deshace cambios
```

### Ramas (para trabajo avanzado):
```bash
git branch                  # Ver ramas
git checkout -b mi-rama     # Crear nueva rama
git push -u origin mi-rama  # Subir rama nueva
```

---

## ⚠️ SITUACIONES COMUNES

### Situación 1: "Subí datos por error"

```bash
# Si aún no hiciste push:
git reset --soft HEAD~1
git reset HEAD 01_Datos/archivo.dta

# Si ya hiciste push:
# Contactar a Esteban para remover del historio
```

### Situación 2: "Necesito bajame los últimos cambios"

```bash
git pull origin main
```

### Situación 3: "Quiero ver qué cambió en un archivo"

```bash
git log --oneline -- archivo.py
git show commit_id:archivo.py
```

### Situación 4: "Tengo cambios locales pero necesito actualizar"

```bash
# Opción A: Guardar y luego recuperar
git stash
git pull origin main
git stash pop

# Opción B: Simplemente commitear primero
git add .
git commit -m "Mi cambio"
git pull origin main
```

---

## 📝 MENSAJES DE COMMIT

### Formato recomendado:

```
[TIPO] Descripción breve

Descripción más detallada si es necesario.

Tipos sugeridos:
- [FEATURE] Nuevo análisis o funcionalidad
- [FIX] Corrección de errores
- [DOCS] Cambios en documentación
- [REFACTOR] Mejora de código sin cambiar funcionalidad
- [PERF] Mejoras de rendimiento
```

### Ejemplos:

```bash
# Bueno
git commit -m "[FEATURE] Agrego análisis de pobreza por región"

# Bueno
git commit -m "[DOCS] Actualizo especificaciones técnicas"

# Malo
git commit -m "cambios"

# Malo
git commit -m "fix bug"
```

---

## 🔐 SEGURIDAD

### No commitear:

```bash
# ❌ Credenciales
.env
secrets.json

# ❌ Información privada
contraseñas.txt

# ❌ Datos sensibles
emails.csv
```

### Si accidentalmente commiteas:

```bash
# Remover de historio (irreversible)
git filter-branch --tree-filter 'rm -f archivo_sensible' HEAD

# O contactar a Esteban
```

---

## 📞 SOLUCIÓN DE PROBLEMAS

| Problema | Solución |
|----------|----------|
| "Permission denied" al hacer push | Configurar SSH key o personal token |
| "Merge conflict" | Ver documentación de resolución de conflictos |
| "Large file" | El archivo está en .gitignore |
| "Can't clone" | Verificar conexión a Internet y URL |
| ".gitignore no funciona" | Archivos ya versionados: `git rm --cached archivo` |

---

## 🎓 REFERENCIAS

- **Git Documentation:** https://git-scm.com/doc
- **GitHub Guides:** https://guides.github.com/
- **Gitignore Collection:** https://github.com/github/gitignore

---

## ✨ CHECKLIST GITHUB

- [ ] Cloné el repositorio
- [ ] Instalé dependencias (`pip install -r requirements.txt`)
- [ ] Descargué CASEN 2022 a `01_Datos/`
- [ ] Hice cambios sin problema
- [ ] Verifiqué que `.gitignore` funciona
- [ ] Hice commit con mensaje claro
- [ ] Hice push sin problema
- [ ] Otros miembros pueden ver mis cambios

---

**Última actualización:** 23 de octubre de 2025  
**Versión:** 1.0  
**Estado:** ✅ LISTO PARA GITHUB
