# Guia de Usuario de News Fetch

> Empieza en 3 minutos — deja que la IA te traiga tu resumen de noticias

Agotado de depurar? Tomate 2 minutos, ponte al dia con lo que pasa en el mundo y vuelve recargado.

---

## Instalacion

### Claude Code (recomendado)

```bash
claude plugin add juserch/jskills
```

### Instalacion universal en una linea

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/news-fetch/SKILL.md
```

> **Cero dependencias** — News Fetch no requiere servicios externos ni claves de API. Instala y listo.

---

## Comandos

| Comando | Que hace | Cuando usarlo |
|---------|----------|---------------|
| `/news-fetch AI` | Obtener noticias de IA de esta semana | Actualizacion rapida de la industria |
| `/news-fetch AI today` | Obtener noticias de IA de hoy | Resumen diario |
| `/news-fetch robotics month` | Obtener noticias de robotica de este mes | Revision mensual |
| `/news-fetch climate 2026-03-01~2026-03-31` | Obtener noticias de un rango de fechas especifico | Investigacion dirigida |

---

## Casos de uso

### Resumen tecnologico diario

```
/news-fetch AI today
```

Obtiene las ultimas noticias de IA del dia, ordenadas por relevancia. Escanea titulares y resumenes en segundos.

### Investigacion de la industria

```
/news-fetch electric vehicles 2026-03-01~2026-03-31
```

Obtiene noticias de un periodo especifico para apoyar analisis de mercado e investigacion competitiva.

### Noticias multilingues

Los temas en chino obtienen automaticamente busquedas complementarias en ingles para mayor cobertura, y viceversa. Obtienes lo mejor de ambos mundos sin esfuerzo adicional.

---

## Ejemplo de salida esperada

```markdown
## AI News

Monday, March 30, 2026

TOP 5

### 1. OpenAI Releases GPT-5 Multimodal Edition

**Reuters** | Relevance score: 223.0

OpenAI officially released GPT-5 with native video comprehension
and real-time voice conversation. Pricing is 40% lower than the
previous generation. The model surpasses its predecessor across
multiple benchmarks...

[Read more](https://example.com/article1)
Related coverage: [TechCrunch](https://example.com/a2) | [The Verge](https://example.com/a3)

### 2. CIX Tech Closes ~$140M Series B

**TechNode** | Relevance score: 118.0

CIX Tech closed a near-$140M Series B round and unveiled its first
agent-class CPU — the CIX ClawCore series, spanning low-power to
high-performance use cases...

[Read more](https://example.com/article2)

---
5 items total | Source: L1 WebSearch
```

---

## Estrategia de respaldo de 3 niveles

News Fetch tiene una estrategia de respaldo integrada para asegurar la obtencion de noticias en diferentes condiciones de red:

| Nivel | Herramienta | Fuente de datos | Activador |
|-------|-------------|-----------------|-----------|
| **L1** | WebSearch | Google/Bing | Por defecto (preferido) |
| **L2** | WebFetch | Baidu News, Sina, NetEase | L1 falla |
| **L3** | Bash curl | Mismas fuentes que L2 | L2 tambien falla |

Cuando todos los niveles fallan, se produce un informe de fallo estructurado que lista la razon de fallo de cada fuente.

---

## Caracteristicas de salida

| Caracteristica | Descripcion |
|----------------|-------------|
| **Deduplicacion** | Cuando multiples fuentes cubren el mismo evento, se mantiene la entrada con mayor puntuacion; las demas se agrupan en "Related coverage" |
| **Completado de resumen** | Si los resultados de busqueda carecen de resumen, se obtiene el cuerpo del articulo y se genera un resumen |
| **Puntuacion de relevancia** | La IA puntua cada resultado por relevancia al tema — mayor significa mas relevante |
| **Enlaces clicables** | Formato de enlace Markdown — clicables en IDEs y terminales |

---

## Preguntas frecuentes

### Necesito una clave de API?

No. News Fetch depende completamente de WebSearch y web scraping publico. Cero configuracion requerida.

### Puede obtener noticias en ingles?

Por supuesto. Los temas en chino incluyen automaticamente busquedas complementarias en ingles, y los temas en ingles funcionan nativamente. La cobertura abarca ambos idiomas.

### Que pasa si mi red esta restringida?

La estrategia de respaldo de 3 niveles lo maneja automaticamente. Incluso si WebSearch no esta disponible, News Fetch recurre a fuentes de noticias nacionales.

### Cuantos articulos devuelve?

Hasta 20 (despues de la deduplicacion). La cantidad real depende de lo que devuelvan las fuentes de datos.

---

## Licencia

[MIT](../../../../LICENSE) - [juserch](https://github.com/juserch)
