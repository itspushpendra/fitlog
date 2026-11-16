# FitLog 2.1 — responsive fitness tracker

FitLog is a static, mobile-first fitness tracker using Supabase for private cloud entries.

## Files
- `index.html` — website application
- `supabase_schema.sql` — original database schema (already run for the first setup)
- `user_preferences_migration.sql` — **new** one-time migration for cloud-synced profile, goal and nutrition targets

## Update an existing GitHub Pages site
1. Replace the existing repository-root `index.html` with this updated `index.html`.
2. Add `user_preferences_migration.sql` to the repository (or open it locally to copy its SQL).
3. In Supabase → SQL Editor → New query, paste the contents of `user_preferences_migration.sql` and click Run. This creates a private per-user preferences table with Row Level Security. Do not rerun the original schema unless you need to recreate the original tables.
4. Wait for GitHub Pages to redeploy, then reload the site. If the old page is cached, hard refresh (Ctrl+Shift+R) or open a private/incognito tab.
5. Sign in with the same Supabase account. Open Goals & targets, set your goal weight and target date, choose Calculate goal & nutrition plan, review the estimates, then Save targets.

## What changed in 2.1
- Mobile-first layout: bottom scrollable navigation on small screens, responsive cards and charts, larger touch targets and 16px form controls to avoid mobile browser input zoom.
- Goals: target weight and deadline, required weekly change estimate, maintenance estimate and suggested daily calorie target.
- Daily overview: calorie target/remaining calories and current-versus-target protein, carbohydrate, fat and fibre.
- Running calorie estimates: use the user's current recorded/profile weight, duration-derived pace and running MET bands based on the 2024 Adult Compendium of Physical Activities. Manual calorie override remains available.
- Goal, profile and nutrition settings sync to Supabase through `user_preferences`; RLS restricts each row to its owner.

## Calorie-estimate notes
The running estimate uses Compendium MET categories by pace and the standard MET energy equation. FitLog subtracts 1 MET from the gross estimate when adding exercise to an already-estimated daily TDEE, to avoid counting resting energy twice. Estimates remain approximate; hills, wind, surface, running economy, fitness and individual physiology can change actual energy cost. Manual adjustment is available.

Distance-based running energy expenditure is broadly close to proportional to body mass × distance for ordinary steady running; a 10 km run is not normally more than ten times the energy of a 1 km run at the same pace and conditions. Pace-based MET estimates can make the per-minute and per-kilometre figures differ as intensity changes.

## Security
- Use only the Supabase project URL and publishable/anon key in the browser.
- Never use a service-role or secret key in this static site.
- Keep Supabase Row Level Security enabled. The original schema and the new preferences migration apply owner-only policies.
- Settings are kept locally until the migration has been run and a user is signed in; then they are synced to the signed-in user's private row.

## Sources for running estimates
- 2024 Adult Compendium of Physical Activities: https://pacompendium.com/running/
- Compendium update paper: https://pmc.ncbi.nlm.nih.gov/articles/PMC10818145/
