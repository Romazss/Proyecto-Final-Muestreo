# ============================================================================
# ANÁLISIS CASEN 2022 - CÓDIGO CONSOLIDADO
# Proyecto Final Muestreo (EYP2417)
# Autor: Esteban Román
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

# Opción A: Diseño simplificado (usado en este análisis)
diseno_casen <- svydesign(ids = ~1, weights = ~expr, data = jefes)
diseno_srvyr <- jefes %>% as_survey_design(weights = expr)

# Opción B: Diseño complejo (RECOMENDADO para producción)
# diseno_casen <- svydesign(
#   ids = ~varunit,
#   strata = ~varstrat,
#   weights = ~expr,
#   data = jefes,
#   nest = TRUE
# )

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

# Efecto total (c)
modelo_total <- svyglm(es_pobre ~ area, design = diseno_casen, family = quasibinomial())
c_total <- coef(modelo_total)["area"]
se_c <- summary(modelo_total)$coefficients["area", "Std. Error"]

# Efecto a: Zona → Educación
modelo_a <- svyglm(esc ~ area, design = diseno_casen)
a <- coef(modelo_a)["area"]
se_a <- summary(modelo_a)$coefficients["area", "Std. Error"]

# Efectos b y c': Educación → Pobreza controlando zona
modelo_bc <- svyglm(es_pobre ~ area + esc, design = diseno_casen, family = quasibinomial())
b <- coef(modelo_bc)["esc"]
se_b <- summary(modelo_bc)$coefficients["esc", "Std. Error"]
c_prime <- coef(modelo_bc)["area"]

# Test de Sobel
efecto_indirecto <- a * b
se_ab <- sqrt(a^2 * se_b^2 + b^2 * se_a^2)
z_sobel <- efecto_indirecto / se_ab
p_sobel <- 2 * (1 - pnorm(abs(z_sobel)))
prop_mediada <- efecto_indirecto / c_total * 100

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
    nivel_educ = case_when(
      esc <= 8 ~ "Básica",
      esc <= 12 ~ "Media",
      esc <= 16 ~ "Superior",
      esc > 16 ~ "Postgrado",
      TRUE ~ NA_character_
    ),
    nivel_educ = factor(nivel_educ, levels = c("Básica", "Media", "Superior", "Postgrado"))
  )

diseno_trabajo <- svydesign(ids = ~1, weights = ~expr, data = jefes_trabajo)
diseno_trabajo_srvyr <- jefes_trabajo %>% as_survey_design(weights = expr)

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

# Gráfico 1: Pobreza por Región
g1 <- ggplot(pobreza_region, aes(x = reorder(factor(region), prop_pobreza), 
                                 y = prop_pobreza)) +
  geom_col(fill = "#4A90D9", alpha = 0.8) +
  geom_errorbar(aes(ymin = prop_pobreza_low, ymax = prop_pobreza_upp), width = 0.2) +
  coord_flip() +
  scale_y_continuous(labels = percent_format()) +
  labs(title = "Incidencia de Pobreza por Región",
       subtitle = "CASEN 2022 - Jefes de Hogar",
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

# ============================================================================
# EXPORTAR RESULTADOS
# ============================================================================

dir.create("resultados", showWarnings = FALSE)
dir.create("figuras", showWarnings = FALSE)

write_csv(pobreza_region, "resultados/pobreza_por_region.csv")
write_csv(as.data.frame(pobreza_area), "resultados/pobreza_por_area.csv")
write_csv(brecha_educ, "resultados/brecha_por_educacion.csv")

ggsave("figuras/pobreza_region.png", g1, width = 10, height = 8, dpi = 300)
ggsave("figuras/brecha_educacion.png", g2, width = 10, height = 6, dpi = 300)
ggsave("figuras/brecha_porcentual.png", g3, width = 8, height = 6, dpi = 300)

cat("\n========== ANÁLISIS COMPLETADO ==========\n")
