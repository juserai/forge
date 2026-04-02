# News Fetch 사용 가이드

> 3분 만에 시작하세요 — AI가 뉴스 브리핑을 가져다 줍니다

디버깅에 지쳤나요? 2분만 쉬면서 세상 돌아가는 소식을 확인하고, 잠깐의 휴식 후 상쾌하게 돌아오세요.

---

## 설치

### Claude Code (권장)

```bash
claude plugin add juserch/jskills
```

### 범용 원라인 설치

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/news-fetch/SKILL.md
```

> **제로 의존성** — News Fetch는 외부 서비스나 API 키가 필요 없습니다. 설치하면 바로 사용할 수 있습니다.

---

## 명령어

| 명령어 | 기능 | 사용 시점 |
|--------|------|-----------|
| `/news-fetch AI` | 이번 주 AI 뉴스 가져오기 | 빠른 업계 동향 확인 |
| `/news-fetch AI today` | 오늘의 AI 뉴스 가져오기 | 일일 브리핑 |
| `/news-fetch robotics month` | 이번 달 로보틱스 뉴스 가져오기 | 월간 리뷰 |
| `/news-fetch climate 2026-03-01~2026-03-31` | 특정 기간의 뉴스 가져오기 | 타깃 리서치 |

---

## 사용 사례

### 일일 기술 브리핑

```
/news-fetch AI today
```

오늘의 최신 AI 뉴스를 관련성 순으로 가져옵니다. 헤드라인과 요약을 몇 초 만에 훑어볼 수 있습니다.

### 업계 리서치

```
/news-fetch electric vehicles 2026-03-01~2026-03-31
```

특정 기간의 뉴스를 수집하여 시장 분석 및 경쟁 리서치를 지원합니다.

### 다국어 뉴스

중국어 주제는 자동으로 영어 보충 검색이 수행되어 더 넓은 범위를 커버하며, 그 반대도 마찬가지입니다. 추가 작업 없이 두 언어의 장점을 모두 누릴 수 있습니다.

---

## 예상 출력 예시

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

## 3단계 네트워크 폴백

News Fetch는 다양한 네트워크 환경에서 뉴스 수집이 가능하도록 내장 폴백 전략을 갖추고 있습니다:

| 단계 | 도구 | 데이터 소스 | 발동 조건 |
|------|------|------------|-----------|
| **L1** | WebSearch | Google/Bing | 기본값 (우선) |
| **L2** | WebFetch | Baidu News, Sina, NetEase | L1 실패 시 |
| **L3** | Bash curl | L2와 동일한 소스 | L2도 실패 시 |

모든 단계가 실패하면, 각 소스별 실패 사유를 나열한 구조화된 실패 보고서가 생성됩니다.

---

## 출력 기능

| 기능 | 설명 |
|------|------|
| **중복 제거** | 여러 소스가 같은 이벤트를 다루는 경우, 점수가 가장 높은 항목을 유지하고 나머지는 "관련 보도"로 축소합니다 |
| **요약 보완** | 검색 결과에 요약이 없는 경우, 기사 본문을 가져와 요약을 생성합니다 |
| **관련성 점수** | AI가 각 결과를 주제 관련성으로 점수 매깁니다 — 높을수록 관련성이 높습니다 |
| **클릭 가능한 링크** | Markdown 링크 형식 — IDE와 터미널에서 클릭할 수 있습니다 |

---

## FAQ

### API 키가 필요한가요?

아닙니다. News Fetch는 전적으로 WebSearch와 공개 웹 스크래핑에 의존합니다. 설정이 전혀 필요 없습니다.

### 영어 뉴스를 가져올 수 있나요?

물론입니다. 중국어 주제에는 자동으로 영어 보충 검색이 포함되며, 영어 주제는 기본적으로 지원됩니다. 두 언어 모두 커버합니다.

### 네트워크가 제한된 환경이면 어떻게 하나요?

3단계 폴백 전략이 자동으로 처리합니다. WebSearch를 사용할 수 없는 경우에도 News Fetch는 국내 뉴스 소스로 폴백합니다.

### 몇 개의 기사를 반환하나요?

최대 20개입니다(중복 제거 후). 실제 수는 데이터 소스가 반환하는 양에 따라 달라집니다.

---

## 라이선스

[MIT](../../../../LICENSE) - [juserch](https://github.com/juserch)
