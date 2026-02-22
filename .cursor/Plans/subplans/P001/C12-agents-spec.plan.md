# C12 — Agent Updates & SPECIFICATION.md

**Next hand off:** Implement C12 after all other chunks.

---

## Goal

Update Blaster and Tester agents for CatRunner scope; create full software specification document.

## Steps

1. **Blaster** (`Agents/blaster.md`): Add or replace TabletopGame scope with CatRunner scope — 1-player endless runner; 5 lanes; procedural segments; single avatar; obstacles and power-ups affect single player only.
2. **Tester** (`Agents/tester.md`): Add CatRunner test commands — `xcodebuild test -scheme CatRunner`; separate baseline for iOS tests vs `npm run test:full` (admin).
3. **SPECIFICATION.md** (`docs/SPECIFICATION.md`): Game concept and rules; VariantConfig schema; engine architecture; procedural generation rules; admin capabilities; CI/CD steps; testing requirements; asset structure; monetization/Live Ops schema; rollback, risks, validation; confidence scores per section.

## Validation

- Blaster/Tester invocations reference CatRunner scope; tester knows iOS test command.
- SPECIFICATION.md is complete and linked from Master-Plan.

## Rollback

- Revert agent edits; keep SPECIFICATION.md as doc-only.

## Confidence

- **Confidence (root cause):** N/A
- **Confidence (solution path):** N/A
