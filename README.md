# Comparación de Temperatura: Sistema Manual vs Automatizado 🍄🌡️

Este repositorio contiene el análisis estadístico y visual de las temperaturas registradas en el proceso de producción de **Agaricus bisporus**, comparando dos métodos de monitoreo:

- **Sistema automatizado** (sensores digitales tipo DS18B20 conectados a Arduino)
- **Sistema manual** (lecturas operativas ingresadas por personal técnico)

---

## 📁 Contenido

- `grafico_temperaturas.R`: Código en R para generar gráficos de caja comparativos por cama y aire.
- `resultados_anova_ttest.xlsx`: Resultados del análisis estadístico (ANOVA y t de Student).
- `datos temperaturas.xlsx`: Datos originales utilizados, organizados por sensores, camas y fechas.
- `grafico_temperatura.png/pdf`: Gráfico comparativo de temperatura por cama y aire.
- `README.md`: Este documento.

---

## 📊 Objetivo

Evaluar si existen diferencias significativas entre los métodos de medición y evidenciar la capacidad del sistema automatizado para capturar mejor la variabilidad térmica durante el cultivo.

---

## 📈 Resultados

Se aplicaron:
- **ANOVA de un factor**: para evaluar diferencias en distribución
- **Prueba t de Student**: para comparar promedios entre sensores manuales y automatizados
- **Boxplots**: para visualizar la dispersión de temperatura por cama y por aire
---

## ▶️ Cómo reproducir

1. Abre el archivo `grafico_temperaturas.R` en RStudio.
2. Asegúrate de instalar las siguientes librerías:

r
`install.packages(c("readxl", "dplyr", "tidyr", "ggplot2"))`

3. Ajusta la ruta del archivo Excel si es necesario.
