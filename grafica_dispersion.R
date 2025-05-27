# Cargar librerías
library(ggplot2)
library(dplyr)
library(readxl)
library(tidyr)

# Ruta del archivo
ruta <- "C:\\Users\\andy_\\Documents\\Desktop\\guipi\\prototipo dashboard camaras\\temperaturas camaras\\datos temperaturas.xlsx"
# Leer hojas
datos_auto <- read_excel(ruta, sheet = "datos siembra")
datos_manual <- read_excel(ruta, sheet = "datos hojas")

# Limpiar nombres
names(datos_auto) <- trimws(names(datos_auto))
names(datos_manual)   <- trimws(names(datos_manual))

# Convertir primero el campo de fecha a Date en ambas tablas
datos_auto$Fecha <- as.Date(datos_auto$Fecha)
datos_manual$FECHA <- as.Date(datos_manual$FECHA)

# Luego ejecutar el filtrado con pivot_longer correctamente
auto_estad <- datos_auto %>%
  filter(Fecha == fecha_objetivo) %>%
  select(C1, C2, C3, C4) %>%
  pivot_longer(cols = everything(), names_to = "Cama", values_to = "Temperatura") %>%
  mutate(Metodo = "Automatizado")

manual_estad <- datos_manual %>%
  filter(FECHA == fecha_objetivo) %>%
  select(S1, S2, S3, S4) %>%
  rename(C1 = S1, C2 = S2, C3 = S3, C4 = S4) %>%
  pivot_longer(cols = everything(), names_to = "Cama", values_to = "Temperatura") %>%
  mutate(Metodo = "Manual")

# Unir los datos
datos_comb <- bind_rows(auto_estad, manual_estad)

# Crear gráfico
grafico <- ggplot(datos_comb, aes(x = Cama, y = Temperatura, color = Metodo)) +
  geom_jitter(position = position_jitterdodge(jitter.width = 0.2), alpha = 0.7, size = 2) +
  scale_color_manual(values = c("Automatizado" = "#ff7f0e", "Manual" = "#1f77b4")) +
  labs(y = "Temperatura (°F)",
       x = "Cama") +
  theme_minimal() +
  theme(
    axis.line.x = element_line(color = "black", linewidth = 0.6),
    axis.line.y = element_line(color = "black", linewidth = 0.6),
  )


# Guardar como PDF (vectorial, ideal para LaTeX)
ggsave("grafico_temperaturas.pdf", plot = grafico, width = 10, height = 6)
