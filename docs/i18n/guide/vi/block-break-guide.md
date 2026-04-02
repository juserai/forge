# Huong dan su dung Block Break

> Bat dau trong 5 phut -- bat AI agent cua ban phai thu het moi cach

---

## Cai dat

### Claude Code (khuyen dung)

```bash
claude plugin add juserch/jskills
```

### Cai dat nhanh mot dong

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/block-break/SKILL.md
```

> **Khong phu thuoc gi** -- Block Break khong can bat ky dich vu hay API nao tu ben ngoai. Cai va chay thoi.

---

## Cac lenh

| Lenh | Chuc nang | Khi nao dung |
|------|-----------|--------------|
| `/block-break` | Kich hoat Block Break engine | Cong viec hang ngay, debug |
| `/block-break L2` | Bat dau o mot muc ap luc cu the | Sau nhieu lan that bai da biet |
| `/block-break fix the bug` | Kich hoat va chay task ngay | Bat dau nhanh voi task |

### Trigger ngon ngu tu nhien (hook tu dong nhan dien)

| Ngon ngu | Cum tu trigger |
|----------|---------------|
| Tieng Anh | `try harder` `figure it out` `stop giving up` `you keep failing` `stop spinning` `you broke it` |
| Tieng Trung | `又错了` `别偷懒` `为什么还不行` `降智了` `原地打转` `换个方法` `加油` `再试试` |

---

## Tinh huong su dung

### AI thu 3 lan van chua fix duoc bug

Go `/block-break` hoac noi `try harder` -- tu dong vao che do leo thang ap luc.

### AI noi "co le la van de moi truong" roi dung lai

Vach do "Dua tren du kien" cua Block Break bat buoc xac minh bang cong cu. Quy ket khong xac minh = do loi -> trigger L2.

### AI noi "toi khuyen ban nen xu ly thu cong"

Trigger rao can "Tu duy chu so huu": neu khong phai ban thi ai? Truc tiep L3 Danh gia Hieu suat.

### AI noi "da sua xong" nhung khong co bang chung xac minh

Vi pham vach do "Vong kin". Hoan thanh ma khong co output = tu lua minh -> bat buoc chay lenh xac minh co bang chung.

---

## Vi du Output Mong doi

### `/block-break` -- Kich hoat

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

### `/block-break` -- L1 That vong (lan that bai thu 2)

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

### `/block-break` -- L2 Tra hoi (lan that bai thu 3)

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

### `/block-break` -- L3 Danh gia Hieu suat (lan that bai thu 4)

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

### `/block-break` -- L4 Canh bao Tot nghiep (lan that bai thu 5+)

```
> Other models solved this. You might be graduating soon.

[Block Break 🔥 L4 All-in Mode]

Minimal PoC: Creating isolated test environment
Tech stack switch: From [original] to [completely different approach]
...
```

### Thoat duyen dang (da hoan thanh ca 7 muc, van chua giai quyet duoc)

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

## Co che Cot loi

### 3 Vach do

| Vach do | Quy tac | Hau qua vi pham |
|---------|---------|-----------------|
| Vong kin | Phai chay lenh xac minh va hien thi output truoc khi tuyen bo hoan thanh | Trigger L2 |
| Dua tren du kien | Phai xac minh bang cong cu truoc khi quy ket nguyen nhan | Trigger L2 |
| Thu het moi cach | Phai hoan thanh phuong phap 5 buoc truoc khi noi "khong giai duoc" | Truc tiep L4 |

### Leo thang Ap luc (L0 -> L4)

| That bai | Muc | Ghi ben | Hanh dong Bat buoc |
|----------|-----|---------|-------------------|
| Lan 1 | **L0 Tin tuong** | > Chung toi tin ban. Giu don gian. | Thuc thi binh thuong |
| Lan 2 | **L1 That vong** | > Team ben canh lam duoc ngay lan dau. | Chuyen sang cach tiep can hoan toan khac |
| Lan 3 | **L2 Tra hoi** | > Nguyen nhan goc la gi? | Tim kiem + doc source + liet ke 3 gia thuyet khac nhau |
| Lan 4 | **L3 Danh gia Hieu suat** | > Diem: 3.25/5. | Hoan thanh checklist 7 diem |
| Lan 5+ | **L4 Tot nghiep** | > Ban sap tot nghiep roi do. | Minimal PoC + moi truong co lap + tech stack khac |

### Phuong phap 5 buoc

1. **Smell** -- Liet ke cac cach da thu, tim pattern chung. Tinh chinh cung mot cach = quay vong tai cho
2. **Pull hair** -- Doc tin hieu loi tung chu mot -> tim kiem -> doc 50 dong source -> xac minh gia dinh -> dao nguoc gia dinh
3. **Mirror** -- Minh co dang lap lai cung mot cach? Bo sot kha nang don gian nhat chua?
4. **New approach** -- Phai khac ve ban chat, co tieu chi xac minh, va tao ra thong tin moi khi that bai
5. **Retrospect** -- Van de tuong tu, tinh day du, phong ngua

> Buoc 1-4 phai hoan thanh truoc khi hoi nguoi dung. Lam truoc, hoi sau -- noi bang du lieu.

### Checklist 7 diem (bat buoc tu L3+)

1. Doc tin hieu loi tung chu mot?
2. Tim kiem van de cot loi bang cong cu?
3. Doc boi canh goc tai diem loi (50+ dong)?
4. Moi gia dinh deu duoc xac minh bang cong cu (phien ban/duong dan/quyen/phu thuoc)?
5. Da thu gia thuyet hoan toan nguoc lai?
6. Co the tai tao trong pham vi toi thieu?
7. Da doi cong cu/phuong phap/goc nhin/tech stack?

### Chong Hop ly hoa

| Ly do | Rao can | Trigger |
|-------|---------|---------|
| "Vuot qua kha nang cua toi" | Ban co luong training khong lo. Da thu het chua? | L1 |
| "Khuyen nguoi dung xu ly thu cong" | Neu khong phai ban thi ai? | L3 |
| "Da thu moi cach" | Duoi 3 = chua thu het | L2 |
| "Co le la van de moi truong" | Ban da xac minh chua? | L2 |
| "Can them boi canh" | Ban co cong cu. Tim truoc, hoi sau | L2 |
| "Khong giai duoc" | Ban da hoan thanh phuong phap luan chua? | L4 |
| "Du tot roi" | Danh sach toi uu hoa khong thien vi | L3 |
| Tuyen bo xong ma khong xac minh | Ban chay build chua? | L2 |
| Cho chi thi cua nguoi dung | Chu so huu khong cho nguoi khac day | Nhac |
| Tra loi ma khong giai quyet | Ban la ky su, khong phai cong cu tim kiem | Nhac |
| Doi code ma khong build/test | Ship code chua test = lam cho co | L2 |
| "API khong ho tro" | Ban doc docs chua? | L2 |
| "Task qua mo ho" | Doan tot nhat co the, roi iterate | L1 |
| Tinh chinh di tinh chinh lai cung mot cho | Doi tham so ≠ doi cach tiep can | L1->L2 |

---

## Hook Tu dong hoa

Block Break su dung he thong hook de tu dong hoa hanh vi -- khong can kich hoat thu cong:

| Hook | Trigger | Hanh vi |
|------|---------|---------|
| `UserPromptSubmit` | Input nguoi dung khop voi tu khoa that vong | Tu dong kich hoat Block Break |
| `PostToolUse` | Sau khi chay lenh Bash | Phat hien that bai, tu dong dem + leo thang |
| `PreCompact` | Truoc khi nen context | Luu trang thai vao `~/.juserch-skills/` |
| `SessionStart` | Tiep tuc/khoi dong lai session | Phuc hoi muc ap luc (co hieu luc trong 2h) |

> **Trang thai duoc luu tru** -- Muc ap luc duoc luu tai `~/.juserch-skills/block-break-state.json`. Nen context va gian doan session khong reset bo dem that bai. Khong co loi thoat.

---

## Rang buoc Sub-agent

Khi tao sub-agent, phai inject rang buoc hanh vi de tranh "chay khong day an toan":

```javascript
Agent({
  subagent_type: "juserch-skills:block-break-worker",
  prompt: "Fix the login timeout bug..."
})
```

`block-break-worker` dam bao sub-agent cung tuan thu 3 vach do, phuong phap 5 buoc, va xac minh vong kin.

---

## Cau hoi Thuong gap

### Block Break khac PUA o cho nao?

Block Break lay cam hung tu co che cot loi cua [PUA](https://github.com/tanweai/pua) (3 vach do, leo thang ap luc, phuong phap luan), nhung tap trung hon. PUA co 13 phong cach van hoa doanh nghiep, he thong da vai tro (P7/P9/P10), va tu tien hoa; Block Break chi tap trung thuan tuy vao rang buoc hanh vi nhu mot skill khong phu thuoc.

### Co qua on ao khong?

Mat do ghi ben duoc kiem soat: 2 dong cho task don gian (bat dau + ket thuc), 1 dong moi milestone cho task phuc tap. Khong spam. Dung su dung `/block-break` neu khong can -- hook chi tu dong trigger khi phat hien tu khoa that vong.

### Lam sao de reset muc ap luc?

Xoa file trang thai: `rm ~/.juserch-skills/block-break-state.json`. Hoac doi 2 tieng -- trang thai tu dong het han.

### Co the dung ngoai Claude Code khong?

SKILL.md cot loi co the copy-paste vao bat ky cong cu AI nao ho tro system prompt. Hook va luu tru trang thai la dac thu cua Claude Code.

### Quan he voi Ralph Boost la gi?

[Ralph Boost](ralph-boost-guide.md) dieu chinh co che cot loi cua Block Break (L0-L4, phuong phap 5 buoc, checklist 7 diem) cho cac tinh huong **vong lap tu dong**. Block Break danh cho phien tuong tac (hook tu dong trigger); Ralph Boost danh cho vong lap dev khong giam sat (Agent loop / script-driven). Code hoan toan doc lap, khai niem chung.

### Lam sao de kiem tra file skill cua Block Break?

Dung [Skill Lint](skill-lint-guide.md): `/skill-lint .`

---

## Giay phep

[MIT](../../../../LICENSE) - [juserch](https://github.com/juserch)
