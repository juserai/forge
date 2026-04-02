# Huong dan su dung Ralph Boost

> Bat dau trong 5 phut -- giu cho vong lap dev tu dong cua AI khong bi tac

---

## Cai dat

### Claude Code (khuyen dung)

```bash
claude plugin add juserch/jskills
```

### Cai dat nhanh mot dong

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/ralph-boost/SKILL.md
```

> **Khong phu thuoc gi** -- Ralph Boost khong phu thuoc vao ralph-claude-code, block-break, hay bat ky dich vu ben ngoai nao. Duong chinh (Agent loop) khong co phu thuoc ngoai; duong du phong can `jq` hoac `python` va `claude` CLI.

---

## Cac lenh

| Lenh | Chuc nang | Khi nao dung |
|------|-----------|--------------|
| `/ralph-boost setup` | Khoi tao vong lap tu dong trong du an | Thiet lap lan dau |
| `/ralph-boost run` | Bat dau vong lap tu dong trong session hien tai | Sau khi khoi tao |
| `/ralph-boost status` | Xem trang thai vong lap hien tai | Theo doi tien do |
| `/ralph-boost clean` | Xoa cac file vong lap | Don dep |

---

## Bat dau nhanh

### 1. Khoi tao du an

```text
/ralph-boost setup
```

Claude se huong dan ban qua cac buoc:
- Phat hien ten du an
- Tao danh sach task (fix_plan.md)
- Tao thu muc `.ralph-boost/` va tat ca file cau hinh

### 2. Bat dau vong lap

```text
/ralph-boost run
```

Claude dieu khien vong lap tu dong truc tiep trong session hien tai (che do Agent loop). Moi lan lap, mot sub-agent duoc tao de thuc thi task, trong khi session chinh dong vai tro bo dieu khien vong lap quan ly trang thai.

**Du phong** (moi truong headless / khong giam sat):

```bash
# Chay tien canh
bash ~/.claude/plugins/juserch_jskills/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project

# Chay nen
nohup bash ~/.claude/plugins/juserch_jskills/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project > /dev/null 2>&1 &
```

### 3. Theo doi trang thai

```text
/ralph-boost status
```

Vi du output:

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

## Cach hoat dong

### Vong lap Tu dong

Ralph Boost cung cap hai duong thuc thi:

**Duong chinh (Agent loop)**: Claude dong vai tro bo dieu khien vong lap trong session hien tai, tao sub-agent moi lan lap de thuc thi task. Session chinh quan ly trang thai, circuit breaker, va leo thang ap luc. Khong co phu thuoc ben ngoai.

**Du phong (bash script)**: `boost-loop.sh` chay cac lenh goi `claude -p` trong vong lap nen. Ho tro ca jq va python lam JSON engine, tu dong phat hien luc chay. Thoi gian cho mac dinh giua cac lan lap la 1 gio (co the cau hinh).

Ca hai duong deu dung chung quan ly trang thai (state.json), logic leo thang ap luc, va giao thuc BOOST_STATUS.

```
Read task → Execute → Detect progress → Adjust strategy → Report → Next iteration
```

### Circuit Breaker Nang cao (so voi ralph-claude-code)

Circuit breaker cua ralph-claude-code: bo cuoc sau 3 vong lap lien tuc khong co tien trien.

Circuit breaker cua ralph-boost: **leo thang ap luc dan dan** khi bi tac, len toi 6-7 vong tu phuc hoi truoc khi dung.

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

## Vi du Output Mong doi

### L0 -- Thuc thi Binh thuong

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

### L1 -- Chuyen Cach tiep can

```
[boost-loop.sh] Circuit breaker: CLOSED | L1 Disappointment | 1 loop without progress

Context injected:
"Loop #3. Pressure: L1 Disappointment. The team next door got it on the first try.
 Tried approaches: 1. MANDATORY: Switch to a fundamentally different approach."
```

Claude bi bat buoc phai bo cach tiep can truoc va thu dieu gi do **khac ve ban chat**. Tinh chinh tham so khong tinh.

### L2 -- Tim kiem va Gia thuyet

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L2 Interrogation | 2 loops without progress

Context injected:
"Loop #4. Pressure: L2 Interrogation. What is the underlying logic? Where is the leverage point?
 Tried approaches: 2. MANDATORY: Read the error word-by-word. Search 50+ lines of context.
 List 3 fundamentally different hypotheses."
```

Claude phai: doc loi tung chu mot -> tim kiem 50+ dong boi canh -> liet ke 3 gia thuyet khac nhau.

### L3 -- Checklist

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L3 Performance Review | 3 loops without progress
```

Claude phai hoan thanh checklist 7 diem (doc tin hieu loi, tim van de cot loi, doc source, xac minh gia dinh, dao nguoc gia thuyet, tai tao toi thieu, doi cong cu/phuong phap). Moi muc hoan thanh duoc ghi vao state.json.

### L4 -- Ban giao Duyen dang

```
[boost-loop.sh] Circuit breaker: CLOSED | L4 Graduation | L4 active, waiting for handoff report
```

Claude xay dung mot PoC toi thieu, sau do tao bao cao ban giao:

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

Sau khi ban giao hoan tat, vong lap tat mot cach duyen dang. Day khong phai "toi khong the" -- ma la "ranh gioi o day".

---

## Cau hinh

`.ralph-boost/config.json`:

| Truong | Mac dinh | Mo ta |
|--------|---------|------|
| `max_calls_per_hour` | 100 | So lenh goi Claude API toi da moi gio |
| `claude_timeout_minutes` | 15 | Timeout cho moi lenh goi rieng le |
| `allowed_tools` | Write, Read, Edit, Bash, Glob, Grep | Cac cong cu Claude co the dung |
| `claude_model` | "" | Ghi de model (de trong = mac dinh) |
| `session_expiry_hours` | 24 | Thoi gian het han session |
| `no_progress_threshold` | 7 | Nguong khong tien trien truoc khi tat |
| `same_error_threshold` | 8 | Nguong loi trung lap truoc khi tat |
| `sleep_seconds` | 3600 | Thoi gian cho giua cac lan lap (giay) |

### Cac tinh chinh cau hinh pho bien

**Tang toc vong lap** (de test):

```json
{
  "sleep_seconds": 60,
  "claude_timeout_minutes": 5
}
```

**Gioi han quyen cong cu**:

```json
{
  "allowed_tools": ["Read", "Glob", "Grep"]
}
```

**Dung mot model cu the**:

```json
{
  "claude_model": "claude-sonnet-4-6"
}
```

---

## Cau truc Thu muc Du an

```
.ralph-boost/
├── PROMPT.md           # Huong dan dev (bao gom block-break protocol)
├── fix_plan.md         # Danh sach task (Claude tu dong cap nhat)
├── config.json         # Cau hinh
├── state.json          # Trang thai thong nhat (circuit breaker + ap luc + session)
├── handoff-report.md   # Bao cao ban giao L4 (tao khi thoat duyen dang)
├── logs/
│   ├── boost.log       # Log vong lap
│   └── claude_output_*.log  # Output moi lan lap
└── .gitignore          # Bo qua trang thai va log
```

Tat ca file nam trong `.ralph-boost/` -- thu muc goc du an cua ban khong bi thay doi.

---

## Quan he voi ralph-claude-code

Ralph Boost la mot **phuong an thay the doc lap** cho [ralph-claude-code](https://github.com/frankbria/ralph-claude-code), khong phai plugin nang cap.

| Khia canh | ralph-claude-code | ralph-boost |
|-----------|-------------------|-------------|
| Hinh thuc | Cong cu Bash doc lap | Claude Code skill (Agent loop) |
| Cai dat | `npm install` | Claude Code plugin |
| Kich thuoc code | 2000+ dong | ~400 dong |
| Phu thuoc ngoai | jq (bat buoc) | Duong chinh: khong; Du phong: jq hoac python |
| Thu muc | `.ralph/` | `.ralph-boost/` |
| Circuit breaker | Thu dong (bo cuoc sau 3 vong) | Chu dong (L0-L4, 6-7 vong tu phuc hoi) |
| Cung ton tai | Co | Co (khong xung dot file) |

Ca hai co the cai dong thoi trong cung du an -- chung dung thu muc rieng va khong anh huong lan nhau.

---

## Quan he voi Block Break

Ralph Boost dieu chinh cac co che cot loi cua Block Break (leo thang ap luc, phuong phap 5 buoc, checklist) cho cac tinh huong vong lap tu dong:

| Khia canh | block-break | ralph-boost |
|-----------|-------------|-------------|
| Tinh huong | Phien tuong tac | Vong lap tu dong |
| Kich hoat | Hook tu dong trigger | Tich hop trong Agent loop / loop script |
| Phat hien | PostToolUse hook | Agent loop phat hien tien do / script phat hien tien do |
| Dieu khien | Prompt inject qua hook | Agent prompt injection / --append-system-prompt |
| Trang thai | `~/.juserch-skills/` | `.ralph-boost/state.json` |

Code hoan toan doc lap; khai niem chung.

> **Tham khao**: Leo thang ap luc (L0-L4), phuong phap 5 buoc, va checklist 7 diem cua Block Break la nen tang khai niem cho circuit breaker cua ralph-boost. Xem [Huong dan su dung Block Break](block-break-guide.md) de biet chi tiet.

---

## Cau hoi Thuong gap

### Lam sao chon giua duong chinh va du phong?

`/ralph-boost run` mac dinh su dung Agent loop (duong chinh), chay truc tiep trong session Claude Code hien tai. Dung bash script du phong khi ban can chay headless hoac khong giam sat.

### Loop script nam o dau?

Sau khi cai jskills plugin, script du phong nam tai `~/.claude/plugins/juserch_jskills/skills/ralph-boost/scripts/boost-loop.sh`. Ban cung co the copy no bat ky dau va chay tu do. Script tu dong phat hien jq hoac python lam JSON engine.

### Lam sao xem log vong lap?

```bash
tail -f .ralph-boost/logs/boost.log
```

### Lam sao reset muc ap luc thu cong?

Sua `.ralph-boost/state.json`: dat `pressure.level` ve 0 va `circuit_breaker.consecutive_no_progress` ve 0. Hoac don gian xoa state.json va khoi tao lai.

### Lam sao thay doi danh sach task?

Sua truc tiep `.ralph-boost/fix_plan.md`, dung dinh dang `- [ ] task`. Claude doc no vao dau moi lan lap.

### Lam sao phuc hoi sau khi circuit breaker mo?

Sua `state.json`, dat `circuit_breaker.state` thanh `"CLOSED"`, reset cac bo dem lien quan, va chay lai script.

### Toi co can ralph-claude-code khong?

Khong. Ralph Boost hoan toan doc lap va khong phu thuoc vao bat ky file Ralph nao.

### Nhung platform nao duoc ho tro?

Hien tai ho tro Claude Code (Agent loop duong chinh). Bash script du phong can bash 4+, jq hoac python, va claude CLI.

### Lam sao kiem tra file skill cua ralph-boost?

Dung [Skill Lint](skill-lint-guide.md): `/skill-lint .`

---

## Giay phep

[MIT](../../../../LICENSE) - [juserch](https://github.com/juserch)
