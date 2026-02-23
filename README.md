# CatRunner

A Next.js app scaffold.

**Repository:** [https://github.com/GameswiththeKidsdotcom/CatRunner](https://github.com/GameswiththeKidsdotcom/CatRunner)

## Getting Started

Install dependencies:

```bash
npm install
```

Run the development server:

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

## Scripts

- `npm run dev` — Start development server
- `npm run build` — Build for production
- `npm run start` — Start production server
- `npm run lint` — Run ESLint
- `npm run test` — Run tests (watch mode)
- `npm run test:full` — Run full test suite once

## Project Structure

Root holds README and required config only. Logs in `logs/`, test reports in `reports/`. App code in `src/`, `ios/`, `e2e/`; docs in `docs/`; plans in `.cursor/Plans/`.

```
src/
├── app/           # Next.js App Router pages and layouts
├── components/    # Reusable React components
└── lib/          # Utilities and shared code
```

**Testing:** Testing documentation and test-plan index: [docs/testing/](docs/testing/).
