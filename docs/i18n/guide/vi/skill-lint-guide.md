# Huong dan su dung Skill Lint

> Bat dau trong 3 phut -- kiem tra chat luong skill Claude Code cua ban

---

## Cai dat

### Claude Code (khuyen dung)

```bash
claude plugin add juserch/jskills
```

### Cai dat nhanh mot dong

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/skill-lint/SKILL.md
```

> **Khong phu thuoc gi** -- Skill Lint khong can bat ky dich vu hay API nao tu ben ngoai. Cai va chay thoi.

---

## Cac lenh

| Lenh | Chuc nang | Khi nao dung |
|------|-----------|--------------|
| `/skill-lint` | Hien thi thong tin su dung | Xem cac kiem tra co san |
| `/skill-lint .` | Lint du an hien tai | Tu kiem tra trong qua trinh phat trien |
| `/skill-lint /path/to/plugin` | Lint mot duong dan cu the | Xem xet plugin khac |

---

## Tinh huong su dung

### Tu kiem tra sau khi tao skill moi

Sau khi tao `skills/<name>/SKILL.md`, `commands/<name>.md`, va cac file lien quan, chay `/skill-lint .` de xac nhan cau truc day du, frontmatter dung, va muc marketplace da duoc them.

### Xem xet plugin cua nguoi khac

Khi review PR hoac kiem tra plugin khac, dung `/skill-lint /path/to/plugin` de kiem tra nhanh tinh day du va nhat quan cua file.

### Tich hop CI

`scripts/skill-lint.sh` co the chay truc tiep trong CI pipeline, xuat JSON de phan tich tu dong:

```bash
bash skills/skill-lint/scripts/skill-lint.sh /path/to/plugin
```

---

## Cac muc Kiem tra

### Kiem tra Cau truc (thuc thi boi Bash script)

| Quy tac | Kiem tra gi | Muc do |
|---------|------------|--------|
| S01 | `plugin.json` ton tai ca o root va `.claude-plugin/` | error |
| S02 | `.claude-plugin/marketplace.json` ton tai | error |
| S03 | Moi `skills/<name>/` chua mot `SKILL.md` | error |
| S04 | Frontmatter cua SKILL.md bao gom `name` va `description` | error |
| S05 | Moi skill co file `commands/<name>.md` tuong ung | warning |
| S06 | Moi skill duoc liet ke trong mang `plugins` cua marketplace.json | warning |
| S07 | Cac file references duoc trich dan trong SKILL.md thuc su ton tai | error |
| S08 | `evals/<name>/scenarios.md` ton tai | warning |

### Kiem tra Ngu nghia (thuc thi boi AI)

| Quy tac | Kiem tra gi | Muc do |
|---------|------------|--------|
| M01 | Mo ta neu ro muc dich va dieu kien trigger | warning |
| M02 | Ten khop voi ten thu muc; mo ta nhat quan giua cac file | warning |
| M03 | Logic dinh tuyen lenh tham chieu dung ten skill | warning |
| M04 | Noi dung references nhat quan logic voi SKILL.md | warning |
| M05 | Cac kich ban danh gia bao phu cac duong chuc nang cot loi (it nhat 5) | warning |

---

## Vi du Output Mong doi

### Tat ca kiem tra deu pass

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

### Phat hien van de

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

## Quy trinh

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

## Cau hoi Thuong gap

### Co the chi chay kiem tra cau truc ma khong chay kiem tra ngu nghia khong?

Co -- chay truc tiep bash script:

```bash
bash skills/skill-lint/scripts/skill-lint.sh .
```

Lenh nay xuat JSON thuan tuy, khong co phan tich ngu nghia cua AI.

### Co hoat dong tren cac du an khong phai jskills khong?

Co. Bat ky thu muc nao theo cau truc plugin Claude Code chuan (`skills/`, `commands/`, `.claude-plugin/`) deu co the duoc kiem tra.

### Su khac biet giua error va warning la gi?

- **error**: Van de cau truc se ngan skill tai hoac phat hanh dung cach
- **warning**: Van de chat luong khong lam hong chuc nang nhung anh huong den kha nang bao tri va kham pha

### Cac cong cu jskills khac

Skill Lint la mot phan cua bo suu tap jskills va hoat dong tot cung voi cac skill nay:

- [Block Break](block-break-guide.md) -- Engine rang buoc hanh vi cao nang luc bat AI phai thu het moi cach tiep can
- [Ralph Boost](ralph-boost-guide.md) -- Engine vong lap dev tu dong voi bao dam hoi tu Block Break tich hop

Sau khi phat trien skill moi, chay `/skill-lint .` de xac minh tinh day du cau truc va xac nhan rang frontmatter, marketplace.json, va cac lien ket tham chieu deu dung.

---

## Giay phep

[MIT](../../../../LICENSE) - [juserch](https://github.com/juserch)
