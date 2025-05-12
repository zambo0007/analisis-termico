# Instalar si es necesario
# install.packages("readxl")
# install.packages("dplyr")
# install.packages("tidyr")
# install.packages("ggplot2")

library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)

# Ruta del archivo
ruta <- "C:\\Users\\andy_\\Documents\\Desktop\\guipi\\prototipo dashboard camaras\\temperaturas camaras\\datos temperaturas.xlsx"
# Leer hojas
siembra <- read_excel(ruta, sheet = "datos siembra")
hojas <- read_excel(ruta, sheet = "datos hojas")

# Limpiar nombres
names(siembra) <- trimws(names(siembra))
names(hojas)   <- trimws(names(hojas))

# Convertir fechas
siembra$Fecha <- as.POSIXct(siembra$Fecha)
hojas$FECHA <- as.POSIXct(hojas$FECHA)

# Filtrar fechas del 8 al 18 de septiembre
siembra_f <- filter(siembra, Fecha >= as.POSIXct("2024-09-08") & Fecha <= as.POSIXct("2024-09-18"))
hojas_f   <- filter(hojas, FECHA >= as.POSIXct("2024-09-08") & FECHA <= as.POSIXct("2024-09-18"))

# Crear tabla larga para automatizado
auto_df <- siembra_f %>%
  select(C1, C2, C3, C4, A1, A2) %>%
  pivot_longer(cols = everything(), names_to = "Sensor", values_to = "Temperatura") %>%
  mutate(Metodo = "Automatizado")

# Crear tabla larga para manual
manual_df <- hojas_f %>%
  select(S1, S2, S3, S4, S9, S10) %>%
  pivot_longer(cols = everything(), names_to = "Sensor", values_to = "Temperatura") %>%
  mutate(Metodo = "Manual")

# Unir ambas
datos_long <- bind_rows(auto_df, manual_df)

# Clasificar ubicación
datos_long <- datos_long %>%
  mutate(
    Ubicacion = ifelse(Sensor %in% c("A1", "A2", "S9", "S10"), "Aire", "Cama"),
    Sensor = factor(Sensor, levels = c("C1", "S1", "C2", "S2", "C3", "S3", "C4", "S4", "A1", "S9", "A2", "S10"))
  )


# Crear boxplot con ggplot2
grafico <- ggplot(datos_long, aes(x = Sensor, y = Temperatura, fill = Metodo)) +
  geom_boxplot() +
  scale_fill_manual(values = c("Automatizado" = "#1f77b4", "Manual" = "#ff7f0e")) +
  labs(
    title = "Distribución de temperatura por sensor y método (8–18 septiembre)",
    x = "Sensor",
    y = "Temperatura (°C)"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
# Crear gráfico con ggplot2
grafico <- ggplot(datos_long, aes(x = Sensor, y = Temperatura, fill = Metodo)) +
  geom_boxplot() +
  scale_fill_manual(values = c("Automatizado" = "#1f77b4", "Manual" = "#ff7f0e")) +
  labs(
    title = "Distribución de temperatura por sensor y método (8–18 septiembre)",
    x = "Sensor",
    y = "Temperatura (°C)"
  ) +
  theme_minimal() +
  theme(
    text = element_text(size = 12),
    axis.text.x = element_text(size = 11),
    legend.position = "bottom",
    legend.box = "horizontal",
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 10)
  )
# Guardar como PDF (vectorial, ideal para LaTeX)
ggsave("grafico_temperaturas.pdf", plot = grafico, width = 10, height = 6)

