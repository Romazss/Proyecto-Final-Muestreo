Sys.setlocale("LC_ALL", "es_ES.UTF-8")
install.packages("srvyr")
install.packages("gt")


# Librerías principales
library(tidyverse)    # Manipulación de datos
library(survey)       # Diseño muestral complejo
library(srvyr)        # Interfaz tidyverse para survey
library(haven)        # Lectura de archivos .dta/.sav
library(scales)       # Formateo de números
library(knitr)        # Tablas
library(gt)           # Tablas bonitas


# Cargar datos (ajustar ruta según corresponda)
casen <- read_dta("casen_2022.dta")

# Filtrar jefes de hogar (pco1 == 1)
jefes <- casen %>%
  filter(pco1 == 1)

# Vista rápida de variables clave
jefes %>%
  select(expr, region, zona, sexo, pobreza, ytotcorh, ytrabajocorh, esc, edad) %>%
  glimpse()


# Definir diseño muestral con survey
diseno_casen <- svydesign(
  ids = ~1,              # Sin información de cluster disponible
  weights = ~expr,       # Factor de expansión
  data = jefes
)

# Alternativa con srvyr (más amigable con tidyverse)
diseno_srvyr <- jefes %>%
  as_survey_design(weights = expr)

# Definir diseño muestral con survey
diseno_casen <- svydesign(
  ids = ~1,              # Sin información de cluster disponible
  weights = ~expr,       # Factor de expansión
  data = jefes
)

# Alternativa con srvyr (más amigable con tidyverse)
diseno_srvyr <- jefes %>%
  as_survey_design(weights = expr)


# Crear variable dicotómica de pobreza
jefes <- jefes %>%
  mutate(
    es_pobre = ifelse(pobreza %in% c(2, 3), 1, 0),
    es_pobre_extremo = ifelse(pobreza == 3, 1, 0)
  )

# Actualizar diseño
diseno_srvyr <- jefes %>%
  as_survey_design(weights = expr)

# Proporción de pobreza por región (ponderada)
pobreza_region <- diseno_srvyr %>%
  group_by(region) %>%
  summarise(
    prop_pobreza = survey_mean(es_pobre, vartype = c("se", "ci")),
    n = unweighted(n())
  ) %>%
  arrange(desc(prop_pobreza))

print(pobreza_region)


# Proporción de pobreza por zona
pobreza_zona <- diseno_srvyr %>%
  mutate(zona_label = ifelse(zona == 1, "Urbano", "Rural")) %>%
  group_by(zona_label) %>%
  summarise(
    prop_pobreza = survey_mean(es_pobre, vartype = c("se", "ci")),
    n_expandido = survey_total(vartype = NULL)
  )

print(pobreza_zona)

# Test de diferencia de proporciones
test_zona <- svyttest(es_pobre ~ factor(zona), design = diseno_casen)
print(test_zona)

# Ingreso promedio por tamaño del hogar
ingreso_tamano <- diseno_srvyr %>%
  mutate(tamano_hogar = cut(tot_per_h, 
                            breaks = c(0, 1, 2, 4, Inf),
                            labels = c("1 persona", "2 personas", 
                                       "3-4 personas", "5+ personas"))) %>%
  group_by(tamano_hogar) %>%
  summarise(
    ingreso_medio = survey_mean(ytotcorh, vartype = c("se", "ci"), na.rm = TRUE)
  )

print(ingreso_tamano)


# Modelo logístico ponderado
modelo_pobreza <- svyglm(
  es_pobre ~ factor(zona) + esc + tot_per_h + factor(region),
  design = diseno_casen,
  family = quasibinomial()
)

summary(modelo_pobreza)

# Odds ratios con IC 95%
exp(cbind(OR = coef(modelo_pobreza), confint(modelo_pobreza)))

# Filtrar jefes con ingresos positivos y sin NA
jefes_trabajo <- jefes %>%
  drop_na(ytrabajocorh) %>%
  filter(ytrabajocorh > 0)

diseno_trabajo <- jefes_trabajo %>%
  as_survey_design(weights = expr)

# Ingreso promedio por sexo
ingreso_sexo <- diseno_trabajo %>%
  mutate(sexo_label = ifelse(sexo == 1, "Hombre", "Mujer")) %>%
  group_by(sexo_label) %>%
  summarise(
    ingreso_medio = survey_mean(ytrabajocorh, vartype = c("se", "ci")),
    mediana = survey_median(ytrabajocorh, vartype = "ci"),
    n = unweighted(n())
  )

print(ingreso_sexo)

# Calcular brecha porcentual
brecha <- ingreso_sexo %>%
  select(sexo_label, ingreso_medio) %>%
  pivot_wider(names_from = sexo_label, values_from = ingreso_medio) %>%
  mutate(brecha_pct = (Hombre - Mujer) / Hombre * 100)

cat("Brecha salarial de genero:", round(brecha$brecha_pct, 1), "%\n")

# Categorizar educacion
jefes_trabajo <- jefes_trabajo %>%
  mutate(
    nivel_educ = case_when(
      esc <= 8 ~ "Básica",
      esc <= 12 ~ "Media",
      esc <= 16 ~ "Superior",
      esc > 16 ~ "Postgrado",
      TRUE ~ NA_character_
    ),
    nivel_educ = factor(nivel_educ, 
                        levels = c("Básica", "Media", "Superior", "Postgrado"))
  )

diseno_trabajo <- jefes_trabajo %>%
  as_survey_design(weights = expr)

# Brecha por nivel educativo
brecha_educ <- diseno_trabajo %>%
  mutate(sexo_label = ifelse(sexo == 1, "Hombre", "Mujer")) %>%
  group_by(nivel_educ, sexo_label) %>%
  summarise(
    ingreso_medio = survey_mean(ytrabajocorh, vartype = "se", na.rm = TRUE)
  ) %>%
  pivot_wider(
    names_from = sexo_label,
    values_from = c(ingreso_medio, ingreso_medio_se)
  ) %>%
  mutate(
    brecha_pct = (ingreso_medio_Hombre - ingreso_medio_Mujer) / 
      ingreso_medio_Hombre * 100
  )

print(brecha_educ)


# Modelo con log del ingreso
modelo_brecha <- svyglm(
  log(ytrabajocorh) ~ factor(sexo) + esc + edad + I(edad^2),
  design = svydesign(ids = ~1, weights = ~expr, data = jefes_trabajo)
)

summary(modelo_brecha)

# Interpretación: coef de sexo = diferencia % aproximada
cat("\nDiferencia estimada (mujer vs hombre):", 
    round((exp(coef(modelo_brecha)["factor(sexo)2"]) - 1) * 100, 1), "%\n")

# Modelo incluyendo ocupación
modelo_completo <- svyglm(
  log(ytrabajocorh) ~ factor(sexo) + esc + edad + I(edad^2) + 
    factor(oficio4_08) + factor(region),
  design = svydesign(ids = ~1, weights = ~expr, data = jefes_trabajo)
)

summary(modelo_completo)


ggplot(pobreza_region, aes(x = reorder(factor(region), prop_pobreza), 
                           y = prop_pobreza)) +
  geom_col(fill = "#4A90D9", alpha = 0.8) +
  geom_errorbar(aes(ymin = prop_pobreza_low, ymax = prop_pobreza_upp), 
                width = 0.2) +
  coord_flip() +
  scale_y_continuous(labels = percent_format()) +
  labs(
    title = "Incidencia de Pobreza por Región",
    subtitle = "CASEN 2022 - Jefes de Hogar",
    x = "Región",
    y = "Proporción en Pobreza",
    caption = "Fuente: Elaboración propia con datos CASEN 2022\nBarras de error: IC 95%"
  ) +
  theme_minimal(base_size = 12)