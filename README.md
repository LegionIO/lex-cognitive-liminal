# lex-cognitive-liminal

Threshold crossing model for LegionIO cognitive agents. Based on anthropological liminality theory, tracks transitions through separation, margin, and incorporation phases while measuring ambiguity and creative potential in the in-between space.

## What It Does

- Begin crossings from an origin state to a destination state within a domain
- Three-phase progression: separation → margin (liminal) → incorporation
- Track ambiguity (peaks mid-transition) and creative potential (highest in fertile liminal space)
- `advance` / `crystallize` push crossings forward; `dissolve` regresses and increases ambiguity
- Identify fertile crossings (high creative potential), peak-liminality crossings, and domain clusters
- Supports up to 200 simultaneous transitions

## Usage

```ruby
# Start a crossing
result = runner.begin_crossing(
  origin: :certainty, destination: :new_framework, domain: :architecture
)
crossing_id = result[:crossing][:id]

# Advance through phases
runner.advance_crossing(crossing_id: crossing_id)
# => { success: true, crossing: { phase: :separation, progress: 0.07, ambiguity: 0.5, ... } }

# In the margin — dissolve for more ambiguity (creative space)
runner.dissolve_crossing(crossing_id: crossing_id)

# Crystallize to resolve and advance
runner.crystallize_crossing(crossing_id: crossing_id)

# Find all crossings in the fertile liminal state
runner.fertile_crossings
# => { success: true, crossings: [...], count: N }

# Overall status
runner.liminal_status
# => { success: true, total_active: N, liminal_count: N, avg_ambiguity: 0.XX, avg_creative_potential: 0.XX, ... }
```

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT
