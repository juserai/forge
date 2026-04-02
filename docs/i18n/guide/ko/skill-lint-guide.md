# Skill Lint 사용 가이드

> 3분 만에 시작하세요 — Claude Code skill의 품질을 검증합니다

---

## 설치

### Claude Code (권장)

```bash
claude plugin add juserch/jskills
```

### 범용 원라인 설치

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/skill-lint/SKILL.md
```

> **제로 의존성** — Skill Lint는 외부 서비스나 API가 필요 없습니다. 설치하면 바로 사용할 수 있습니다.

---

## 명령어

| 명령어 | 기능 | 사용 시점 |
|--------|------|-----------|
| `/skill-lint` | 사용법 안내 표시 | 사용 가능한 검사 항목 확인 |
| `/skill-lint .` | 현재 프로젝트 린트 | 개발 중 자체 점검 |
| `/skill-lint /path/to/plugin` | 특정 경로 린트 | 다른 플러그인 리뷰 |

---

## 사용 사례

### 새 skill 생성 후 자체 점검

`skills/<name>/SKILL.md`, `commands/<name>.md` 및 관련 파일을 생성한 후 `/skill-lint .`를 실행하여 구조가 완전한지, frontmatter가 올바른지, marketplace 항목이 추가되었는지 확인합니다.

### 다른 사람의 플러그인 리뷰

PR을 리뷰하거나 다른 플러그인을 감사할 때 `/skill-lint /path/to/plugin`을 사용하여 파일 완전성과 일관성을 빠르게 점검합니다.

### CI 연동

`scripts/skill-lint.sh`는 CI 파이프라인에서 직접 실행할 수 있으며, 자동화된 파싱을 위해 JSON을 출력합니다:

```bash
bash skills/skill-lint/scripts/skill-lint.sh /path/to/plugin
```

---

## 검사 항목

### 구조 검사 (Bash 스크립트로 실행)

| 규칙 | 검사 내용 | 심각도 |
|------|----------|--------|
| S01 | `plugin.json`이 루트와 `.claude-plugin/` 모두에 존재하는지 | error |
| S02 | `.claude-plugin/marketplace.json`이 존재하는지 | error |
| S03 | 각 `skills/<name>/`에 `SKILL.md`가 포함되어 있는지 | error |
| S04 | SKILL.md frontmatter에 `name`과 `description`이 포함되어 있는지 | error |
| S05 | 각 skill에 대응하는 `commands/<name>.md`가 있는지 | warning |
| S06 | 각 skill이 marketplace.json `plugins` 배열에 등록되어 있는지 | warning |
| S07 | SKILL.md에서 참조하는 references 파일이 실제로 존재하는지 | error |
| S08 | `evals/<name>/scenarios.md`가 존재하는지 | warning |

### 의미 검사 (AI로 실행)

| 규칙 | 검사 내용 | 심각도 |
|------|----------|--------|
| M01 | description이 목적과 트리거 조건을 명확히 기술하는지 | warning |
| M02 | name이 디렉토리 이름과 일치하는지, description이 파일 간 일관적인지 | warning |
| M03 | 명령어 라우팅 로직이 skill 이름을 올바르게 참조하는지 | warning |
| M04 | references 내용이 SKILL.md와 논리적으로 일관적인지 | warning |
| M05 | 평가 시나리오가 핵심 기능 경로를 커버하는지 (최소 5개) | warning |

---

## 예상 출력 예시

### 모든 검사 통과

```
Skill Lint Complete
┌──────────────────┬───────────────────────────────┐
│ Target path      │ /path/to/plugin               │
├──────────────────┼───────────────────────────────┤
│ Structural checks│ ✓ 19 passed · ✗ 0 errors     │
├──────────────────┼───────────────────────────────┤
│ Semantic checks  │ ✓ 5 passed · ⚠ 0 warnings    │
└──────────────────┴───────────────────────────────┘
```

### 문제 발견

```
Skill Lint Complete
┌──────────────────┬───────────────────────────────┐
│ Target path      │ /path/to/plugin               │
├──────────────────┼───────────────────────────────┤
│ Structural checks│ ✓ 5 passed · ✗ 2 errors      │
├──────────────────┼───────────────────────────────┤
│ Semantic checks  │ ✓ 3 passed · ⚠ 1 warning     │
└──────────────────┴───────────────────────────────┘

Errors:
  1. skills/foo/SKILL.md: missing required field 'description'
  2. .claude-plugin/marketplace.json: skill 'foo' not listed

Warnings:
  1. skills/foo/SKILL.md: description does not match marketplace.json
```

---

## 워크플로우

```
/skill-lint [path]
      │
      ▼
  Run skill-lint.sh ──→ JSON 구조 검사 결과
      │
      ▼
  AI가 skill 파일 읽기 ──→ 의미 검사
      │
      ▼
  통합 출력 (error > warning > passed)
```

---

## FAQ

### 의미 검사 없이 구조 검사만 실행할 수 있나요?

가능합니다 — bash 스크립트를 직접 실행하세요:

```bash
bash skills/skill-lint/scripts/skill-lint.sh .
```

AI 의미 분석 없이 순수 JSON을 출력합니다.

### jskills 외의 프로젝트에서도 사용할 수 있나요?

가능합니다. 표준 Claude Code 플러그인 구조(`skills/`, `commands/`, `.claude-plugin/`)를 따르는 모든 디렉토리를 검증할 수 있습니다.

### error와 warning의 차이는 무엇인가요?

- **error**: skill의 로딩이나 배포를 방해하는 구조적 문제
- **warning**: 기능에는 영향을 주지 않지만 유지보수성과 발견 가능성에 영향을 미치는 품질 문제

### 다른 jskills 도구

Skill Lint는 jskills 컬렉션의 일부이며, 다음 skill들과 함께 활용하면 효과적입니다:

- [Block Break](block-break-guide.md) — AI가 모든 방법을 소진하도록 강제하는 고능동성 행동 제약 엔진
- [Ralph Boost](ralph-boost-guide.md) — Block Break 수렴 보장이 내장된 자율 개발 루프 엔진

새 skill을 개발한 후 `/skill-lint .`를 실행하여 구조적 완전성을 확인하고, frontmatter, marketplace.json, 참조 링크가 모두 올바른지 검증하세요.

---

## 라이선스

[MIT](../../../../LICENSE) - [juserch](https://github.com/juserch)
