# Manual test: P003 Chunk 1 — Safe-area score HUD

Use this list to check off devices. In **Simulator**, switch device via **File → Open Simulator → [device]** (or the device submenu). The app is already installed on both; run it from the home screen or re-launch from Xcode with the chosen device.

---

- [x] **Manual test: iPhone 16 Plus** — Score HUD fully visible below Dynamic Island; not clipped by notch.
- [x] **Manual test: P002-iPhone-SE-3 (iPhone SE 3rd gen)** — Score HUD near top with no excessive gap.

**Validated:** User confirmed looks good on tested devices.

---

**What to check**

- **Dynamic Island device (e.g. iPhone 16 Plus):** “Score: X | High: Y” is fully visible below the safe area (not under the island/notch).
- **iPhone SE:** Same HUD visible near the top with a normal, non-excessive gap.

**How to switch simulator device**

1. In Simulator menu: **File → Open Simulator → iOS 18.5 → iPhone 16 Plus** (or **P002-iPhone-SE-3**).
2. On the simulator home screen, tap **CatRunner** to launch (app is already installed).
