# News Fetch Kullanim Rehberi

> 3 dakikada basla -- AI'in senin icin haber ozeti getirsin

Hata ayiklamaktan tukendin mi? 2 dakika ayir, dunyada neler olup bittigine bak ve yenilenip geri don.

---

## Kurulum

### Claude Code (onerilen)

```bash
claude plugin add juserch/jskills
```

### Evrensel tek satirlik kurulum

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/news-fetch/SKILL.md
```

> **Sifir bagimlilik** -- News Fetch hicbir harici servise veya API anahtarina ihtiyac duymaz. Kur ve basla.

---

## Komutlar

| Komut | Ne yapar | Ne zaman kullanilir |
|-------|----------|---------------------|
| `/news-fetch AI` | Bu haftanin AI haberlerini getir | Hizli sektor guncelleme |
| `/news-fetch AI today` | Bugunun AI haberlerini getir | Gunluk ozet |
| `/news-fetch robotics month` | Bu ayin robotik haberlerini getir | Aylik inceleme |
| `/news-fetch climate 2026-03-01~2026-03-31` | Belirli tarih araligindaki haberleri getir | Hedefli arastirma |

---

## Kullanim Senaryolari

### Gunluk teknoloji ozeti

```
/news-fetch AI today
```

Bugunun en son AI haberlerini alintiyla sirali olarak al. Basliklari ve ozetleri saniyeler icinde tara.

### Sektor arastirmasi

```
/news-fetch electric vehicles 2026-03-01~2026-03-31
```

Pazar analizi ve rekabet arastirmasini desteklemek icin belirli bir zaman diliminin haberlerini cek.

### Cok dilli haberler

Cince konular otomatik olarak daha genis kapsam icin ek Ingilizce aramalar alir ve tam tersi de gecerlidir. Ekstra caba harcamadan her iki dunyanin en iyisini alirsin.

---

## Beklenen Cikti Ornegi

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

## 3 Katmanli Ag Yedekleme

News Fetch, farkli ag kosullarinda haber aliminin calismasini saglamak icin yerlesik yedekleme stratejisine sahiptir:

| Katman | Arac | Veri Kaynagi | Tetikleyici |
|--------|------|-------------|-------------|
| **L1** | WebSearch | Google/Bing | Varsayilan (tercih edilen) |
| **L2** | WebFetch | Baidu News, Sina, NetEase | L1 basarisiz |
| **L3** | Bash curl | L2 ile ayni kaynaklar | L2 de basarisiz |

Tum katmanlar basarisiz oldugunda, her kaynak icin basarisizlik nedenini listeleyen yapilandirilmis bir hata raporu uretilir.

---

## Cikti Ozellikleri

| Ozellik | Aciklama |
|---------|----------|
| **Tekillestime** | Birden fazla kaynak ayni olayi haberlestiginde, en yuksek puanli giris tutulur; digerleri "Related coverage" olarak daraltilir |
| **Ozet tamamlama** | Arama sonuclari ozet icermiyorsa, makale govdesi getirilir ve ozet olusturulur |
| **Alintilik puanlama** | AI, her sonucu konu alintiligina gore puanlar -- daha yuksek = daha ilgili |
| **Tiklanabilir baglantilar** | Markdown baglanti formati -- IDE'lerde ve terminallerde tiklanabilir |

---

## SSS

### API anahtarina ihtiyacim var mi?

Hayir. News Fetch tamamen WebSearch ve herkese acik web kazimaya dayanir. Sifir yapilandirma gerekir.

### Ingilizce haberleri getirebilir mi?

Kesinlikle. Cince konular otomatik olarak ek Ingilizce aramalar icerir ve Ingilizce konular dogal olarak calisir. Kapsam her iki dili de kapsar.

### Agim kisitliysa ne olur?

3 katmanli yedekleme stratejisi bunu otomatik olarak halleder. WebSearch kullanilamiyor olsa bile News Fetch yerel haber kaynaklarina geri doner.

### Kac makale dondurur?

En fazla 20 (tekillestime sonrasi). Gercek sayi, veri kaynaklarinin dondurdugune baglidir.

---

## Lisans

[MIT](../../../../LICENSE) - [juserch](https://github.com/juserch)
