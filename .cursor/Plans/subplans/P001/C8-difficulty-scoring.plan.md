# C8 — Difficulty Scaling, Scoring, Revive

**Next hand off:** Implement C8 after C6 and C7.

---

## Goal

Difficulty scaling over time (speed, multi-lane prob, instant-fail prob); scoring/multipliers; revive mechanics.

## Steps

1. DifficultyScaler: read config (speedIncrementPerSegment, multiLaneProbabilityIncrement, instantFailProbabilityIncrement). Each segment (or every N segments) increase speed and probabilities.
2. Scoring: distance or time; optional multiplier from power-ups (e.g. speed boost).
3. Revive: on instant-fail, offer revive (IAP or rewarded ad stub); on accept, resume from last checkpoint or lane.
4. Persist high score locally (UserDefaults or file).

## Validation

- Unit test: difficulty params increase over segment count.
- Score increments; revive flow reaches resume state.

## Rollback

- Disable difficulty scaling; no revive (game over only).

## Confidence

- **Confidence (root cause):** N/A
- **Confidence (solution path):** N/A
