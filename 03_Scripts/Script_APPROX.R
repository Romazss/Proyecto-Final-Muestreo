# Librerías principales
library(tidyverse)    # Manipulación de datos
library(survey)       # Diseño muestral complejo
library(srvyr)        # Interfaz tidyverse para survey
library(haven)        # Lectura de archivos .dta/.sav
library(scales)       # Formateo de números
library(knitr)        # Tablas
library(gt)           # Tablas bonitas

# Suprimir warnings de versión de R (opcional)
options(warn = -1)

# Cargar datos (ajustar ruta o nombre del objeto según corresponda)
# Opción 1: Desde archivo .dta
# casen <- read_dta("ruta/completa/casen_2022.dta")

# Opción 2: Si ya está cargado en el environment
casen <- Base_de_datos_Casen_2022_STATA_18_marzo_2024

# Verificar nombres de variables disponibles
names(casen) %>% head(50)

# Filtrar jefes de hogar (pco1 == 1)
jefes <- casen %>%
  filter(pco1 == 1)

# Vista rápida de variables clave (verificar nombres correctos)
jefes %>%
  select(expr, region, sexo, pobreza, ytotcorh, ytrabajocorh, esc, edad, tot_per_h) %>%
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


# Crear variable dicotómica de pobreza (CORREGIDO)
jefes <- jefes %>%
  mutate(
    es_pobre = ifelse(pobreza %in% c(1, 2), 1, 0),
    es_pobre_extremo = ifelse(pobreza == 1, 1, 0)
  )

# Actualizar diseños con las nuevas variables
diseno_casen <- svydesign(
  ids = ~1,
  weights = ~expr,
  data = jefes
)

diseno_srvyr <- jefes %>%
  as_survey_design(weights = expr)


# PASO 1: Crear variables dicotómicas de pobreza (EJECUTAR PRIMERO)
jefes <- jefes %>%
  mutate(
    es_pobre = ifelse(pobreza %in% c(1, 2), 1, 0),
    es_pobre_extremo = ifelse(pobreza == 1, 1, 0)
  )

# Verificar que se crearon correctamente
table(jefes$es_pobre)  # Debería mostrar ~4700 pobres y ~67000 no pobres

# PASO 2: Actualizar diseños con las nuevas variables
diseno_casen <- svydesign(
  ids = ~1,
  weights = ~expr,
  data = jefes
)

diseno_srvyr <- jefes %>%
  as_survey_design(weights = expr)

# PASO 3: Calcular proporción de pobreza por región (ponderada)
pobreza_region <- diseno_srvyr %>%
  group_by(region) %>%
  summarise(
    prop_pobreza = survey_mean(es_pobre, vartype = c("se", "ci")),
    n = unweighted(n())
  ) %>%
  arrange(desc(prop_pobreza))

print(pobreza_region)

# Verificar codificación de area
table(jefes$area, useNA = "ifany")

# Proporción de pobreza por área (urbano/rural)
pobreza_area <- diseno_srvyr %>%
  mutate(area_label = ifelse(area == 1, "Urbano", "Rural")) %>%
  group_by(area_label) %>%
  summarise(
    prop_pobreza = survey_mean(es_pobre, vartype = c("se", "ci")),
    n_expandido = survey_total(vartype = NULL)
  )

print(pobreza_area)

# Test de diferencia de proporciones
test_area <- svyttest(es_pobre ~ factor(area), design = diseno_casen)
print(test_area)

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
  es_pobre ~ factor(area) + esc + tot_per_h + factor(region),
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

cat("Brecha salarial de género:", round(brecha$brecha_pct, 1), "%\n")

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

cat("Brecha salarial de género:", round(brecha$brecha_pct, 1), "%\n")


# Categorizar educación
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


# Formato chileno: punto como separador de miles, coma como decimal
formato_clp <- label_dollar(prefix = "$", big.mark = ".", decimal.mark = ",")

ggplot(brecha_educ %>% filter(!is.na(nivel_educ)), aes(x = nivel_educ)) +
  geom_col(aes(y = ingreso_medio_Hombre, fill = "Hombre"), 
           position = position_dodge(width = 0.8), width = 0.35, alpha = 0.8) +
  geom_col(aes(y = ingreso_medio_Mujer, fill = "Mujer"), 
           position = position_dodge(width = -0.8), width = 0.35, alpha = 0.8) +
  scale_y_continuous(labels = formato_clp) +
  scale_fill_manual(values = c("Hombre" = "#2E86AB", "Mujer" = "#A23B72")) +
  labs(
    title = "Ingreso Promedio del Trabajo por Sexo y Nivel Educativo",
    subtitle = "CASEN 2022 - Jefes de Hogar con Ingresos del Trabajo",
    x = "Nivel Educativo",
    y = "Ingreso Promedio (CLP)",
    fill = "Sexo",
    caption = "Fuente: Elaboración propia con datos CASEN 2022"
  ) +
  theme_minimal(base_size = 12) +
  theme(legend.position = "top")


# Formato chileno para números
formato_num <- function(x) format(x, big.mark = ".", decimal.mark = ",", scientific = FALSE)

# Ingreso promedio NO ponderado
media_no_pond <- mean(jefes$ytotcorh, na.rm = TRUE)

# Ingreso promedio ponderado (Horvitz-Thompson)
media_pond <- svymean(~ytotcorh, diseno_casen, na.rm = TRUE)

cat("Media NO ponderada:", formato_num(round(media_no_pond)), "\n")
cat("Media ponderada:", formato_num(round(coef(media_pond))), "\n")
cat("Diferencia relativa:", 
    round((coef(media_pond) - media_no_pond) / media_no_pond * 100, 2), "%\n")
