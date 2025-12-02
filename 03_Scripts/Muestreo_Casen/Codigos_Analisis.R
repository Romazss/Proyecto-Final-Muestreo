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
# Cargar base (ajustar nombre si es necesario)
casen <- Base_de_datos_Casen_2022_STATA_18_marzo_2024

# Filtrar jefes de hogar
jefes <- casen %>%
  filter(pco1 == 1) %>%
  mutate(
    # Variables de pobreza (IMPORTANTE: pobreza 1,2 = pobre; 3 = no pobre)
    es_pobre = ifelse(pobreza %in% c(1, 2), 1, 0),
    es_pobre_extremo = ifelse(pobreza == 1, 1, 0)
  )

# Verificar creación de variables
cat("=== VERIFICACIÓN INICIAL ===\n")
cat("Total jefes de hogar:", nrow(jefes), "\n")
cat("Distribución pobreza:\n")
print(table(jefes$es_pobre, useNA = "ifany"))

# --- 2. DISEÑO MUESTRAL -----------------------------------------------------
diseno_casen <- svydesign(ids = ~1, weights = ~expr, data = jefes)
diseno_srvyr <- jefes %>% as_survey_design(weights = expr)

# ============================================================================
# EJE 1: DISTRIBUCIÓN DE LA POBREZA
# ============================================================================

# --- 1.1 Pobreza por Región -------------------------------------------------
cat("\n=== EJE 1: POBREZA ===\n")

pobreza_region <- diseno_srvyr %>%
  group_by(region) %>%
  summarise(
    prop_pobreza = survey_mean(es_pobre, vartype = c("se", "ci")),
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
    prop_pobreza = survey_mean(es_pobre, vartype = c("se", "ci")),
    n_expandido = survey_total(vartype = NULL)
  )

cat("\n--- Pobreza por Área ---\n")
print(pobreza_area)

# Test de diferencia
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

cat("\n--- Odds Ratios ---\n")
print(exp(cbind(OR = coef(modelo_pobreza), confint(modelo_pobreza))))

# --- 1.5 Análisis de Mediación ----------------------------------------------
cat("\n--- Análisis de Mediación: Zona → Educación → Pobreza ---\n")

modelo_total <- svyglm(es_pobre ~ area, design = diseno_casen, family = quasibinomial())
c_total <- coef(modelo_total)["area"]
se_c <- summary(modelo_total)$coefficients["area", "Std. Error"]

modelo_a <- svyglm(esc ~ area, design = diseno_casen)
a <- coef(modelo_a)["area"]
se_a <- summary(modelo_a)$coefficients["area", "Std. Error"]

modelo_bc <- svyglm(es_pobre ~ area + esc, design = diseno_casen, family = quasibinomial())
b <- coef(modelo_bc)["esc"]
se_b <- summary(modelo_bc)$coefficients["esc", "Std. Error"]
c_prime <- coef(modelo_bc)["area"]

efecto_indirecto <- a * b
se_ab <- sqrt(a^2 * se_b^2 + b^2 * se_a^2)
z_sobel <- efecto_indirecto / se_ab
p_sobel <- 2 * (1 - pnorm(abs(z_sobel)))

cat("Efecto total (c):", round(c_total, 4), "\n")
cat("Efecto indirecto (a × b):", round(efecto_indirecto, 4), "\n")
cat("Efecto directo (c'):", round(c_prime, 4), "\n")
cat("Z de Sobel:", round(z_sobel, 3), "\n")
cat("p-valor:", format(p_sobel, digits = 4), "\n")
cat("Proporción mediada:", round(efecto_indirecto / c_total * 100, 1), "%\n")

# ============================================================================
# EJE 2: BRECHA SALARIAL DE GÉNERO
# ============================================================================
cat("\n=== EJE 2: BRECHA SALARIAL ===\n")

# Filtrar jefes con ingreso laboral positivo
jefes_trabajo <- jefes %>%
  drop_na(ytrabajocorh) %>%
  filter(ytrabajocorh > 0) %>%
  mutate(
    sexo_label = ifelse(sexo == 1, "Hombre", "Mujer"),
    nivel_educ = case_when(
      esc <= 8 ~ "Básica",
      esc <= 12 ~ "Media",
      esc <= 16 ~ "Superior",
      esc > 16 ~ "Postgrado",
      TRUE ~ NA_character_
    ),
    nivel_educ = factor(nivel_educ, levels = c("Básica", "Media", "Superior", "Postgrado"))
  )

diseno_trabajo <- jefes_trabajo %>% as_survey_design(weights = expr)

# --- 2.1 Ingreso por Sexo ---------------------------------------------------
ingreso_sexo <- diseno_trabajo %>%
  group_by(sexo_label) %>%
  summarise(
    ingreso_medio = survey_mean(ytrabajocorh, vartype = c("se", "ci")),
    mediana = survey_median(ytrabajocorh, vartype = "ci"),
    n = unweighted(n())
  )

cat("\n--- Ingreso por Sexo ---\n")
print(ingreso_sexo)

# Calcular brecha
brecha <- ingreso_sexo %>%
  select(sexo_label, ingreso_medio) %>%
  pivot_wider(names_from = sexo_label, values_from = ingreso_medio) %>%
  mutate(brecha_pct = (Hombre - Mujer) / Hombre * 100)

cat("\n*** BRECHA SALARIAL DE GÉNERO:", round(brecha$brecha_pct, 1), "% ***\n")

# --- 2.2 Brecha por Nivel Educativo -----------------------------------------
brecha_educ <- diseno_trabajo %>%
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

# --- 2.3 Modelo Log-Lineal de Brecha ----------------------------------------
cat("\n--- Modelo de Regresión (log ingreso) ---\n")
modelo_brecha <- svyglm(
  log(ytrabajocorh) ~ factor(sexo) + esc + edad + I(edad^2),
  design = diseno_trabajo
)
print(summary(modelo_brecha))

dif_pct <- (exp(coef(modelo_brecha)["factor(sexo)2"]) - 1) * 100
cat("\n*** DIFERENCIA CONTROLADA (mujer vs hombre):", round(dif_pct, 1), "% ***\n")

# --- 2.4 Modelo Completo ----------------------------------------------------
cat("\n--- Modelo Completo con Ocupación ---\n")
modelo_completo_brecha <- svyglm(
  ytrabajocorh ~ sexo + esc + edad + factor(oficio4_08) + tot_per_h,
  design = svydesign(ids = ~1, weights = ~expr, data = jefes_trabajo)
)

coef_sexo <- summary(modelo_completo_brecha)$coefficients["sexo", ]
cat("β_sexo =", round(coef_sexo["Estimate"], 2), "\n")
cat("p-valor =", format(coef_sexo["Pr(>|t|)"], digits = 4), "\n")

if (coef_sexo["Pr(>|t|)"] < 0.05 & coef_sexo["Estimate"] < 0) {
  cat("CONCLUSIÓN: Se RECHAZA H0. Existe brecha salarial significativa contra las mujeres.\n")
} else {
  cat("CONCLUSIÓN: No se rechaza H0 al nivel 0.05.\n")
}

# ============================================================================
# COMPARACIÓN PONDERADO VS NO PONDERADO
# ============================================================================
cat("\n=== DEMOSTRACIÓN: SESGO POR NO PONDERAR ===\n")

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
  labs(title = "Ingreso por Nivel Educativo y Sexo",
       x = "Nivel Educativo", y = "Ingreso Promedio", fill = "Sexo") +
  theme_minimal(base_size = 12)

print(g2)

# Gráfico 3: Brecha porcentual
g3 <- brecha_educ %>%
  drop_na(nivel_educ) %>%
  ggplot(aes(x = nivel_educ, y = brecha_pct)) +
  geom_col(fill = "#E63946", alpha = 0.8) +
  geom_text(aes(label = paste0(round(brecha_pct, 1), "%")), vjust = -0.5) +
  labs(title = "Brecha Salarial por Nivel Educativo", x = "Nivel", y = "Brecha (%)") +
  theme_minimal()

print(g3)

# ============================================================================
# EXPORTAR RESULTADOS
# ============================================================================
dir.create("resultados", showWarnings = FALSE)
dir.create("figuras", showWarnings = FALSE)

write_csv(pobreza_region, "resultados/pobreza_por_region.csv")
write_csv(brecha_educ, "resultados/brecha_por_educacion.csv")

ggsave("figuras/pobreza_region.png", plot = g1, width = 10, height = 8, dpi = 300)
ggsave("figuras/brecha_educacion.png", plot = g2, width = 10, height = 6, dpi = 300)
ggsave("figuras/brecha_porcentual.png", plot = g3, width = 8, height = 6, dpi = 300)

cat("\n=== ANÁLISIS COMPLETADO ===\n")