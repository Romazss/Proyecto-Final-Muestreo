# ============================================================================
# ANÁLISIS CASEN 2022 - CÓDIGO CONSOLIDADO
# Proyecto Final Muestreo (EYP2417)- el documento para ejecutarlo requiere ,
# Autores: Esteban Román  • Julián Vargas • Francisca Sepúlveda • Alexander Pinto
#                                 - a lo menos 22 GB  de RAM para el GEV
# Fecha: Diciembre 2025
# ============================================================================

# --- 0. CONFIGURACIÓN INICIAL -----------------------------------------------
Sys.setlocale("LC_ALL", "Spanish_Chile.UTF-8")

library(tidyverse)
library(survey)
library(srvyr)
library(haven)
library(scales)

# --- 1. CARGA Y PREPARACIÓN DE DATOS ----------------------------------------

# Diccionario de regiones con códigos CASEN 2022
# NOTA: Los códigos NO siguen orden geográfico norte-sur
# Código 15 = Arica (más al norte), Código 1 = Tarapacá, Código 13 = RM (centro)
regiones_chile <- c(
  "1"  = "Tarapacá (I)",
  "2"  = "Antofagasta (II)",
  "3"  = "Atacama (III)",
  "4"  = "Coquimbo (IV)",
  "5"  = "Valparaíso (V)",
  "6"  = "O'Higgins (VI)",
  "7"  = "Maule (VII)",
  "8"  = "Biobío (VIII)",
  "9"  = "La Araucanía (IX)",
  "10" = "Los Lagos (X)",
  "11" = "Aysén (XI)",
  "12" = "Magallanes (XII)",
  "13" = "Metropolitana (RM)",
  "14" = "Los Ríos (XIV)",
  "15" = "Arica y Parinacota (XV)",
  "16" = "Ñuble (XVI)"
)

# Orden geográfico REAL de norte a sur (para factor ordenado en gráficos)
# Arica (15) es la más al norte, RM (13) está al centro, Ñuble (16) entre Maule y Biobío
orden_norte_sur <- c(
  "Arica y Parinacota (XV)",
  "Tarapacá (I)",
  "Antofagasta (II)",
  "Atacama (III)",
  "Coquimbo (IV)",
  "Valparaíso (V)",
  "Metropolitana (RM)",
  "O'Higgins (VI)",
  "Maule (VII)",
  "Ñuble (XVI)",
  "Biobío (VIII)",
  "La Araucanía (IX)",
  "Los Ríos (XIV)",
  "Los Lagos (X)",
  "Aysén (XI)",
  "Magallanes (XII)"
)

# Cargar base CASEN 2022
#casen <- read_dta("Base_de_datos_Casen_2022_STATA_18_marzo_2024.dta")
# Alternativa si ya está cargada:
casen <- Base_de_datos_Casen_2022_STATA_18_marzo_2024

# Filtrar jefes de hogar con manejo correcto de NA
jefes <- casen %>%
  filter(pco1 == 1) %>%
  mutate(
    # Variables de pobreza (CORREGIDO: case_when para NA)
    es_pobre = case_when(
      pobreza %in% c(1, 2) ~ 1,
      pobreza == 3 ~ 0,
      TRUE ~ NA_real_
    ),
    es_pobre_extremo = case_when(
      pobreza == 1 ~ 1,
      pobreza %in% c(2, 3) ~ 0,
      TRUE ~ NA_real_
    ),
    # Variable dummy para zona (opcional, mejora interpretación)
    area_rural = ifelse(area == 2, 1, 0)
  )

# Verificación inicial
cat("=== VERIFICACIÓN INICIAL ===\n")
cat("Total jefes de hogar:", nrow(jefes), "\n")
cat("Distribución pobreza (incluyendo NA):\n")
print(table(jefes$es_pobre, useNA = "ifany"))

# --- 2. DISEÑO MUESTRAL -----------------------------------------------------

# Opción A: Diseño simplificado (NO RECOMENDADO - subestima errores estándar)
# diseno_casen <- svydesign(ids = ~1, weights = ~expr, data = jefes)
# diseno_srvyr <- jefes %>% as_survey_design(weights = expr)

# Opción B: Diseño complejo COMPLETO (USADO en este análisis)
# Incorpora estratificación (varstrat) y conglomerados (varunit)
diseno_casen <- svydesign(
  ids = ~varunit,
  strata = ~varstrat,
  weights = ~expr,
  data = jefes,
  nest = TRUE
)

diseno_srvyr <- jefes %>% 
  as_survey_design(
    ids = varunit,
    strata = varstrat,
    weights = expr,
    nest = TRUE
  )

# ============================================================================
# EJE 1: DISTRIBUCIÓN DE LA POBREZA
# ============================================================================

cat("\n========== EJE 1: POBREZA ==========\n")

# --- 1.1 Pobreza por Región -------------------------------------------------
pobreza_region <- diseno_srvyr %>%
  group_by(region) %>%
  summarise(
    prop_pobreza = survey_mean(es_pobre, vartype = c("se", "ci"), na.rm = TRUE),
    n = unweighted(n())
  ) %>%
  arrange(desc(prop_pobreza))

cat("\n--- Pobreza por Región (ordenado de mayor a menor) ---\n")
print(pobreza_region)

# --- 1.2 Pobreza Urbano vs Rural --------------------------------------------
pobreza_area <- diseno_srvyr %>%
  mutate(area_label = ifelse(area == 1, "Urbano", "Rural")) %>%
  group_by(area_label) %>%
  summarise(
    prop_pobreza = survey_mean(es_pobre, vartype = c("se", "ci"), na.rm = TRUE),
    n_expandido = survey_total(vartype = NULL)
  )

cat("\n--- Pobreza por Área ---\n")
print(pobreza_area)

# Test Chi-cuadrado de independencia
test_chisq <- svychisq(~ es_pobre + area, design = diseno_casen, statistic = "Chisq")
cat("\n--- Test Chi-cuadrado (zona × pobreza) ---\n")
print(test_chisq)

# Test t de diferencia
test_area <- svyttest(es_pobre ~ factor(area), design = diseno_casen)
cat("\n--- Test t de diferencia urbano/rural ---\n")
print(test_area)

# --- 1.3 Ingreso por Tamaño de Hogar ----------------------------------------
ingreso_tamano <- diseno_srvyr %>%
  mutate(tamano_hogar = cut(tot_per_h, 
                            breaks = c(0, 1, 2, 4, Inf),
                            labels = c("1 persona", "2 personas", 
                                       "3-4 personas", "5+ personas"))) %>%
  group_by(tamano_hogar) %>%
  summarise(
    ingreso_medio = survey_mean(ytotcorh, vartype = c("se", "ci"), na.rm = TRUE)
  )

cat("\n--- Ingreso promedio por tamaño de hogar ---\n")
print(ingreso_tamano)

# --- 1.4 Modelo Logístico de Pobreza ----------------------------------------
cat("\n--- Modelo Logístico de Pobreza ---\n")
modelo_pobreza <- svyglm(
  es_pobre ~ factor(area) + esc + tot_per_h,
  design = diseno_casen,
  family = quasibinomial()
)
print(summary(modelo_pobreza))

cat("\n--- Odds Ratios con IC 95% ---\n")
print(exp(cbind(OR = coef(modelo_pobreza), confint(modelo_pobreza))))

# Modelo con interacción (exploratorio)
modelo_interaccion <- svyglm(
  es_pobre ~ area * esc + edad,
  design = diseno_casen,
  family = quasibinomial()
)

# --- 1.5 Análisis de Mediación: Zona → Educación → Pobreza ------------------
cat("\n--- Análisis de Mediación ---\n")

# Filtrar NA para análisis de mediación
jefes_mediacion <- jefes %>% drop_na(es_pobre, area_rural, esc)
diseno_mediacion <- svydesign(
  ids = ~varunit,
  strata = ~varstrat,
  weights = ~expr,
  data = jefes_mediacion,
  nest = TRUE
)

# Efecto total (c): Zona → Pobreza
modelo_total <- svyglm(es_pobre ~ area_rural, design = diseno_mediacion, family = quasibinomial())
c_total <- coef(modelo_total)["area_rural"]
se_c <- summary(modelo_total)$coefficients["area_rural", "Std. Error"]

# Efecto a: Zona → Educación
modelo_a <- svyglm(esc ~ area_rural, design = diseno_mediacion)
a <- coef(modelo_a)["area_rural"]
se_a <- summary(modelo_a)$coefficients["area_rural", "Std. Error"]

# Efectos b y c': Educación → Pobreza controlando zona
modelo_bc <- svyglm(es_pobre ~ area_rural + esc, design = diseno_mediacion, family = quasibinomial())
b <- coef(modelo_bc)["esc"]
se_b <- summary(modelo_bc)$coefficients["esc", "Std. Error"]
c_prime <- coef(modelo_bc)["area_rural"]

# Test de Sobel
efecto_indirecto <- a * b
se_ab <- sqrt(a^2 * se_b^2 + b^2 * se_a^2)
z_sobel <- efecto_indirecto / se_ab
p_sobel <- 2 * (1 - pnorm(abs(z_sobel)))
prop_mediada <- abs(efecto_indirecto / c_total) * 100

cat("Efecto total (c):", round(c_total, 4), "\n")
cat("Efecto indirecto (a × b):", round(efecto_indirecto, 4), "\n")
cat("Efecto directo (c'):", round(c_prime, 4), "\n")
cat("Z de Sobel:", round(z_sobel, 3), "\n")
cat("p-valor:", format(p_sobel, digits = 4), "\n")
cat("Proporción mediada:", round(prop_mediada, 1), "%\n")

# ============================================================================
# EJE 2: BRECHA SALARIAL DE GÉNERO
# ============================================================================

cat("\n========== EJE 2: BRECHA SALARIAL ==========\n")

# Filtrar jefes con ingreso laboral positivo
jefes_trabajo <- jefes %>%
  drop_na(ytrabajocorh) %>%
  filter(ytrabajocorh > 0) %>%
  mutate(
    sexo_label = ifelse(sexo == 1, "Hombre", "Mujer"),
    # Limpiar código -99 en ocupación
    oficio4_08 = ifelse(oficio4_08 == -99, NA, oficio4_08),
    # CORREGIDO: Usar variable educ de CASEN 2022 (incluye Técnico Superior)
    nivel_educ = case_when(
      educ %in% c(0, 1, 2) ~ "Básica o menos",
      educ %in% c(3, 4, 5, 6) ~ "Media",
      educ %in% c(7, 8) ~ "Técnico Superior",
      educ %in% c(9, 10) ~ "Profesional",
      educ %in% c(11, 12) ~ "Postgrado",
      educ == -88 ~ NA_character_,
      TRUE ~ NA_character_
    ),
    nivel_educ = factor(nivel_educ, 
                        levels = c("Básica o menos", "Media", "Técnico Superior", 
                                   "Profesional", "Postgrado"))
  )

diseno_trabajo <- svydesign(
  ids = ~varunit,
  strata = ~varstrat,
  weights = ~expr,
  data = jefes_trabajo,
  nest = TRUE
)

diseno_trabajo_srvyr <- jefes_trabajo %>% 
  as_survey_design(
    ids = varunit,
    strata = varstrat,
    weights = expr,
    nest = TRUE
  )

# --- 2.1 Etapa 1: Brecha Bruta (sin controles) ------------------------------
cat("\n--- Etapa 1: Análisis Bivariado ---\n")

test_brecha_bruta <- svyttest(ytrabajocorh ~ sexo, design = diseno_trabajo)
print(test_brecha_bruta)

medias_sexo <- svyby(~ytrabajocorh, ~sexo, diseno_trabajo, svymean)
brecha_bruta <- (medias_sexo[1, "ytrabajocorh"] - medias_sexo[2, "ytrabajocorh"]) / 
  medias_sexo[1, "ytrabajocorh"] * 100
cat("\n*** BRECHA BRUTA (sin controles):", round(brecha_bruta, 1), "% ***\n")

# Ingreso por sexo con IC
ingreso_sexo <- diseno_trabajo_srvyr %>%
  group_by(sexo_label) %>%
  summarise(
    ingreso_medio = survey_mean(ytrabajocorh, vartype = c("se", "ci")),
    mediana = survey_median(ytrabajocorh, vartype = "ci"),
    n = unweighted(n())
  )

cat("\n--- Ingreso por Sexo ---\n")
print(ingreso_sexo)

# --- 2.2 Etapa 2: Modelo Ajustado (controles socioeconómicos) ---------------
cat("\n--- Etapa 2: Modelo Ajustado ---\n")

modelo_ajustado <- svyglm(
  ytrabajocorh ~ sexo + esc + edad,
  design = diseno_trabajo
)
print(summary(modelo_ajustado))

cat("Diferencia ajustada (mujer vs hombre): $", 
    format(round(coef(modelo_ajustado)["sexo"], 0), big.mark = "."), "\n")

# --- 2.3 Etapa 3: Modelo Completo (controles laborales) ---------------------
cat("\n--- Etapa 3: Modelo Completo ---\n")

modelo_completo_brecha <- svyglm(
  ytrabajocorh ~ factor(sexo) + esc + edad + factor(oficio4_08) + tot_per_h,
  design = diseno_trabajo
)

coef_sexo <- summary(modelo_completo_brecha)$coefficients["factor(sexo)2", ]
cat("β_sexo (Mujer) =", round(coef_sexo["Estimate"], 2), "\n")
cat("p-valor =", format(coef_sexo["Pr(>|t|)"], digits = 4), "\n")

if (coef_sexo["Pr(>|t|)"] < 0.05 & coef_sexo["Estimate"] < 0) {
  cat("CONCLUSIÓN: Se RECHAZA H0. Existe brecha salarial significativa contra las mujeres.\n")
} else {
  cat("CONCLUSIÓN: No se rechaza H0 al nivel 0.05.\n")
}

# --- 2.4 Brecha por Nivel Educativo -----------------------------------------
brecha_educ <- diseno_trabajo_srvyr %>%
  group_by(nivel_educ, sexo_label) %>%
  summarise(
    ingreso_medio = survey_mean(ytrabajocorh, vartype = "se", na.rm = TRUE)
  ) %>%
  pivot_wider(
    names_from = sexo_label,
    values_from = c(ingreso_medio, ingreso_medio_se)
  ) %>%
  mutate(
    brecha_pct = (ingreso_medio_Hombre - ingreso_medio_Mujer) / ingreso_medio_Hombre * 100
  )

cat("\n--- Brecha por Nivel Educativo ---\n")
print(brecha_educ)

# --- 2.5 Modelo Log-Lineal --------------------------------------------------
cat("\n--- Modelo Log-Lineal ---\n")

modelo_brecha_log <- svyglm(
  log(ytrabajocorh) ~ factor(sexo) + esc + edad + I(edad^2),
  design = diseno_trabajo
)
print(summary(modelo_brecha_log))

dif_pct <- (exp(coef(modelo_brecha_log)["factor(sexo)2"]) - 1) * 100
cat("\n*** DIFERENCIA CONTROLADA (mujer vs hombre):", round(dif_pct, 1), "% ***\n")

# ============================================================================
# COMPARACIÓN PONDERADO VS NO PONDERADO
# ============================================================================

cat("\n========== VALIDACIÓN: SESGO POR NO PONDERAR ==========\n")

media_no_pond <- mean(jefes$ytotcorh, na.rm = TRUE)
media_pond <- svymean(~ytotcorh, diseno_casen, na.rm = TRUE)

formato_num <- function(x) format(x, big.mark = ".", decimal.mark = ",", scientific = FALSE)

cat("Media NO ponderada: $", formato_num(round(media_no_pond)), "\n")
cat("Media PONDERADA:    $", formato_num(round(coef(media_pond))), "\n")
cat("Diferencia relativa:", 
    round((coef(media_pond) - media_no_pond) / media_no_pond * 100, 2), "%\n")

# ============================================================================
# GRÁFICOS
# ============================================================================

# Gráfico 1: Pobreza por Región (ordenado geográficamente norte-sur)
# Preparar datos con nombres de región y orden geográfico
pobreza_region_plot <- pobreza_region %>%
  mutate(
    region_nombre = regiones_chile[as.character(region)],
    region_nombre = factor(region_nombre, levels = rev(orden_norte_sur))  # rev() para que norte quede arriba en coord_flip
  )

g1 <- ggplot(pobreza_region_plot, aes(x = region_nombre, y = prop_pobreza)) +
  geom_col(fill = "#4A90D9", alpha = 0.8) +
  geom_errorbar(aes(ymin = prop_pobreza_low, ymax = prop_pobreza_upp), width = 0.2) +
  coord_flip() +
  scale_y_continuous(labels = percent_format()) +
  labs(title = "Incidencia de Pobreza por Región",
       subtitle = "CASEN 2022 - Jefes de Hogar | Orden geográfico norte-sur",
       x = "Región", y = "Proporción en Pobreza",
       caption = "Fuente: Elaboración propia con datos CASEN 2022") +
  theme_minimal(base_size = 12)

print(g1)

# Gráfico 2: Brecha por Educación
brecha_long <- brecha_educ %>%
  drop_na(nivel_educ) %>%
  pivot_longer(cols = c(ingreso_medio_Hombre, ingreso_medio_Mujer),
               names_to = "sexo", values_to = "ingreso") %>%
  mutate(sexo = ifelse(sexo == "ingreso_medio_Hombre", "Hombre", "Mujer"))

g2 <- ggplot(brecha_long, aes(x = nivel_educ, y = ingreso, fill = sexo)) +
  geom_col(position = "dodge", alpha = 0.8) +
  scale_y_continuous(labels = label_dollar(prefix = "$", big.mark = ".", decimal.mark = ",")) +
  scale_fill_manual(values = c("Hombre" = "#2E86AB", "Mujer" = "#A23B72")) +
  labs(title = "Ingreso Laboral por Nivel Educativo y Sexo",
       subtitle = "Jefes de hogar con ingreso positivo",
       x = "Nivel Educativo", y = "Ingreso Promedio", fill = "Sexo",
       caption = "Fuente: Elaboración propia con datos CASEN 2022") +
  theme_minimal(base_size = 12)

print(g2)

# Gráfico 3: Brecha Porcentual
g3 <- brecha_educ %>%
  drop_na(nivel_educ) %>%
  ggplot(aes(x = nivel_educ, y = brecha_pct)) +
  geom_col(fill = "#E63946", alpha = 0.8) +
  geom_text(aes(label = paste0(round(brecha_pct, 1), "%")), vjust = -0.5) +
  labs(title = "Brecha Salarial de Género por Nivel Educativo",
       subtitle = "Diferencia porcentual Hombre - Mujer",
       x = "Nivel Educativo", y = "Brecha (%)",
       caption = "Fuente: Elaboración propia con datos CASEN 2022") +
  theme_minimal()

print(g3)

# Gráfico 4: Pobreza Urbano vs Rural (con IC)
g4 <- pobreza_area %>%
  ggplot(aes(x = area_label, y = prop_pobreza, fill = area_label)) +
  geom_col(alpha = 0.8, width = 0.6) +
  geom_errorbar(aes(ymin = prop_pobreza_low, ymax = prop_pobreza_upp), 
                width = 0.15, linewidth = 0.8) +
  geom_text(aes(label = paste0(round(prop_pobreza * 100, 1), "%")), 
            vjust = -1.5, size = 5, fontface = "bold") +
  scale_y_continuous(labels = percent_format(), limits = c(0, 0.12)) +
  scale_fill_manual(values = c("Rural" = "#8B4513", "Urbano" = "#4682B4")) +
  labs(title = "Incidencia de Pobreza: Zona Urbana vs Rural",
       subtitle = "Diferencia significativa (p < 0.001) | IC 95%",
       x = NULL, y = "Proporción en Pobreza",
       caption = "Fuente: CASEN 2022 - Jefes de hogar") +
  theme_minimal(base_size = 14) +
  theme(legend.position = "none")

print(g4)

# Gráfico 5: Distribución de Ingresos por Sexo (Densidad)
g5 <- jefes_trabajo %>%
  filter(ytrabajocorh < quantile(ytrabajocorh, 0.95, na.rm = TRUE)) %>%
  ggplot(aes(x = ytrabajocorh, fill = sexo_label, color = sexo_label)) +
  geom_density(alpha = 0.4, linewidth = 1) +
  geom_vline(data = ingreso_sexo, aes(xintercept = ingreso_medio, color = sexo_label),
             linetype = "dashed", linewidth = 1) +
  scale_x_continuous(labels = label_dollar(prefix = "$", big.mark = ".", 
                                           decimal.mark = ",", scale = 1e-6, suffix = "M")) +
  scale_fill_manual(values = c("Hombre" = "#2E86AB", "Mujer" = "#A23B72")) +
  scale_color_manual(values = c("Hombre" = "#2E86AB", "Mujer" = "#A23B72")) +
  labs(title = "Distribución de Ingresos Laborales por Sexo",
       subtitle = "Líneas punteadas = medias | Percentil 95 truncado",
       x = "Ingreso del Trabajo (millones CLP)", y = "Densidad",
       fill = "Sexo", color = "Sexo",
       caption = "Fuente: CASEN 2022 - Jefes de hogar con ingreso positivo") +
  theme_minimal(base_size = 12) +
  theme(legend.position = "top")

print(g5)

# Gráfico 6: Escolaridad por Zona (Mediación Visual)
escolaridad_zona <- diseno_srvyr %>%
  mutate(area_label = ifelse(area == 1, "Urbano", "Rural")) %>%
  group_by(area_label) %>%
  summarise(
    esc_media = survey_mean(esc, vartype = c("se", "ci"), na.rm = TRUE)
  )

g6 <- escolaridad_zona %>%
  ggplot(aes(x = area_label, y = esc_media, fill = area_label)) +
  geom_col(alpha = 0.8, width = 0.6) +
  geom_errorbar(aes(ymin = esc_media_low, ymax = esc_media_upp), 
                width = 0.15, linewidth = 0.8) +
  geom_text(aes(label = paste0(round(esc_media, 1), " años")), 
            vjust = -1.5, size = 5, fontface = "bold") +
  scale_y_continuous(limits = c(0, 14)) +
  scale_fill_manual(values = c("Rural" = "#8B4513", "Urbano" = "#4682B4")) +
  labs(title = "Escolaridad Promedio por Zona",
       subtitle = "Mecanismo de mediación: menor educación rural → mayor pobreza",
       x = NULL, y = "Años de Escolaridad",
       caption = "Fuente: CASEN 2022 - Jefes de hogar") +
  theme_minimal(base_size = 14) +
  theme(legend.position = "none")

print(g6)

# Gráfico 7: Pobreza por Región y Zona (ordenado geográficamente norte-sur)
pobreza_region_zona <- diseno_srvyr %>%
  mutate(area_label = ifelse(area == 1, "Urbano", "Rural")) %>%
  group_by(region, area_label) %>%
  summarise(
    prop_pobreza = survey_mean(es_pobre, vartype = "ci", na.rm = TRUE),
    n = unweighted(n())
  ) %>%
  ungroup() %>%
  mutate(
    region_nombre = regiones_chile[as.character(region)],
    region_nombre = factor(region_nombre, levels = rev(orden_norte_sur))
  )

g7 <- pobreza_region_zona %>%
  ggplot(aes(x = region_nombre, y = prop_pobreza, fill = area_label)) +
  geom_col(position = "dodge", alpha = 0.8) +
  coord_flip() +
  scale_y_continuous(labels = percent_format()) +
  scale_fill_manual(values = c("Rural" = "#8B4513", "Urbano" = "#4682B4")) +
  labs(title = "Incidencia de Pobreza por Región y Zona",
       subtitle = "Brecha urbano-rural consistente en todas las regiones | Orden geográfico norte-sur",
       x = "Región", y = "Proporción en Pobreza", fill = "Zona",
       caption = "Fuente: CASEN 2022 - Jefes de hogar") +
  theme_minimal(base_size = 11) +
  theme(legend.position = "top")

print(g7)

# Gráfico 8: Brecha Salarial por Grupo de Edad
brecha_edad <- diseno_trabajo_srvyr %>%
  mutate(grupo_edad = cut(edad, 
                          breaks = c(0, 30, 40, 50, 60, Inf),
                          labels = c("≤30", "31-40", "41-50", "51-60", "60+"))) %>%
  group_by(grupo_edad, sexo_label) %>%
  summarise(
    ingreso_medio = survey_mean(ytrabajocorh, vartype = "se", na.rm = TRUE)
  ) %>%
  pivot_wider(
    names_from = sexo_label,
    values_from = c(ingreso_medio, ingreso_medio_se)
  ) %>%
  mutate(
    brecha_pct = (ingreso_medio_Hombre - ingreso_medio_Mujer) / ingreso_medio_Hombre * 100
  )

g8 <- brecha_edad %>%
  drop_na(grupo_edad) %>%
  ggplot(aes(x = grupo_edad, y = brecha_pct)) +
  geom_col(fill = "#E63946", alpha = 0.8) +
  geom_text(aes(label = paste0(round(brecha_pct, 1), "%")), vjust = -0.5, fontface = "bold") +
  geom_hline(yintercept = mean(brecha_edad$brecha_pct, na.rm = TRUE), 
             linetype = "dashed", color = "gray40") +
  scale_y_continuous(limits = c(0, 30)) +
  labs(title = "Brecha Salarial de Género por Grupo de Edad",
       subtitle = "Línea punteada = brecha promedio",
       x = "Grupo de Edad", y = "Brecha (%)",
       caption = "Fuente: CASEN 2022 - Jefes de hogar con ingreso positivo") +
  theme_minimal(base_size = 12)

print(g8)

# Gráfico 9: Forest Plot de Odds Ratios (Modelo Pobreza)
or_data <- data.frame(
  variable = c("Zona Rural\n(ref: Urbano)", "Escolaridad\n(por año)", "Tamaño Hogar\n(por persona)"),
  OR = exp(coef(modelo_pobreza)[-1]),
  lower = exp(confint(modelo_pobreza)[-1, 1]),
  upper = exp(confint(modelo_pobreza)[-1, 2])
)

g9 <- or_data %>%
  ggplot(aes(x = OR, y = reorder(variable, OR))) +
  geom_vline(xintercept = 1, linetype = "dashed", color = "gray50") +
  geom_errorbarh(aes(xmin = lower, xmax = upper), height = 0.2, linewidth = 1, color = "#4A90D9") +
  geom_point(size = 4, color = "#4A90D9") +
  geom_text(aes(label = paste0("OR = ", round(OR, 2))), vjust = -1, size = 4) +
  scale_x_continuous(trans = "log10", breaks = c(0.5, 0.75, 1, 1.25, 1.5)) +
  labs(title = "Odds Ratios del Modelo Logístico de Pobreza",
       subtitle = "IC 95% | Escala logarítmica | Línea en OR = 1 (sin efecto)",
       x = "Odds Ratio (escala log)", y = NULL,
       caption = "Fuente: CASEN 2022 - Modelo ajustado por zona, escolaridad y tamaño hogar") +
  theme_minimal(base_size = 12) +
  theme(axis.text.y = element_text(size = 11))

print(g9)

# Gráfico 10: Diagrama de Mediación (Resumen Visual)
g10 <- ggplot() +
  # Cajas
  annotate("rect", xmin = 0.5, xmax = 1.5, ymin = 1.7, ymax = 2.3, 
           fill = "#8B4513", alpha = 0.3, color = "#8B4513", linewidth = 1.5) +
  annotate("rect", xmin = 1.7, xmax = 2.3, ymin = 2.7, ymax = 3.3, 
           fill = "#2E86AB", alpha = 0.3, color = "#2E86AB", linewidth = 1.5) +
  annotate("rect", xmin = 2.5, xmax = 3.5, ymin = 1.7, ymax = 2.3, 
           fill = "#E63946", alpha = 0.3, color = "#E63946", linewidth = 1.5) +
  # Flechas
  annotate("segment", x = 1.5, xend = 1.7, y = 2.15, yend = 2.85, 
           arrow = arrow(length = unit(0.3, "cm")), linewidth = 1.2, color = "gray30") +
  annotate("segment", x = 2.3, xend = 2.5, y = 2.85, yend = 2.15, 
           arrow = arrow(length = unit(0.3, "cm")), linewidth = 1.2, color = "gray30") +
  annotate("segment", x = 1.5, xend = 2.5, y = 2, yend = 2, 
           arrow = arrow(length = unit(0.3, "cm")), linewidth = 1.2, 
           color = "gray30", linetype = "dashed") +
  # Etiquetas de cajas
  annotate("text", x = 1, y = 2, label = "ZONA\nRURAL", fontface = "bold", size = 4) +
  annotate("text", x = 2, y = 3, label = "EDUCACIÓN\n(Mediador)", fontface = "bold", size = 4) +
  annotate("text", x = 3, y = 2, label = "POBREZA", fontface = "bold", size = 4) +
  # Coeficientes
  annotate("text", x = 1.5, y = 2.7, label = paste0("a = ", round(a, 2)), size = 3.5, color = "gray30") +
  annotate("text", x = 2.5, y = 2.7, label = paste0("b = ", round(b, 2)), size = 3.5, color = "gray30") +
  annotate("text", x = 2, y = 1.7, label = paste0("c' = ", round(c_prime, 2), " (directo)"), 
           size = 3.5, color = "gray30") +
  # Resumen
  annotate("label", x = 2, y = 1.1, 
           label = paste0("Efecto indirecto (a×b) = ", round(efecto_indirecto, 2), 
                          "\nProporción mediada = ", round(prop_mediada, 1), "%",
                          "\nZ de Sobel = ", round(z_sobel, 1), " (p < 0.001)"),
           fill = "white", size = 3.5, label.size = 0.5) +
  scale_x_continuous(limits = c(0.3, 3.7)) +
  scale_y_continuous(limits = c(0.8, 3.5)) +
  labs(title = "Análisis de Mediación: Zona → Educación → Pobreza",
       subtitle = "La menor escolaridad rural explica ~45% del efecto de la zona sobre la pobreza",
       caption = "Fuente: CASEN 2022 - Jefes de hogar") +
  theme_void(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5, color = "gray40"),
    plot.caption = element_text(hjust = 1, color = "gray50")
  )

print(g10)

# ============================================================================
# EXPORTAR RESULTADOS
# ============================================================================

dir.create("resultados", showWarnings = FALSE)
dir.create("figuras", showWarnings = FALSE)

# Tablas CSV
write_csv(pobreza_region, "resultados/pobreza_por_region.csv")
write_csv(pobreza_area, "resultados/pobreza_por_area.csv")
write_csv(ingreso_sexo, "resultados/ingreso_por_sexo.csv")
write_csv(brecha_educ, "resultados/brecha_por_educacion.csv")
write_csv(brecha_edad, "resultados/brecha_por_edad.csv")

# Gráficos PNG
ggsave("figuras/g1_pobreza_region.png", g1, width = 10, height = 8, dpi = 300)
ggsave("figuras/g2_ingreso_educacion_sexo.png", g2, width = 10, height = 6, dpi = 300)
ggsave("figuras/g3_brecha_educacion.png", g3, width = 10, height = 6, dpi = 300)
ggsave("figuras/g4_pobreza_urbano_rural.png", g4, width = 8, height = 6, dpi = 300)
ggsave("figuras/g5_distribucion_ingreso_sexo.png", g5, width = 10, height = 6, dpi = 300)
ggsave("figuras/g6_escolaridad_zona.png", g6, width = 8, height = 6, dpi = 300)
ggsave("figuras/g7_pobreza_region_zona.png", g7, width = 12, height = 8, dpi = 300)
ggsave("figuras/g8_brecha_edad.png", g8, width = 10, height = 6, dpi = 300)
ggsave("figuras/g9_forest_plot_pobreza.png", g9, width = 10, height = 5, dpi = 300)
ggsave("figuras/g10_diagrama_mediacion.png", g10, width = 10, height = 7, dpi = 300)

cat("\n========== EXPORTACIÓN COMPLETADA ==========\n")
cat("Archivos CSV en: ./resultados/\n")
cat("Gráficos PNG en: ./figuras/\n")
