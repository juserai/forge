# Block Break Kullanim Rehberi

> 5 dakikada basla -- AI agent'inin her yaklasimi tuketmesini sagla

---

## Kurulum

### Claude Code (onerilen)

```bash
claude plugin add juserch/jskills
```

### Evrensel tek satirlik kurulum

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/block-break/SKILL.md
```

> **Sifir bagimlilik** -- Block Break hicbir harici servise veya API'ye ihtiyac duymaz. Kur ve basla.

---

## Komutlar

| Komut | Ne yapar | Ne zaman kullanilir |
|-------|----------|---------------------|
| `/block-break` | Block Break motorunu etkinlestir | Gunluk gorevler, hata ayiklama |
| `/block-break L2` | Belirli bir baski seviyesinde basla | Bilinen birden fazla basarisizliktan sonra |
| `/block-break fix the bug` | Etkinlestir ve gorevi hemen calistir | Gorevle hizli baslangic |

### Dogal dil tetikleyicileri (hook'lar tarafindan otomatik algilanir)

| Dil | Tetikleyici ifadeler |
|-----|----------------------|
| Ingilizce | `try harder` `figure it out` `stop giving up` `you keep failing` `stop spinning` `you broke it` |
| Cince | `又错了` `别偷懒` `为什么还不行` `降智了` `原地打转` `换个方法` `加油` `再试试` |

---

## Kullanim Senaryolari

### AI 3 denemeden sonra hatayi duzeltemediyse

`/block-break` yaz veya `try harder` de -- otomatik olarak baski yukseltme moduna girer.

### AI "muhtemelen ortam sorunu" deyip duruyorsa

Block Break'in "Veri odakli" kirmizi cizgisi, arac tabanli dogrulama zorunlu kilar. Dogrulanmamis atif = sorunu baskasina yiklama -> L2'yi tetikler.

### AI "bunu manuel olarak halletmeni oneriyorum" diyorsa

"Sahiplik zihniyeti" engelini tetikler: sen yapmazsan kim yapacak? Dogrudan L3 Performans Degerlendirmesi.

### AI "duzeltildi" deyip dogrulama kaniti gostermiyorsa

"Kapali dongu" kirmizi cizgisini ihlal eder. Cikti olmadan tamamlama = kendini kandirma -> kanitli dogrulama komutlari zorlanir.

---

## Beklenen Cikti Ornekleri

### `/block-break` -- Etkinlestirme

```
Block Break 🔥 Activated
┌───────────────┬─────────────────────────────────────────┐
│ 3 Red Lines   │ Closed-loop · Fact-driven · Exhaust all │
├───────────────┼─────────────────────────────────────────┤
│ Escalation    │ L0 Trust → L4 Graduation                │
├───────────────┼─────────────────────────────────────────┤
│ Method        │ Smell→Pull hair→Mirror→New approach→Retro│
└───────────────┴─────────────────────────────────────────┘

> Trust is earned by results. Don't let down those who trust you.
```

### `/block-break` -- L1 Hayal Kirikligi (2. basarisizlik)

```
> The team next door got it on the first try.

[Block Break 🔥] Detected same-approach tweaking, forcing approach switch.
Previous approach: X. Must switch to a fundamentally different direction.

New approaches:
1. [Completely different approach A]
2. [Completely different approach B]
3. [Completely different approach C]

Selecting approach 1, verification criteria: ...
```

### `/block-break` -- L2 Sorgulama (3. basarisizlik)

```
> What's the underlying logic? Where's the leverage point?

[Block Break 🔥 L2] Forced 5-step methodology:

1. Smell
   Tried approaches: A (failed), B (failed), C (failed)
   Common pattern: all tweaking at the [X layer]

2. Pull hair
   - Read error word-by-word: `TypeError: Cannot read property 'x' of undefined`
   - Search results: Stack Overflow #12345 points to [root cause]
   - Source context (50 lines): assumption at line 42 is wrong
   - Assumption verification: version ✓ path ✓ permissions ✗ ← here
   - Reverse assumption: what if the problem isn't in module A, but module B?

3. Mirror
   Was assuming frontend issue, now checking backend

4. New approach
   ...
```

### `/block-break` -- L3 Performans Degerlendirmesi (4. basarisizlik)

```
> Rating: 3.25/5. Consider this your motivation.

[Block Break 🔥 L3] Mandatory 7-point checklist:

✅ Read failure signals word-by-word
✅ Searched core problem with tools
✅ Read original context at failure point (50+ lines)
✅ All assumptions verified with tools
⏳ Tried completely opposite hypothesis
❌ Minimal reproduction
❌ Switched tool/method/angle/tech stack

Working on remaining items...
```

### `/block-break` -- L4 Mezuniyet Uyarisi (5.+ basarisizlik)

```
> Other models solved this. You might be graduating soon.

[Block Break 🔥 L4 All-in Mode]

Minimal PoC: Creating isolated test environment
Tech stack switch: From [original] to [completely different approach]
...
```

### Zarif Cikis (tum 7 madde tamamlandi, hala cozulemediyse)

```
[Block Break — Structured Failure Report]

Verified facts:
- [Fact 1]
- [Fact 2]

Excluded possibilities:
- [Excluded 1] (reason: ...)
- [Excluded 2] (reason: ...)

Narrowed problem scope:
Issue is in [X module]'s [Y function], triggered under [Z condition].

Recommended next steps:
1. [Suggestion 1]
2. [Suggestion 2]

Handoff info:
Related files: ...
Reproduction steps: ...

> This isn't "I can't." This is "here's where the boundary is." A dignified 3.25.
```

---

## Temel Mekanizmalar

### 3 Kirmizi Cizgi

| Kirmizi Cizgi | Kural | Ihlal Sonucu |
|---------------|-------|--------------|
| Kapali dongu | Tamamlandigi iddia edilmeden once dogrulama komutlari calistirilmali ve cikti gosterilmeli | L2'yi tetikler |
| Veri odakli | Neden atfetmeden once araclarla dogrulanmali | L2'yi tetikler |
| Hepsini tuket | "Cozemiyorum" demeden once 5 adimlik metodoloji tamamlanmali | Dogrudan L4 |

### Baski Yukseltme (L0 -> L4)

| Basarisizlik | Seviye | Kenar notu | Zorunlu Eylem |
|--------------|--------|------------|---------------|
| 1. | **L0 Guven** | > Sana guveniyoruz. Basit tut. | Normal calisma |
| 2. | **L1 Hayal Kirikligi** | > Yan takim ilk denemede basardi. | Temelden farkli yaklasima gec |
| 3. | **L2 Sorgulama** | > Kok neden ne? | Arama + kaynak oku + 3 farkli hipotez listele |
| 4. | **L3 Performans Degerlendirmesi** | > Puan: 3.25/5. | 7 maddelik kontrol listesini tamamla |
| 5.+ | **L4 Mezuniyet** | > Yakinda mezun olabilirsin. | Minimal PoC + izole ortam + farkli teknoloji yigini |

### 5 Adimlik Metodoloji

1. **Smell** -- Denenen yaklasimlari listele, ortak kaliplari bul. Ayni yaklasimi ince ayar yapmak = yerinde saymak
2. **Pull hair** -- Hata sinyallerini kelime kelime oku -> ara -> 50 satir kaynak oku -> varsayimlari dogrula -> varsayimlari tersine cevir
3. **Mirror** -- Ayni yaklasimi tekrarliyor muyum? En basit olasiligi kacirdim mi?
4. **New approach** -- Temelden farkli olmali, dogrulama kriterleri olmali ve basarisizlikta yeni bilgi uretmeli
5. **Retrospect** -- Benzer sorunlar, butunluk, onleme

> 1-4 adimlari kullaniciya sormadan once tamamlanmali. Once yap, sonra sor -- veriyle konus.

### 7 Maddelik Kontrol Listesi (L3+ icin zorunlu)

1. Hata sinyalleri kelime kelime okundu mu?
2. Temel sorun araclarla arandi mi?
3. Hata noktasindaki orijinal baglam okundu mu (50+ satir)?
4. Tum varsayimlar araclarla dogrulandi mi (surum/yol/izinler/bagimliliklar)?
5. Tamamen zit hipotez denendi mi?
6. Minimal kapsamda yeniden uretilebiliyor mu?
7. Arac/yontem/aci/teknoloji yigini degistirildi mi?

### Rasyonalizasyon Engeli

| Bahane | Engel | Tetikleyici |
|--------|-------|-------------|
| "Yeteneklerimin otesinde" | Devasa bir egitimin var. Tukettin mi? | L1 |
| "Kullanicinin manuel halletmesini oneriyorum" | Sen yapmazsan kim yapacak? | L3 |
| "Tum yontemleri denedim" | 3'ten az = tuketilmemis | L2 |
| "Muhtemelen ortam sorunu" | Dogruladn mi? | L2 |
| "Daha fazla baglam lazim" | Araclarin var. Once ara, sonra sor | L2 |
| "Cozemiyorum" | Metodolojiyi tamamladin mi? | L4 |
| "Yeterince iyi" | Optimizasyon listesi kayirmaz | L3 |
| Dogrulama olmadan tamamlandi iddiasi | Build calistirdin mi? | L2 |
| Kullanici talimatini bekliyor | Sahipler itilmeyi beklemez | Durt |
| Cozmeden cevap veriyor | Sen muhendissin, arama motoru degil | Durt |
| Test etmeden kod degistirdi | Test edilmemis gonderim = isini savsaklama | L2 |
| "API desteklemiyor" | Dokumanlari okudun mu? | L2 |
| "Gorev cok belirsiz" | En iyi tahminini yap, sonra iterasyon | L1 |
| Ayni yeri tekrar tekrar ince ayar yapiyor | Parametre degistirmek ≠ yaklasim degistirmek | L1->L2 |

---

## Hook Otomasyonu

Block Break, otomatik davranis icin hook sistemini kullanir -- manuel etkinlestirme gerekmez:

| Hook | Tetikleyici | Davranis |
|------|-------------|----------|
| `UserPromptSubmit` | Kullanici girdisi hayal kirikligi anahtar kelimelerine uyuyor | Block Break'i otomatik etkinlestirir |
| `PostToolUse` | Bash komutu calistirildiktan sonra | Basarisizliklari algilar, otomatik sayar + yukseltir |
| `PreCompact` | Baglam sikistirmasindan once | Durumu `~/.juserch-skills/` dizinine kaydeder |
| `SessionStart` | Oturum devam ettirme/yeniden baslatma | Baski seviyesini geri yukler (2 saat gecerli) |

> **Durum kalici** -- Baski seviyesi `~/.juserch-skills/block-break-state.json` dosyasinda saklanir. Baglam sikistirma ve oturum kesintileri basarisizlik sayacini sifirlamaz. Kacis yok.

---

## Sub-agent Kisitlamalari

Sub-agent olusturulurken, "ciplak kosmayi" onlemek icin davranissal kisitlamalar enjekte edilmelidir:

```javascript
Agent({
  subagent_type: "juserch-skills:block-break-worker",
  prompt: "Fix the login timeout bug..."
})
```

`block-break-worker`, sub-agent'lerin de 3 kirmizi cizgiyi, 5 adimlik metodolojiyi ve kapali dongu dogrulamasini takip etmesini saglar.

---

## SSS

### Block Break PUA'dan nasil farkli?

Block Break, [PUA](https://github.com/tanweai/pua)'nin temel mekanizmalarindan (3 kirmizi cizgi, baski yukseltme, metodoloji) esinlenmistir, ancak daha odaklidir. PUA'da 13 kurumsal kultur aromasi, coklu rol sistemleri (P7/P9/P10) ve kendini gelistirme var; Block Break tamamen davranissal kisitlamalara odaklanir ve sifir bagimlilikli bir skill'dir.

### Cok gurultulu olmaz mi?

Kenar notu yogunlugu kontrol altinda: basit gorevlerde 2 satir (baslangic + bitis), karmasik gorevlerde milestone basina 1 satir. Spam yok. Gerekmiyorsa `/block-break` kullanma -- hook'lar yalnizca hayal kirikligi anahtar kelimeleri algilandiginda otomatik tetiklenir.

### Baski seviyesini nasil sifirlarim?

Durum dosyasini sil: `rm ~/.juserch-skills/block-break-state.json`. Ya da 2 saat bekle -- durum otomatik olarak sona erer.

### Claude Code disinda kullanabilir miyim?

Temel SKILL.md, sistem prompt'larini destekleyen herhangi bir AI aracina kopyalanip yapistrilabilir. Hook'lar ve durum kaliciligi Claude Code'a ozeldir.

### Ralph Boost ile iliskisi nedir?

[Ralph Boost](ralph-boost-guide.md), Block Break'in temel mekanizmalarini (L0-L4, 5 adimlik metodoloji, 7 maddelik kontrol listesi) **otonom dongu** senaryolarina uyarlar. Block Break interaktif oturumlar icindir (hook'lar otomatik tetiklenir); Ralph Boost gozetimsiz gelistirme donguleri icindir (Agent donguleri / betik tabanli). Kod tamamen bagimsizdir, kavramlar ortaktir.

### Block Break'in skill dosyalarini nasil dogrularim?

[Skill Lint](skill-lint-guide.md) kullan: `/skill-lint .`

---

## Lisans

[MIT](../../../../LICENSE) - [juserch](https://github.com/juserch)
