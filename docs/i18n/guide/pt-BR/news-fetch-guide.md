# Guia do Usuario do News Fetch

> Comece em 3 minutos — deixe a IA buscar seu resumo de noticias

Esgotado de depurar? Tire 2 minutos, fique por dentro do que esta acontecendo no mundo e volte revigorado.

---

## Instalacao

### Claude Code (recomendado)

```bash
claude plugin add juserch/jskills
```

### Instalacao universal em uma linha

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/news-fetch/SKILL.md
```

> **Zero dependencias** — News Fetch nao requer servicos externos nem chaves de API. Instale e use.

---

## Comandos

| Comando | O que faz | Quando usar |
|---------|-----------|-------------|
| `/news-fetch AI` | Buscar noticias de IA desta semana | Atualizacao rapida da industria |
| `/news-fetch AI today` | Buscar noticias de IA de hoje | Resumo diario |
| `/news-fetch robotics month` | Buscar noticias de robotica deste mes | Revisao mensal |
| `/news-fetch climate 2026-03-01~2026-03-31` | Buscar noticias de um intervalo de datas especifico | Pesquisa direcionada |

---

## Casos de uso

### Resumo tecnologico diario

```
/news-fetch AI today
```

Obtem as ultimas noticias de IA do dia, ordenadas por relevancia. Escaneie manchetes e resumos em segundos.

### Pesquisa da industria

```
/news-fetch electric vehicles 2026-03-01~2026-03-31
```

Busca noticias de um periodo especifico para apoiar analise de mercado e pesquisa competitiva.

### Noticias multilinguais

Topicos em chines automaticamente recebem buscas complementares em ingles para maior cobertura, e vice-versa. Voce obtem o melhor dos dois mundos sem esforco adicional.

---

## Exemplo de saida esperada

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

## Estrategia de fallback de 3 niveis

News Fetch tem uma estrategia de fallback integrada para garantir a obtencao de noticias em diferentes condicoes de rede:

| Nivel | Ferramenta | Fonte de dados | Gatilho |
|-------|------------|----------------|---------|
| **L1** | WebSearch | Google/Bing | Padrao (preferido) |
| **L2** | WebFetch | Baidu News, Sina, NetEase | L1 falha |
| **L3** | Bash curl | Mesmas fontes do L2 | L2 tambem falha |

Quando todos os niveis falham, um relatorio de falha estruturado e produzido listando o motivo da falha de cada fonte.

---

## Caracteristicas da saida

| Caracteristica | Descricao |
|----------------|-----------|
| **Deduplicacao** | Quando multiplas fontes cobrem o mesmo evento, a entrada com maior pontuacao e mantida; as demais sao agrupadas em "Related coverage" |
| **Complemento de resumo** | Se os resultados da busca nao tiverem resumo, o corpo do artigo e obtido e um resumo e gerado |
| **Pontuacao de relevancia** | A IA pontua cada resultado por relevancia ao topico — maior significa mais relevante |
| **Links clicaveis** | Formato de link Markdown — clicaveis em IDEs e terminais |

---

## Perguntas frequentes

### Preciso de uma chave de API?

Nao. News Fetch depende inteiramente de WebSearch e web scraping publico. Zero configuracao necessaria.

### Consegue buscar noticias em ingles?

Com certeza. Topicos em chines incluem automaticamente buscas complementares em ingles, e topicos em ingles funcionam nativamente. A cobertura abrange ambos os idiomas.

### E se minha rede for restrita?

A estrategia de fallback de 3 niveis lida com isso automaticamente. Mesmo se o WebSearch nao estiver disponivel, o News Fetch recorre a fontes de noticias nacionais.

### Quantos artigos retorna?

Ate 20 (apos deduplicacao). A quantidade real depende do que as fontes de dados retornam.

---

## Licenca

[MIT](../../../../LICENSE) - [juserch](https://github.com/juserch)
