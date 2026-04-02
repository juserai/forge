# Block Break 사용 가이드

> 5분 만에 시작하세요 — AI 에이전트가 모든 방법을 소진하도록 만듭니다

---

## 설치

### Claude Code (권장)

```bash
claude plugin add juserch/jskills
```

### 범용 원라인 설치

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/block-break/SKILL.md
```

> **제로 의존성** — Block Break는 외부 서비스나 API가 필요 없습니다. 설치하면 바로 사용할 수 있습니다.

---

## 명령어

| 명령어 | 기능 | 사용 시점 |
|--------|------|-----------|
| `/block-break` | Block Break 엔진 활성화 | 일상 작업, 디버깅 |
| `/block-break L2` | 특정 압력 단계에서 시작 | 이미 여러 번 실패한 경우 |
| `/block-break fix the bug` | 활성화와 동시에 작업 즉시 실행 | 작업과 함께 빠르게 시작 |

### 자연어 트리거 (hooks로 자동 감지)

| 언어 | 트리거 문구 |
|------|------------|
| 영어 | `try harder` `figure it out` `stop giving up` `you keep failing` `stop spinning` `you broke it` |
| 중국어 | `又错了` `别偷懒` `为什么还不行` `降智了` `原地打转` `换个方法` `加油` `再试试` |

---

## 사용 사례

### AI가 버그 수정을 3번 시도하고도 실패한 경우

`/block-break`을 입력하거나 `try harder`라고 말하면 압력 단계적 상승 모드에 자동 진입합니다.

### AI가 "환경 문제인 것 같습니다"라고 하며 중단하는 경우

Block Break의 "사실 기반" 레드라인이 도구 기반 검증을 강제합니다. 검증 없는 원인 귀속 = 책임 전가 → L2 발동.

### AI가 "이 부분은 수동으로 처리하시는 게 좋겠습니다"라고 하는 경우

"주인의식" 차단이 발동됩니다: 당신이 아니면 누가? 바로 L3 인사평가.

### AI가 "수정 완료"라고 하지만 검증 증거를 보여주지 않는 경우

"폐쇄 루프" 레드라인 위반입니다. 출력 없는 완료 = 자기기만 → 증거가 포함된 검증 명령 실행을 강제합니다.

---

## 예상 출력 예시

### `/block-break` — 활성화

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

### `/block-break` — L1 실망 (2번째 실패)

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

### `/block-break` — L2 심문 (3번째 실패)

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

### `/block-break` — L3 인사평가 (4번째 실패)

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

### `/block-break` — L4 졸업 경고 (5번째 이상 실패)

```
> Other models solved this. You might be graduating soon.

[Block Break 🔥 L4 All-in Mode]

Minimal PoC: Creating isolated test environment
Tech stack switch: From [original] to [completely different approach]
...
```

### 우아한 종료 (7개 항목 모두 완료, 여전히 미해결)

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

## 핵심 메커니즘

### 3대 레드라인

| 레드라인 | 규칙 | 위반 시 결과 |
|----------|------|-------------|
| 폐쇄 루프 | 완료를 선언하기 전에 반드시 검증 명령을 실행하고 출력을 보여줘야 합니다 | L2 발동 |
| 사실 기반 | 원인을 귀속하기 전에 반드시 도구로 검증해야 합니다 | L2 발동 |
| 완전 소진 | "해결 불가"라고 하기 전에 반드시 5단계 방법론을 완료해야 합니다 | 즉시 L4 |

### 압력 단계적 상승 (L0 → L4)

| 실패 횟수 | 단계 | 사이드바 | 강제 행동 |
|-----------|------|---------|-----------|
| 1번째 | **L0 신뢰** | > 당신을 믿습니다. 간결하게 진행하세요. | 정상 실행 |
| 2번째 | **L1 실망** | > 옆 팀은 한 번에 해결했는데. | 근본적으로 다른 접근법으로 전환 |
| 3번째 | **L2 심문** | > 근본 원인이 뭐죠? | 검색 + 소스 코드 확인 + 3가지 다른 가설 나열 |
| 4번째 | **L3 인사평가** | > 평점: 3.25/5. | 7항목 체크리스트 완료 |
| 5번째+ | **L4 졸업** | > 곧 졸업하시게 될 수도 있겠네요. | 최소 PoC + 격리 환경 + 다른 기술 스택 |

### 5단계 방법론

1. **Smell** — 시도한 접근법을 나열하고 공통 패턴을 찾습니다. 같은 접근법의 미세 조정 = 제자리 돌기
2. **Pull hair** — 실패 신호를 단어 단위로 읽기 → 검색 → 소스 50줄 읽기 → 가정 검증 → 역발상
3. **Mirror** — 같은 접근법을 반복하고 있지 않은가? 가장 단순한 가능성을 놓치지 않았는가?
4. **New approach** — 반드시 근본적으로 다른 접근이어야 하며, 검증 기준이 있어야 하고, 실패 시 새로운 정보를 제공해야 합니다
5. **Retrospect** — 유사 문제, 완전성, 재발 방지

> 1-4단계는 사용자에게 질문하기 전에 완료해야 합니다. 먼저 실행하고, 나중에 질문하세요 — 데이터로 말하세요.

### 7항목 체크리스트 (L3 이상에서 필수)

1. 실패 신호를 단어 단위로 읽었는가?
2. 핵심 문제를 도구로 검색했는가?
3. 실패 지점의 원본 컨텍스트를 읽었는가 (50줄 이상)?
4. 모든 가정을 도구로 검증했는가 (버전/경로/권한/의존성)?
5. 완전히 반대되는 가설을 시도했는가?
6. 최소 범위에서 재현할 수 있는가?
7. 도구/방법/각도/기술 스택을 바꿔봤는가?

### 합리화 차단

| 핑계 | 차단 | 발동 단계 |
|------|------|----------|
| "제 능력 밖입니다" | 방대한 학습 데이터가 있잖아요. 다 소진했나요? | L1 |
| "사용자가 직접 처리하시는 게 좋겠습니다" | 당신이 아니면 누가? | L3 |
| "모든 방법을 시도했습니다" | 3가지 미만 = 소진하지 않음 | L2 |
| "환경 문제인 것 같습니다" | 검증했나요? | L2 |
| "더 많은 컨텍스트가 필요합니다" | 도구가 있잖아요. 먼저 검색하고, 나중에 질문하세요 | L2 |
| "해결할 수 없습니다" | 방법론을 완료했나요? | L4 |
| "이 정도면 충분합니다" | 최적화 목록에는 편애가 없습니다 | L3 |
| 검증 없이 완료 선언 | 빌드를 실행했나요? | L2 |
| 사용자 지시 대기 | 주인은 떠밀려야 움직이지 않습니다 | 넛지 |
| 해결 없이 답변만 | 당신은 엔지니어지, 검색 엔진이 아닙니다 | 넛지 |
| 빌드/테스트 없이 코드 변경 | 테스트 안 한 배포 = 대충 하기 | L2 |
| "API가 지원하지 않습니다" | 문서를 읽었나요? | L2 |
| "작업이 너무 모호합니다" | 최선의 추측으로 시작하고, 반복하세요 | L1 |
| 같은 부분을 반복 수정 | 파라미터 변경 ≠ 접근법 변경 | L1→L2 |

---

## Hooks 자동화

Block Break는 hooks 시스템을 활용하여 수동 활성화 없이 자동으로 동작합니다:

| Hook | 트리거 | 동작 |
|------|--------|------|
| `UserPromptSubmit` | 사용자 입력이 좌절 키워드에 매칭됨 | Block Break 자동 활성화 |
| `PostToolUse` | Bash 명령 실행 후 | 실패 감지, 자동 카운트 + 단계 상승 |
| `PreCompact` | 컨텍스트 압축 전 | `~/.juserch-skills/`에 상태 저장 |
| `SessionStart` | 세션 재개/재시작 시 | 압력 단계 복원 (2시간 유효) |

> **상태가 유지됩니다** — 압력 단계는 `~/.juserch-skills/block-break-state.json`에 저장됩니다. 컨텍스트 압축이나 세션 중단으로도 실패 카운트가 초기화되지 않습니다. 도망칠 수 없습니다.

---

## Sub-agent 제약 조건

Sub-agent를 생성할 때 "알몸으로 뛰는" 것을 방지하기 위해 행동 제약을 주입해야 합니다:

```javascript
Agent({
  subagent_type: "juserch-skills:block-break-worker",
  prompt: "Fix the login timeout bug..."
})
```

`block-break-worker`는 sub-agent도 3대 레드라인, 5단계 방법론, 폐쇄 루프 검증을 따르도록 보장합니다.

---

## FAQ

### Block Break는 PUA와 어떻게 다릅니까?

Block Break는 [PUA](https://github.com/tanweai/pua)의 핵심 메커니즘(3대 레드라인, 압력 단계적 상승, 방법론)에서 영감을 받았지만, 더 집중적입니다. PUA는 13가지 기업 문화 스타일, 다중 역할 시스템(P7/P9/P10), 자기 진화 기능이 있지만, Block Break는 제로 의존성 skill로서 행동 제약에만 집중합니다.

### 너무 시끄럽지 않나요?

사이드바 밀도가 제어됩니다: 단순 작업에는 2줄(시작 + 종료), 복잡한 작업에는 마일스톤당 1줄. 스팸이 없습니다. 필요하지 않으면 `/block-break`을 사용하지 마세요 — hooks는 좌절 키워드가 감지될 때만 자동 발동합니다.

### 압력 단계를 초기화하려면 어떻게 하나요?

상태 파일을 삭제하세요: `rm ~/.juserch-skills/block-break-state.json`. 또는 2시간을 기다리면 상태가 자동으로 만료됩니다.

### Claude Code 외부에서 사용할 수 있나요?

핵심 SKILL.md는 시스템 프롬프트를 지원하는 모든 AI 도구에 복사하여 붙여넣을 수 있습니다. Hooks와 상태 유지 기능은 Claude Code 전용입니다.

### Ralph Boost와의 관계는 무엇인가요?

[Ralph Boost](ralph-boost-guide.md)는 Block Break의 핵심 메커니즘(L0-L4, 5단계 방법론, 7항목 체크리스트)을 **자율 루프** 시나리오에 적용한 것입니다. Block Break는 대화형 세션용(hooks 자동 발동)이고, Ralph Boost는 무인 개발 루프용(Agent 루프 / 스크립트 기반)입니다. 코드는 완전히 독립적이며, 개념을 공유합니다.

### Block Break의 skill 파일을 검증하려면 어떻게 하나요?

[Skill Lint](skill-lint-guide.md)를 사용하세요: `/skill-lint .`

---

## 라이선스

[MIT](../../../../LICENSE) - [juserch](https://github.com/juserch)
