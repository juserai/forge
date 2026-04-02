# Ralph Boost Kullanim Rehberi

> 5 dakikada basla -- AI otonom gelistirme dongunu tikanmaktan koru

---

## Kurulum

### Claude Code (onerilen)

```bash
claude plugin add juserch/jskills
```

### Evrensel tek satirlik kurulum

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/ralph-boost/SKILL.md
```

> **Sifir bagimlilik** -- Ralph Boost, ralph-claude-code, block-break veya herhangi bir harici servise bagimli degildir. Birincil yol (Agent dongusu) sifir harici bagimliliktir; yedek yol `jq` veya `python` ve `claude` CLI gerektirir.

---

## Komutlar

| Komut | Ne yapar | Ne zaman kullanilir |
|-------|----------|---------------------|
| `/ralph-boost setup` | Projende otonom donguyu baslat | Ilk kurulum |
| `/ralph-boost run` | Mevcut oturumda otonom donguyu baslat | Baslatma sonrasi |
| `/ralph-boost status` | Mevcut dongu durumunu gor | Ilerlemeyi izle |
| `/ralph-boost clean` | Dongu dosyalarini temizle | Temizlik |

---

## Hizli Baslangic

### 1. Projeyi baslat

```text
/ralph-boost setup
```

Claude seni su adimlardan gecirecek:
- Proje adini algilama
- Gorev listesi olusturma (fix_plan.md)
- `.ralph-boost/` dizinini ve tum yapilandirma dosyalarini olusturma

### 2. Donguyu baslat

```text
/ralph-boost run
```

Claude, otonom donguyu dogrudan mevcut oturum icinde yurutur (Agent dongusu modu). Her iterasyonda bir gorevi yurutmek icin bir sub-agent olusturulur, ana oturum ise durumu yoneten dongu kontrolcusu olarak calisir.

**Yedek** (basiz / gozetimsiz ortamlar):

```bash
# On planda
bash ~/.claude/plugins/juserch_jskills/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project

# Arka planda
nohup bash ~/.claude/plugins/juserch_jskills/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project > /dev/null 2>&1 &
```

### 3. Durumu izle

```text
/ralph-boost status
```

Ornek cikti:

```
Ralph Boost Status
==================
Circuit Breaker:  HALF_OPEN
Pressure Level:   L2 Interrogation
Loop Count:       5
Tried Approaches: 3
Checklist:        2/7 completed
Last Updated:     2026-04-01T10:30:00Z

Tried Approaches:
  1. Fix JSON escape logic → Problem is not in escaping (loop 2)
  2. Upgrade jq version → Already latest (loop 3)
  3. Check upstream encoding → Found non-UTF-8 data (loop 4)

Checklist Progress:
  [x] read_error_signals
  [x] searched_core_problem
  [ ] read_source_context
  [ ] verified_assumptions
  [ ] tried_opposite_hypothesis
  [ ] minimal_reproduction
  [ ] switched_tool_or_method
```

---

## Nasil Calisir

### Otonom Dongu

Ralph Boost iki calistirma yolu sunar:

**Birincil yol (Agent dongusu)**: Claude, mevcut oturum icinde dongu kontrolcusu olarak calisir ve her iterasyonda gorevleri yurutmek icin bir sub-agent olusturur. Ana oturum durumu, devre kesiciyi ve baski yukseltmeyi yonetir. Sifir harici bagimlilik.

**Yedek (bash betigi)**: `boost-loop.sh`, arka planda bir dongude `claude -p` cagrilari calistirir. JSON motoru olarak hem jq hem python destekler, calisma zamaninda otomatik algilanir. Iterasyonlar arasi varsayilan bekleme suresi 1 saattir (yapilandirilabilir).

Her iki yol da ayni durum yonetimini (state.json), baski yukseltme mantigini ve BOOST_STATUS protokolunu paylasir.

```
Read task → Execute → Detect progress → Adjust strategy → Report → Next iteration
```

### Gelistirilmis Devre Kesici (ralph-claude-code ile karsilastirma)

ralph-claude-code'un devre kesicisi: ilerleme olmadan 3 ardisik donguden sonra pes eder.

ralph-boost'un devre kesicisi: tikandiginda **baski kademeli olarak yukseltir**, durmadan once 6-7 donguye kadar kendini kurtarma.

```
Progress detected → L0 (reset, continue normal work)

No progress:
  1 loop  → L1 Disappointment (force approach switch)
  2 loops → L2 Interrogation (read error word-by-word + search source + list 3 hypotheses)
  3 loops → L3 Performance Review (complete 7-point checklist)
  4 loops → L4 Graduation (minimal PoC + write handoff report)
  5+ loops → Graceful shutdown (with structured handoff report)
```

---

## Beklenen Cikti Ornekleri

### L0 -- Normal Calistirma

```
---BOOST_STATUS---
STATUS: IN_PROGRESS
TASKS_COMPLETED_THIS_LOOP: 1
FILES_MODIFIED: 3
TESTS_STATUS: PASSING
WORK_TYPE: IMPLEMENTATION
EXIT_SIGNAL: false
PRESSURE_LEVEL: L0
TRIED_COUNT: 0
RECOMMENDATION:
  CURRENT_APPROACH: Implemented user authentication middleware
  RESULT: All tests passing, middleware integrated
  NEXT_APPROACH: Add rate limiting to auth endpoints
---END_BOOST_STATUS---
```

### L1 -- Yaklasim Degisimi

```
[boost-loop.sh] Circuit breaker: CLOSED | L1 Disappointment | 1 loop without progress

Context injected:
"Loop #3. Pressure: L1 Disappointment. The team next door got it on the first try.
 Tried approaches: 1. MANDATORY: Switch to a fundamentally different approach."
```

Claude, onceki yaklasimi terk etmeye ve **temelden farkli** bir sey denemeye zorlanir. Parametre ayarlamasi sayilmaz.

### L2 -- Arama ve Hipotez Olusturma

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L2 Interrogation | 2 loops without progress

Context injected:
"Loop #4. Pressure: L2 Interrogation. What is the underlying logic? Where is the leverage point?
 Tried approaches: 2. MANDATORY: Read the error word-by-word. Search 50+ lines of context.
 List 3 fundamentally different hypotheses."
```

Claude sunlari yapmak zorundadir: hatayi kelime kelime oku -> 50+ satir baglam ara -> 3 farkli hipotez listele.

### L3 -- Kontrol Listesi

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L3 Performance Review | 3 loops without progress
```

Claude, 7 maddelik kontrol listesini tamamlamak zorundadir (hata sinyallerini oku, temel sorunu ara, kaynagi oku, varsayimlari dogrula, hipotezi tersine cevir, minimal yeniden uretim, arac/yontem degistir). Tamamlanan her madde state.json'a yazilir.

### L4 -- Zarif Devir

```
[boost-loop.sh] Circuit breaker: CLOSED | L4 Graduation | L4 active, waiting for handoff report
```

Claude minimal bir PoC olusturur, ardindan bir devir raporu uretir:

```markdown
# Handoff Report

**Task**: Fix SSL handshake failure in production
**Loops attempted**: 6
**Final pressure**: L4

## Verified Facts
- OpenSSL 3.x incompatible with legacy TLS 1.0 endpoints
- Server certificate chain is valid (verified with openssl s_client)

## Excluded Possibilities
- Client-side TLS config: Verified correct (evidence: curl with same config works on OpenSSL 1.x)
- Certificate expiry: Verified not expired (evidence: openssl x509 -enddate)

## Narrowed Problem Scope
Issue is specifically in OpenSSL 3.x's removal of legacy TLS renegotiation support.
Requires system-level OpenSSL configuration change or server-side TLS upgrade.

## Recommended Next Steps
1. Contact server team to upgrade TLS to 1.2+
2. Or configure OpenSSL 3.x legacy provider: openssl.cnf [provider_sect]
```

Devir tamamlandiktan sonra dongu zarif bir sekilde kapanir. Bu "yapamiyorum" degil -- "sinir burada"dir.

---

## Yapilandirma

`.ralph-boost/config.json`:

| Alan | Varsayilan | Aciklama |
|------|-----------|----------|
| `max_calls_per_hour` | 100 | Saatte maksimum Claude API cagrisi |
| `claude_timeout_minutes` | 15 | Bireysel cagri basina zaman asimi |
| `allowed_tools` | Write, Read, Edit, Bash, Glob, Grep | Claude'un kullanabilecegi araclar |
| `claude_model` | "" | Model gecersiz kilma (bos = varsayilan) |
| `session_expiry_hours` | 24 | Oturum sona erme suresi |
| `no_progress_threshold` | 7 | Kapatma oncesi ilerleme yok esigi |
| `same_error_threshold` | 8 | Kapatma oncesi ayni hata esigi |
| `sleep_seconds` | 3600 | Iterasyonlar arasi bekleme suresi (saniye) |

### Yaygin yapilandirma ayarlari

**Donguyu hizlandir** (test icin):

```json
{
  "sleep_seconds": 60,
  "claude_timeout_minutes": 5
}
```

**Arac izinlerini kisitla**:

```json
{
  "allowed_tools": ["Read", "Glob", "Grep"]
}
```

**Belirli bir model kullan**:

```json
{
  "claude_model": "claude-sonnet-4-6"
}
```

---

## Proje Dizin Yapisi

```
.ralph-boost/
├── PROMPT.md           # Gelistirici talimatlari (block-break protokolunu icerir)
├── fix_plan.md         # Gorev listesi (Claude tarafindan otomatik guncellenir)
├── config.json         # Yapilandirma
├── state.json          # Birlesik durum (devre kesici + baski + oturum)
├── handoff-report.md   # L4 devir raporu (zarif cikista olusturulur)
├── logs/
│   ├── boost.log       # Dongu logu
│   └── claude_output_*.log  # Iterasyon basina cikti
└── .gitignore          # Durum ve loglari yok sayar
```

Tum dosyalar `.ralph-boost/` icinde kalir -- proje kok dizinine dokunulmaz.

---

## ralph-claude-code ile Iliski

Ralph Boost, [ralph-claude-code](https://github.com/frankbria/ralph-claude-code) icin bir gelistirme eklentisi degil, **bagimsiz bir alternatiftir**.

| Unsur | ralph-claude-code | ralph-boost |
|-------|-------------------|-------------|
| Bici | Bagimsiz Bash araci | Claude Code skill (Agent dongusu) |
| Kurulum | `npm install` | Claude Code plugin |
| Kod boyutu | 2000+ satir | ~400 satir |
| Harici bagimliliklar | jq (zorunlu) | Birincil yol: sifir; Yedek: jq veya python |
| Dizin | `.ralph/` | `.ralph-boost/` |
| Devre kesici | Pasif (3 donguden sonra pes eder) | Aktif (L0-L4, 6-7 dongu kendini kurtarma) |
| Birlikte var olma | Evet | Evet (sifir dosya catismasi) |

Her ikisi de ayni projede ayni anda kurulabilir -- ayri dizinler kullanirlar ve birbirlerini etkilemezler.

---

## Block Break ile Iliski

Ralph Boost, Block Break'in temel mekanizmalarini (baski yukseltme, 5 adimlik metodoloji, kontrol listesi) otonom dongu senaryolarina uyarlar:

| Unsur | block-break | ralph-boost |
|-------|-------------|-------------|
| Senaryo | Interaktif oturumlar | Otonom donguler |
| Etkinlestirme | Hook'lar otomatik tetikler | Agent dongusune / dongu betigine gomulu |
| Algilama | PostToolUse hook | Agent dongusu ilerleme algilama / betik ilerleme algilama |
| Kontrol | Hook ile enjekte edilen prompt'lar | Agent prompt enjeksiyonu / --append-system-prompt |
| Durum | `~/.juserch-skills/` | `.ralph-boost/state.json` |

Kod tamamen bagimsizdir; kavramlar ortaktir.

> **Referans**: Block Break'in baski yukseltme (L0-L4), 5 adimlik metodoloji ve 7 maddelik kontrol listesi, ralph-boost'un devre kesicisinin kavramsal temelini olusturur. Ayrintilar icin [Block Break Kullanim Rehberi](block-break-guide.md)'ne bak.

---

## SSS

### Birincil yol ile yedek arasinda nasil secerim?

`/ralph-boost run` varsayilan olarak Agent dongusunu (birincil yol) kullanir ve dogrudan mevcut Claude Code oturumunda calisir. Basiz veya gozetimsiz calistirma gerektiginde yedek bash betigini kullan.

### Dongu betigi nerede?

jskills eklentisini kurduktan sonra, yedek betik `~/.claude/plugins/juserch_jskills/skills/ralph-boost/scripts/boost-loop.sh` konumundadir. Istedigin yere kopyalayip oradan calistirabilirsin. Betik, JSON motoru olarak jq veya python'u otomatik algilar.

### Dongu loglarini nasil goruntulerim?

```bash
tail -f .ralph-boost/logs/boost.log
```

### Baski seviyesini manuel olarak nasil sifirlarim?

`.ralph-boost/state.json` dosyasini duzenle: `pressure.level` degerini 0'a ve `circuit_breaker.consecutive_no_progress` degerini 0'a ayarla. Ya da state.json dosyasini silip yeniden baslat.

### Gorev listesini nasil degistiririm?

`.ralph-boost/fix_plan.md` dosyasini dogrudan duzenle, `- [ ] task` formatini kullan. Claude her iterasyonun basinda bunu okur.

### Devre kesici actiktan sonra nasil kurtaririm?

`state.json` dosyasini duzenle, `circuit_breaker.state` degerini `"CLOSED"` olarak ayarla, ilgili sayaclari sifirla ve betigi yeniden calistir.

### ralph-claude-code'a ihtiyacim var mi?

Hayir. Ralph Boost tamamen bagimsizdir ve hicbir Ralph dosyasina bagimli degildir.

### Hangi platformlar destekleniyor?

Su anda Claude Code destekleniyor (Agent dongusu birincil yol). Yedek bash betigi bash 4+, jq veya python ve claude CLI gerektirir.

### ralph-boost'un skill dosyalarini nasil dogrularim?

[Skill Lint](skill-lint-guide.md) kullan: `/skill-lint .`

---

## Lisans

[MIT](../../../../LICENSE) - [juserch](https://github.com/juserch)
