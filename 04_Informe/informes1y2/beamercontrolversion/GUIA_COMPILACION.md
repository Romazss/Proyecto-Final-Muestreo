# 🔨 Guía de Compilación - Beamer Modular

## Compilación Rápida

### Opción 1: PowerShell (Windows)

```powershell
# Navegar al directorio
cd "C:\Users\esteb\GitHub\Proyecto-Final-Muestreo\04_Informe\beamercontrolversion"

# Compilar una vez (rápido)
pdflatex -interaction=nonstopmode beamer_principal.tex

# Compilar dos veces (para referencias y TOC)
pdflatex -interaction=nonstopmode beamer_principal.tex ; pdflatex -interaction=nonstopmode beamer_principal.tex

# Abrir el PDF
Invoke-Item beamer_principal.pdf
```

### Opción 2: Script de Compilación

Crea un archivo `compilar.ps1`:

```powershell
# compilar.ps1
Write-Host "Compilando presentación Beamer..." -ForegroundColor Cyan

# Primera compilación
Write-Host "`nPrimera pasada..." -ForegroundColor Yellow
pdflatex -interaction=nonstopmode beamer_principal.tex | Out-Null

# Segunda compilación (para referencias)
Write-Host "Segunda pasada..." -ForegroundColor Yellow
pdflatex -interaction=nonstopmode beamer_principal.tex | Out-Null

# Limpiar archivos auxiliares
Write-Host "`nLimpiando archivos temporales..." -ForegroundColor Yellow
Remove-Item *.aux, *.log, *.nav, *.out, *.snm, *.toc -ErrorAction SilentlyContinue

Write-Host "`n✓ Compilación exitosa! Abriendo PDF..." -ForegroundColor Green
Invoke-Item beamer_principal.pdf
```

Ejecutar:
```powershell
.\compilar.ps1
```

## Compilación por Secciones (Desarrollo)

Para compilar solo una sección durante el desarrollo, comenta las demás en `beamer_principal.tex`:

```latex
% Introducción
\input{01_Secciones/03_introduccion.tex}

% Diseño Muestral (comentado)
% \input{01_Secciones/04_diseno_muestral.tex}

% Plan de Análisis (comentado)
% \input{01_Secciones/05_plan_analisis.tex}
```

## Limpieza de Archivos Temporales

```powershell
# Limpiar archivos auxiliares de LaTeX
Remove-Item *.aux, *.log, *.nav, *.out, *.snm, *.toc -ErrorAction SilentlyContinue

# Limpiar TODO excepto .tex, .pdf y .md
Remove-Item * -Exclude *.tex,*.pdf,*.md,01_Secciones -ErrorAction SilentlyContinue
```

## Verificación de Errores

Si hay errores durante la compilación:

```powershell
# Ver el log completo
pdflatex beamer_principal.tex

# Buscar errores específicos en el log
Get-Content beamer_principal.log | Select-String "Error"
Get-Content beamer_principal.log | Select-String "Warning"
```

## Actualizar Paquetes Faltantes

Si falta algún paquete de LaTeX:

```powershell
# Actualizar tlmgr
tlmgr update --self

# Instalar paquete específico
tlmgr install <nombre-paquete>

# Instalar todos los paquetes comunes de beamer
tlmgr install beamer translator pgf xcolor colortbl booktabs multirow
```

## Compilación Silenciosa

Para compilar sin mostrar output en consola:

```powershell
pdflatex -interaction=batchmode beamer_principal.tex
```

## Watch Mode (Recompilación Automática)

Para recompilar automáticamente cuando cambies archivos (requiere `latexmk`):

```powershell
latexmk -pdf -pvc -interaction=nonstopmode beamer_principal.tex
```

## Troubleshooting

### Error: "Cannot find file"

**Problema**: No encuentra archivos de secciones

**Solución**:
```powershell
# Verificar que estás en el directorio correcto
pwd

# Debe mostrar: ...\04_Informe\beamercontrolversion
```

### Error: "Logo not found"

**Problema**: No encuentra el logo

**Solución**: Verificar que existe `../03_Logos/logo_kovan.jpg`

```powershell
Test-Path "../03_Logos/logo_kovan.jpg"
# Debe devolver: True
```

### Compilación muy lenta

**Solución**: Comenta secciones que no estés editando o usa modo draft:

```latex
\documentclass[11pt,aspectratio=169,draft]{beamer}
```

### Cambios no se ven

**Solución**: 
1. Compila dos veces
2. Borra archivos auxiliares
3. Vuelve a compilar

```powershell
Remove-Item *.aux, *.nav, *.toc -ErrorAction SilentlyContinue
pdflatex -interaction=nonstopmode beamer_principal.tex
pdflatex -interaction=nonstopmode beamer_principal.tex
```

## Comparar Versiones

Para ver diferencias con git:

```powershell
# Ver cambios en una sección específica
git diff 01_Secciones/04_diseno_muestral.tex

# Ver todos los cambios
git diff

# Comparar con versión anterior
git diff HEAD~1 01_Secciones/04_diseno_muestral.tex
```

## Exportar a Otros Formatos

### Generar imágenes PNG de cada slide

```powershell
# Requiere ImageMagick
magick convert -density 300 beamer_principal.pdf -quality 100 slide_%03d.png
```

### Generar handouts (versión imprimible)

Agrega al inicio de `beamer_principal.tex`:

```latex
\documentclass[11pt,aspectratio=169,handout]{beamer}
```

Luego compila normalmente.

## Workflow Recomendado

1. **Editar**: Modifica archivo de sección
2. **Guardar**: Ctrl+S
3. **Compilar**: Ejecuta el script de compilación
4. **Revisar**: Abre el PDF
5. **Repetir**: Hasta estar satisfecho
6. **Commit**: Guarda cambios en git

```powershell
# Ejemplo de workflow completo
git checkout -b mejora-diseno-muestral
# Editar 01_Secciones/04_diseno_muestral.tex
.\compilar.ps1
git add 01_Secciones/04_diseno_muestral.tex
git commit -m "Mejora visualización del diseño muestral"
git push origin mejora-diseno-muestral
```
