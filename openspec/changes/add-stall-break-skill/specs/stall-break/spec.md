# Capability: stall-break

## ADDED Requirements

### Requirement: Turn-end Stop hook with loop-guard

The `stall-break` skill SHALL register a `Stop`-type hook (forge's first) via
`skills/stall-break/hooks/hooks.json` that fires when the agent ends its turn, and it
SHALL be loop-guarded so it injects at most once per turn-cluster.

#### Scenario: Reactive stop is intercepted once
- **WHEN** the agent reaches turn-end and the Stop event JSON has `stop_hook_active` not true
- **THEN** the hook injects the `<STALL_BREAK_ACTIVATED>` self-check and returns `{"decision":"block",...}` so the agent runs the proactivity loop before stopping

#### Scenario: No infinite loop
- **WHEN** the Stop event JSON has `stop_hook_active == true` (a Stop hook already fired this turn-cluster)
- **THEN** the hook allows the stop (exit 0) and injects nothing

### Requirement: Proactivity loop injection contract

The injected self-check SHALL contain a fixed four-step loop and require the agent to run it in order before stopping.

#### Scenario: The four steps are present and ordered
- **WHEN** the self-check block is injected
- **THEN** it contains, in order: ① review ownership-scope progress/gaps, ② identify the next highest-leverage work, ③ drive it (do-and-verify / single reasoned recommendation / report-first for an authorization-gated action), ④ stop ONLY at a genuine decision point · blocker · authorization-needed action · units-all-clear — and even then end with "next I suggest X", not an open "what do you want?"

### Requirement: Noise and authorization boundaries

The skill SHALL NOT stack on the reactive hammers, SHALL NOT push the agent past authorization gates, and SHOULD reduce false positives at legitimate stop points.

#### Scenario: No stacking with reactive hammers
- **WHEN** block-break or claim-ground already triggered in the same turn-cluster
- **THEN** stall-break SHALL NOT also trigger

#### Scenario: Authorization gates still stop
- **WHEN** the next lever is an authorization-gated action (push / destructive op / tool install)
- **THEN** the injected text SHALL classify it under ③ as "report-first / report before authorization", NOT as something to drive autonomously

#### Scenario: Legitimate stop points are not false-fired
- **WHEN** the previous assistant message ends with a question, or an ExitPlanMode/decision was just delivered, or a cooldown window is active
- **THEN** the skill SHOULD skip the nudge (tracked + measured by evals' false-positive scenarios)

### Requirement: Runtime state and category

The skill SHALL persist cooldown/count state under `~/.forge/stall-break-state.json` (gitignored, not shared across skills), and its category SHALL be `hammer`.

#### Scenario: State location and category
- **WHEN** the skill records cooldown or trigger count
- **THEN** it writes to `~/.forge/stall-break-state.json`, and `metadata.category` in SKILL.md equals `hammer`
