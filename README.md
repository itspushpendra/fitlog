# FitLog 2.0 — Personal Fitness Tracker

A responsive dark-mode personal fitness dashboard. Static hosting can be free with GitHub Pages; cloud data can use the Supabase free tier.

## Features in this build
- Overview dashboard with daily nutrition, protein, estimated burn, water and recent activity
- Nutrition diary: calories, protein, carbs, fat, fibre
- Personal food library and quick-add
- Open Food Facts product search (internet required; verify labels)
- Weekly / monthly-style 7-day and 30-day nutrition graphs
- Energy balance with BMR/TDEE estimate, exercise burn estimate and manual exercise burn override
- Running log: distance, duration, pace, intensity, estimated burn, recent runs and distance chart
- Strength log: exercises, sets, reps, load, total training volume and estimated burn
- Body metrics: weight, waist, chest, arm and thigh measurements
- Recovery: sleep, water, energy, soreness
- Weekly and monthly analytics, text report download and CSV export
- Editable targets with suggested starting targets
- Supabase email magic-link authentication and per-user Row Level Security

## Setup
1. Create a free project at https://supabase.com.
2. In Supabase SQL Editor, run all of `supabase_schema.sql`.
3. In Supabase Project Settings → API, copy the Project URL and publishable key (or legacy anon key).
4. Open `index.html`, choose Setup, paste the URL and publishable/anon key, then connect using your email magic link.
5. For hosted use, create a GitHub repository and upload `index.html`. In Settings → Pages choose Deploy from a branch, `main`, `/ (root)`.
6. Add your GitHub Pages URL to Supabase Authentication → URL Configuration → Redirect URLs.

## Security
- Browser code may contain only the Supabase publishable/anon key, never a service-role or secret key.
- Row Level Security is enabled on every personal data table; each policy restricts rows to `auth.uid() = user_id`.
- Keep your email account secure. The app does not expose your logs publicly.

## Important limitations / next iteration
- The prototype currently stores user targets and energy profile in the browser's local storage; cloud sync of preferences can be added in a follow-up schema update.
- Food search uses Open Food Facts. Coverage and nutritional data quality vary; verify product labels.
- Exercise calories and TDEE are estimates. BMR/TDEE settings are user-entered assumptions; exercise is displayed separately and added to baseline TDEE once, avoiding double-counting.
- The app has basic add-and-view flows. Editing/deleting records, meal/recipe builder, barcode scanning, import, and automatic PDF generation need a subsequent iteration.
- Reports export as CSV and plain-text summary in this build, not PDF.
- No progress photo storage is included, per your choice.
- No fabricated historical data is inserted. Graphs populate as you log actual entries.
- This is a tracking tool, not medical advice.
