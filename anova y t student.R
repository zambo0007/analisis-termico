# Instalar paquetes si es necesario
# install.packages("readxl")
# install.packages("dplyr")

library(readxl)
library(dplyr)

# Leer los datos
siembra <- read_excel("C:\\Users\\andy_\\Documents\\Desktop\\guipi\\prototipo dashboard camaras\\temperaturas camaras\\datos temperaturas.xlsx", sheet = "datos siembra")
hojas <- read_excel("C:\\Users\\andy_\\Documents\\Desktop\\guipi\\prototipo dashboard camaras\\temperaturas camaras\\datos temperaturas.xlsx", sheet = "datos hojas")

# Convertir fechas
siembra$Fecha <- as.POSIXct(siembra$Fecha)
hojas$FECHA <- as.POSIXct(hojas$FECHA)

# Filtrar el rango del 8 al 18 de septiembre
siembra_f <- filter(siembra, Fecha >= as.POSIXct("2024-09-08") & Fecha <= as.POSIXct("2024-09-18"))
hojas_f   <- filter(hojas,  FECHA >= as.POSIXct("2024-09-08") & FECHA <= as.POSIXct("2024-09-18"))


# Lista de pares a comparar
pares <- list(
  c("C1", "S1"), c("C2", "S2"), c("C3", "S3"), c("C4", "S4"),
  c("A1", "S9"), c("A2", "S10")
)

# Inicializar tabla de resultados
resultados <- data.frame(
  Par = character(),
  F_value = numeric(),
  p_anova = numeric(),
  t_stat = numeric(),
  p_t = numeric(),
  stringsAsFactors = FALSE
)

# Bucle de comparación
for (par in pares) {
  auto <- par[1]
  manual <- par[2]
  cat(paste0("\n### ", auto, " vs ", manual, " ###\n"))
  
  grupo1 <- siembra_f[[auto]]
  grupo2 <- hojas_f[[manual]]
  
  grupo1 <- grupo1[!is.na(grupo1)]
  grupo2 <- grupo2[!is.na(grupo2)]
  
  if (length(grupo1) > 2 & length(grupo2) > 2) {
    # Agrupar valores y etiquetas
    valores <- c(grupo1, grupo2)
    grupo <- factor(c(rep("Automatizado", length(grupo1)),
                      rep("Manual", length(grupo2))))
    
    # ANOVA
    modelo <- aov(valores ~ grupo)
    f_val <- summary(modelo)[[1]]$`F value`[1]
    p_val_anova <- summary(modelo)[[1]]$`Pr(>F)`[1]
    
    # t-test
    t_resultado <- t.test(grupo1, grupo2)
    
    # Guardar resultados
    resultados <- rbind(resultados, data.frame(
      Par = paste(auto, "vs", manual),
      F_value = round(f_val, 2),
      p_anova = round(p_val_anova, 4),
      t_stat = round(t_resultado$statistic, 2),
      p_t = round(t_resultado$p.value, 4)
    ))
    
    # Imprimir resultados
    print(summary(modelo))
    print(t_resultado)
  } else {
    cat("No hay suficientes datos en este par.\n")
  }
}

# Ver resultados finales
print(resultados)
