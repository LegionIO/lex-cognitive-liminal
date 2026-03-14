# lex-cognitive-liminal

**Level 3 Leaf Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-agentic/CLAUDE.md`

## Purpose

Threshold crossing model based on anthropological liminality theory (van Gennep / Turner). Tracks cognitive transitions through three phases: `separation` (leaving the old state), `margin` (the liminal in-between), and `incorporation` (arriving at the new state). Each crossing tracks ambiguity (peaks at the liminal threshold), creative potential (highest in fertile liminal space), and progress (0.0 → 1.0).

## Gem Info

- **Gem name**: `lex-cognitive-liminal`
- **Module**: `Legion::Extensions::CognitiveLiminal`
- **Version**: `0.1.0`
- **Ruby**: `>= 3.4`
- **License**: MIT

## File Structure

```
lib/legion/extensions/cognitive_liminal/
  version.rb
  client.rb
  helpers/
    constants.rb
    threshold_crossing.rb
    liminal_engine.rb
  runners/
    cognitive_liminal.rb
```

## Key Constants

| Constant | Value | Purpose |
|---|---|---|
| `MAX_TRANSITIONS` | `200` | Per-engine crossing capacity |
| `DEFAULT_AMBIGUITY` | `0.5` | Starting ambiguity for new crossings |
| `AMBIGUITY_GROWTH` | `0.08` | Ambiguity increase per `dissolve!` call |
| `AMBIGUITY_RESOLUTION` | `0.12` | Ambiguity decrease per `crystallize!` call |
| `CREATIVE_POTENTIAL_PEAK` | `0.7` | Creative potential at peak liminality |
| `DISSOLUTION_RATE` | `0.05` | Default progress regression rate |
| `CRYSTALLIZATION_RATE` | `0.07` | Default progress advancement rate |
| `SEPARATION_THRESHOLD` | `0.3` | Progress cutoff for separation phase |
| `LIMINAL_PEAK` | `0.7` | Progress value for peak liminality |
| `INCORPORATION_THRESHOLD` | `0.9` | Progress cutoff for incorporation phase |
| `TRANSITION_PHASES` | `%i[separation margin incorporation complete]` | Valid phases |
| `ORIGIN_STATES` / `DESTINATION_STATES` | symbol arrays | Valid state labels |
| `LIMINAL_QUALITIES` | symbol array | Tags for the in-between quality |

## Helpers

### `Helpers::ThresholdCrossing`
Single crossing instance. Has `id`, `origin_state`, `destination_state`, `domain`, `progress`, `ambiguity`, `creative_potential`, `phase`, and `completed_at`.

- `advance!(rate)` — increases progress via `CRYSTALLIZATION_RATE`, advances phase
- `dissolve!(rate)` — regresses progress, increases ambiguity
- `crystallize!(rate)` — advances progress, reduces ambiguity
- `complete!` — marks crossing done, sets `completed_at`
- `liminal?` — phase is `:margin`
- `separated?` — phase is `:separation`
- `incorporated?` — phase is `:incorporation` or `:complete`
- `peak_liminality?` — progress near `LIMINAL_PEAK`
- `fertile?` — creative potential above a threshold
- Label methods for ambiguity, creative potential, and phase

### `Helpers::LiminalEngine`
Manages all crossings. Enforces `MAX_TRANSITIONS`.

- `begin_crossing(origin:, destination:, domain:)` → crossing
- `advance_crossing(crossing_id:)` → crossing state
- `dissolve_crossing(crossing_id:)` → crossing state
- `crystallize_crossing(crossing_id:)` → crossing state
- `active_crossings` → all incomplete crossings
- `completed_crossings` → all complete crossings
- `liminal_crossings` → crossings currently in margin phase
- `fertile_crossings` → crossings with high creative potential
- `peak_crossings` → crossings at peak liminality
- `crossings_by_domain(domain:)` → filtered list
- `average_ambiguity` → float
- `average_creative_potential` → float
- `liminal_density` → ratio of liminal to total active crossings
- `most_liminal` → crossing with highest ambiguity
- `liminal_report` → aggregate stats hash

## Runners

Module: `Runners::CognitiveLiminal`

| Runner Method | Description |
|---|---|
| `begin_crossing(origin:, destination:, domain:)` | Start a new transition |
| `advance_crossing(crossing_id:)` | Push crossing forward |
| `dissolve_crossing(crossing_id:)` | Regress and increase ambiguity |
| `crystallize_crossing(crossing_id:)` | Advance and reduce ambiguity |
| `active_crossings` | All in-progress crossings |
| `liminal_crossings` | Crossings in margin phase |
| `fertile_crossings` | Crossings with high creative potential |
| `liminal_status` | Full aggregate report |

All runners return `{success: true/false, ...}` hashes.

## Integration Points

- No direct dependencies on other agentic LEX gems
- Fits `lex-tick` `action_selection` phase: high ambiguity crossings can prompt consultation behavior
- Creative potential peaks can feed into `lex-emotion` as a positive arousal signal
- Peak liminality states represent prime conditions for insight — can trigger `lex-dream` association walks
- `lex-identity` entropy checks may coincide with high-ambiguity transitions

## Development Notes

- `Client` instantiates `@liminal_engine = Helpers::LiminalEngine.new`
- Phase transitions are implicit: `advance!` checks progress thresholds against `SEPARATION_THRESHOLD`, `LIMINAL_PEAK`, and `INCORPORATION_THRESHOLD`
- A crossing can complete only by reaching `INCORPORATION_THRESHOLD` via `advance!` or `crystallize!`
- `fertile?` is true when creative potential >= `CREATIVE_POTENTIAL_PEAK * 0.9` (near peak)
- Ambiguity and creative potential are independent dimensions: high ambiguity + high creative potential = the fertile liminal state
