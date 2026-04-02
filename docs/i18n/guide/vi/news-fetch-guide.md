# Huong dan su dung News Fetch

> Bat dau trong 3 phut -- de AI lay ban tin cho ban

Chan debug roi? Danh 2 phut, cap nhat tin tuc the gioi, roi quay lai lam viec voi tinh than moi.

---

## Cai dat

### Claude Code (khuyen dung)

```bash
claude plugin add juserch/jskills
```

### Cai dat nhanh mot dong

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/news-fetch/SKILL.md
```

> **Khong phu thuoc gi** -- News Fetch khong can bat ky dich vu hay API key nao tu ben ngoai. Cai va chay thoi.

---

## Cac lenh

| Lenh | Chuc nang | Khi nao dung |
|------|-----------|--------------|
| `/news-fetch AI` | Lay tin AI trong tuan nay | Cap nhat nganh nhanh |
| `/news-fetch AI today` | Lay tin AI hom nay | Ban tin hang ngay |
| `/news-fetch robotics month` | Lay tin robotics thang nay | Tong ket hang thang |
| `/news-fetch climate 2026-03-01~2026-03-31` | Lay tin cho khoang ngay cu the | Nghien cuu co muc tieu |

---

## Tinh huong su dung

### Ban tin cong nghe hang ngay

```
/news-fetch AI today
```

Nhan tin AI moi nhat hom nay, xep hang theo do lien quan. Luot qua tieu de va tom tat trong vai giay.

### Nghien cuu nganh

```
/news-fetch electric vehicles 2026-03-01~2026-03-31
```

Lay tin cho mot khoang thoi gian cu the de ho tro phan tich thi truong va nghien cuu canh tranh.

### Tin tuc da ngon ngu

Chu de tieng Trung tu dong nhan them tim kiem tieng Anh bo sung de mo rong pham vi, va nguoc lai. Ban nhan duoc tot nhat tu ca hai the gioi ma khong can them cong suc.

---

## Vi du Output Mong doi

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

## Du phong Mang 3 tang

News Fetch co chien luoc du phong tich hop de dam bao viec lay tin hoat dong tren cac dieu kien mang khac nhau:

| Tang | Cong cu | Nguon Du lieu | Trigger |
|------|---------|-------------|---------|
| **L1** | WebSearch | Google/Bing | Mac dinh (uu tien) |
| **L2** | WebFetch | Baidu News, Sina, NetEase | L1 that bai |
| **L3** | Bash curl | Cung nguon voi L2 | L2 cung that bai |

Khi tat ca cac tang deu that bai, mot bao cao loi co cau truc duoc tao ra liet ke ly do that bai cho tung nguon.

---

## Tinh nang Output

| Tinh nang | Mo ta |
|-----------|------|
| **Khu trung lap** | Khi nhieu nguon dua tin cung su kien, muc co diem cao nhat duoc giu; cac muc khac duoc gop vao "Related coverage" |
| **Hoan thanh tom tat** | Neu ket qua tim kiem thieu tom tat, noi dung bai viet duoc lay ve va tom tat duoc tao |
| **Cham diem lien quan** | AI cham diem moi ket qua theo do lien quan voi chu de -- cao hon = lien quan hon |
| **Lien ket bam duoc** | Dinh dang link Markdown -- bam duoc trong IDE va terminal |

---

## Cau hoi Thuong gap

### Toi co can API key khong?

Khong. News Fetch hoan toan dua vao WebSearch va web scraping cong khai. Khong can cau hinh gi.

### Co the lay tin tieng Anh khong?

Hoan toan duoc. Chu de tieng Trung tu dong bao gom tim kiem tieng Anh bo sung, va chu de tieng Anh hoat dong tu nhien. Pham vi bao phu ca hai ngon ngu.

### Neu mang toi bi han che thi sao?

Chien luoc du phong 3 tang xu ly viec nay tu dong. Ngay ca khi WebSearch khong kha dung, News Fetch se quay ve cac nguon tin noi dia.

### Tra ve bao nhieu bai?

Toi da 20 (sau khi khu trung lap). So luong thuc te phu thuoc vao nhung gi nguon du lieu tra ve.

---

## Giay phep

[MIT](../../../../LICENSE) - [juserch](https://github.com/juserch)
