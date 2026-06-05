# Testing with Substitutes (Nullables / Output Tracking) — Ruby

Scope: **Ruby test code only.**

Prefer **Substitutes** — hand-written fakes that return realistic data and record
observable telemetry — over mock/stub DSLs. Assert on what the system *did*, not
on mock expectations.

Canonical source: James Shore, *Testing Without Mocks* ("Nullables" / "Output
Tracking"). https://www.jamesshore.com/v2/projects/nullables/testing-without-mocks

## The pattern

An infrastructure-wrapping class (HTTP, SMS, blob storage, LLM, …) provides:

1. `self.build(...)` — wires the real low-level infrastructure (reading config via
   the project's env/defaults convention).
2. A nested `Substitute` (`Substitute.build` / `Substitute.build_failing`) that
   wires the **real** class around embedded fakes, so tests exercise real logic
   with infrastructure that never touches the network/disk.
3. Observable telemetry:
   - Outputs (sends, uploads, enqueues) → emit events (`EventEmitter`) and expose
     a tracker (`track_sends` → `OutputTracker#data`).
   - Inputs (reads, requests) → record what was asked (`requests`) and return
     queued responses, raising when the stubbed responses run out so an
     under-stubbed test fails loudly.

Substitutes are **production constructs** — nested in the class they substitute,
in the same file — not test-only helpers. Inject them through the collaborator's
constructor.

## When NOT to reach for this

- A plain value object (`Data` / `Struct`) is enough when there's no behaviour to
  fake — e.g. `StudyStub = Struct.new(:external_id)` to stand in for a record.
- Don't add a mock framework (mocha / rspec-mocks) to dodge writing a Substitute —
  the Substitute is the point.

## Worked examples

See `examples/` (self-contained, runnable with `ruby examples/substitutes_test.rb`):

- `event_emitter.rb`, `output_tracker.rb` — the output-telemetry plumbing.
- `sms_client.rb` — an OUTPUT adapter: `.build` + nested `Substitute` (`build` /
  `build_failing`), emits `:sent`, exposes `track_sends`.
- `http_client.rb` — an INPUT adapter: nested `Substitute` records `requests` and
  returns queued responses, raising when exhausted.
- `substitutes_test.rb` — Minitest asserting on tracked outputs and recorded
  requests (never on mock expectations).
