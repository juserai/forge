# Skill Lint Kullanim Rehberi

> 3 dakikada basla -- Claude Code skill kaliteni dogrula

---

## Kurulum

### Claude Code (onerilen)

```bash
claude plugin add juserch/jskills
```

### Evrensel tek satirlik kurulum

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/skill-lint/SKILL.md
```

> **Sifir bagimlilik** -- Skill Lint hicbir harici servise veya API'ye ihtiyac duymaz. Kur ve basla.

---

## Komutlar

| Komut | Ne yapar | Ne zaman kullanilir |
|-------|----------|---------------------|
| `/skill-lint` | Kullanim bilgisini goster | Mevcut kontrolleri gor |
| `/skill-lint .` | Mevcut projeyi lint'le | Gelistirme sirasinda kendi kendine kontrol |
| `/skill-lint /path/to/plugin` | Belirli bir yolu lint'le | Baska bir eklentiyi incele |

---

## Kullanim Senaryolari

### Yeni bir skill olusturduktan sonra kendi kendine kontrol

`skills/<name>/SKILL.md`, `commands/<name>.md` ve ilgili dosyalari olusturduktan sonra, yapinin tamam oldugundan, frontmatter'in dogru oldugunu ve marketplace girisinin eklendiginden emin olmak icin `/skill-lint .` calistir.

### Baska birinin eklentisini inceleme

Bir PR incelerken veya baska bir eklentiyi denetlerken, dosya tamligi ve tutarliligi icin hizli bir kontrol yapmak uzere `/skill-lint /path/to/plugin` kullan.

### CI entegrasyonu

`scripts/skill-lint.sh` dogrudan bir CI hattinda calistirilabilir ve otomatik ayristirma icin JSON cikti verir:

```bash
bash skills/skill-lint/scripts/skill-lint.sh /path/to/plugin
```

---

## Kontrol Maddeleri

### Yapisal Kontroller (Bash betigi tarafindan yurutulur)

| Kural | Ne kontrol eder | Ciddiyet |
|-------|----------------|----------|
| S01 | `plugin.json` hem kokte hem `.claude-plugin/` icinde var mi | error |
| S02 | `.claude-plugin/marketplace.json` var mi | error |
| S03 | Her `skills/<name>/` bir `SKILL.md` iceriyor mu | error |
| S04 | SKILL.md frontmatter'i `name` ve `description` iceriyor mu | error |
| S05 | Her skill'in karsilik gelen bir `commands/<name>.md` dosyasi var mi | warning |
| S06 | Her skill marketplace.json `plugins` dizisinde listelenmis mi | warning |
| S07 | SKILL.md'de atifta bulunulan references dosyalari gercekten var mi | error |
| S08 | `evals/<name>/scenarios.md` var mi | warning |

### Anlamsal Kontroller (AI tarafindan yurutulur)

| Kural | Ne kontrol eder | Ciddiyet |
|-------|----------------|----------|
| M01 | Aciklama amaci ve tetikleme kosullarini acikca belirtiyor mu | warning |
| M02 | Ad dizin adiyla eslesyor mu; aciklama dosyalar arasinda tutarli mi | warning |
| M03 | Komut yonlendirme mantigi skill adina dogru referans veriyor mu | warning |
| M04 | References icerigi SKILL.md ile mantiksal olarak tutarli mi | warning |
| M05 | Degerlendirme senaryolari temel islevsellik yollarini kapsiyor mu (en az 5) | warning |

---

## Beklenen Cikti Ornekleri

### Tum kontroller gecti

```
Skill Lint Complete
┌──────────────────┬───────────────────────────────────┐
│ Target path      │ /path/to/plugin               │
├──────────────────┼───────────────────────────────────┤
│ Structural checks│ ✓ 19 passed · ✗ 0 errors     │
├──────────────────┼───────────────────────────────────┤
│ Semantic checks  │ ✓ 5 passed · ⚠ 0 warnings    │
└──────────────────┴───────────────────────────────────┘
```

### Sorunlar bulundu

```
Skill Lint Complete
┌──────────────────┬───────────────────────────────────┐
│ Target path      │ /path/to/plugin               │
├──────────────────┼───────────────────────────────────┤
│ Structural checks│ ✓ 5 passed · ✗ 2 errors      │
├──────────────────┼───────────────────────────────────┤
│ Semantic checks  │ ✓ 3 passed · ⚠ 1 warning     │
└──────────────────┴───────────────────────────────────┘

Errors:
  1. skills/foo/SKILL.md: missing required field 'description'
  2. .claude-plugin/marketplace.json: skill 'foo' not listed

Warnings:
  1. skills/foo/SKILL.md: description does not match marketplace.json
```

---

## Is Akisi

```
/skill-lint [path]
      │
      ▼
  Run skill-lint.sh ──→ JSON structural check results
      │
      ▼
  AI reads skill files ──→ Semantic checks
      │
      ▼
  Merged output (error > warning > passed)
```

---

## SSS

### Anlamsal kontroller olmadan sadece yapisal kontrolleri calistirabilir miyim?

Evet -- bash betigini dogrudan calistir:

```bash
bash skills/skill-lint/scripts/skill-lint.sh .
```

Bu, AI anlamsal analizi olmadan saf JSON cikti verir.

### jskills olmayan projelerde calisiyor mu?

Evet. Standart Claude Code plugin yapisini (`skills/`, `commands/`, `.claude-plugin/`) takip eden herhangi bir dizin dogrulanabilir.

### Hatalar ve uyarilar arasindaki fark nedir?

- **error**: Skill'in yuklenmesini veya yayinlanmasini engelleyecek yapisal sorunlar
- **warning**: Islevsellik bozmayacak ama bakimi ve kesfedilebilirligi etkileyen kalite sorunlari

### Diger jskills araclari

Skill Lint, jskills koleksiyonunun bir parcasidir ve su skill'lerle birlikte iyi calisir:

- [Block Break](block-break-guide.md) -- AI'yi her yaklasimi tuketmeye zorlayan yuksek etkinlikli davranissal kisitlama motoru
- [Ralph Boost](ralph-boost-guide.md) -- Yerlesik Block Break yakinlasma garantileri ile otonom gelistirme dongu motoru

Yeni bir skill gelistirdikten sonra, yapisal tamligi dogrulamak ve frontmatter, marketplace.json ve referans baglantilarinin dogru oldugunu onaylamak icin `/skill-lint .` calistir.

---

## Lisans

[MIT](../../../../LICENSE) - [juserch](https://github.com/juserch)
