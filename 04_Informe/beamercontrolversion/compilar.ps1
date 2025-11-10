# Script de Compilación Automatizada para Beamer
# Compila la presentación y limpia archivos temporales

Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  COMPILADOR BEAMER - Proyecto Final Muestreo              ║" -ForegroundColor Cyan
Write-Host "║  Grupo 4 - Pontificia Universidad Católica de Chile       ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Verificar que estamos en el directorio correcto
$expectedPath = "*beamercontrolversion*"
$currentPath = Get-Location
if ($currentPath -notlike $expectedPath) {
    Write-Host "⚠ ADVERTENCIA: No estás en el directorio beamercontrolversion" -ForegroundColor Yellow
    Write-Host "  Directorio actual: $currentPath" -ForegroundColor Yellow
    Write-Host ""
    $continuar = Read-Host "¿Deseas continuar de todas formas? (S/N)"
    if ($continuar -ne "S" -and $continuar -ne "s") {
        Write-Host "Compilación cancelada." -ForegroundColor Red
        exit
    }
}

# Nombre del archivo principal
$archivoTex = "beamer_principal.tex"

# Verificar que existe el archivo
if (-not (Test-Path $archivoTex)) {
    Write-Host "✗ ERROR: No se encontró el archivo $archivoTex" -ForegroundColor Red
    Write-Host "  Asegúrate de estar en el directorio correcto." -ForegroundColor Red
    exit 1
}

Write-Host "📄 Archivo a compilar: $archivoTex" -ForegroundColor Green
Write-Host ""

# Primera compilación
Write-Host "⏳ [1/2] Primera pasada de compilación..." -ForegroundColor Yellow
$resultado1 = pdflatex -interaction=nonstopmode $archivoTex 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Error en la primera compilación" -ForegroundColor Red
    Write-Host "  Revisa el archivo $($archivoTex.Replace('.tex', '.log'))" -ForegroundColor Red
    exit 1
}
Write-Host "  ✓ Primera pasada completada" -ForegroundColor Green

# Segunda compilación (para referencias y TOC)
Write-Host "⏳ [2/2] Segunda pasada (referencias y TOC)..." -ForegroundColor Yellow
$resultado2 = pdflatex -interaction=nonstopmode $archivoTex 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Error en la segunda compilación" -ForegroundColor Red
    Write-Host "  Revisa el archivo $($archivoTex.Replace('.tex', '.log'))" -ForegroundColor Red
    exit 1
}
Write-Host "  ✓ Segunda pasada completada" -ForegroundColor Green
Write-Host ""

# Contar warnings en el log
$logFile = $archivoTex.Replace('.tex', '.log')
if (Test-Path $logFile) {
    $warnings = (Get-Content $logFile | Select-String "Warning").Count
    if ($warnings -gt 0) {
        Write-Host "⚠ Se encontraron $warnings advertencias en el log" -ForegroundColor Yellow
    }
}

# Limpiar archivos auxiliares
Write-Host "🧹 Limpiando archivos temporales..." -ForegroundColor Cyan
$extensionesLimpiar = @('*.aux', '*.log', '*.nav', '*.out', '*.snm', '*.toc')
$archivosEliminados = 0

foreach ($ext in $extensionesLimpiar) {
    $archivos = Get-ChildItem -Path . -Filter $ext -ErrorAction SilentlyContinue
    foreach ($archivo in $archivos) {
        Remove-Item $archivo.FullName -ErrorAction SilentlyContinue
        $archivosEliminados++
    }
}

Write-Host "  ✓ $archivosEliminados archivos temporales eliminados" -ForegroundColor Green
Write-Host ""

# Verificar que se generó el PDF
$archivoPdf = $archivoTex.Replace('.tex', '.pdf')
if (Test-Path $archivoPdf) {
    $tamano = (Get-Item $archivoPdf).Length / 1KB
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║  ✓ COMPILACIÓN EXITOSA!                                   ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    Write-Host "📊 Archivo generado: $archivoPdf" -ForegroundColor Green
    Write-Host "📏 Tamaño: $([math]::Round($tamano, 2)) KB" -ForegroundColor Green
    Write-Host ""
    
    # Preguntar si desea abrir el PDF
    Write-Host "¿Deseas abrir el PDF? (S/N): " -NoNewline -ForegroundColor Cyan
    $abrir = Read-Host
    
    if ($abrir -eq "S" -or $abrir -eq "s" -or $abrir -eq "") {
        Write-Host "📖 Abriendo PDF..." -ForegroundColor Cyan
        Invoke-Item $archivoPdf
    }
} else {
    Write-Host "✗ ERROR: No se generó el archivo PDF" -ForegroundColor Red
    Write-Host "  Revisa los logs para más detalles" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Gray
Write-Host "Proceso completado exitosamente" -ForegroundColor Gray
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Gray
