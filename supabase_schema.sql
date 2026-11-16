-- FITLOG 2.0 — Supabase schema
-- Run in Supabase Dashboard > SQL Editor.
-- Every user-owned table has RLS policies restricting access to its owner.

create extension if not exists pgcrypto;

create table if not exists public.food_entries (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 food_name text not null, meal text, quantity text,
 calories numeric not null default 0, protein_g numeric not null default 0,
 carbs_g numeric not null default 0, fat_g numeric not null default 0,
 fiber_g numeric not null default 0, logged_on date not null default current_date,
 created_at timestamptz not null default now()
);
create table if not exists public.food_library (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 food_name text not null, serving text,
 calories numeric not null default 0, protein_g numeric not null default 0,
 carbs_g numeric not null default 0, fat_g numeric not null default 0,
 fiber_g numeric not null default 0, created_at timestamptz not null default now()
);
create table if not exists public.running_entries (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 session_date date not null default current_date,
 distance_km numeric not null check(distance_km >= 0),
 duration_min numeric not null check(duration_min >= 0),
 pace_min_km numeric, heart_rate integer, intensity text,
 calories_burned numeric not null default 0, notes text,
 created_at timestamptz not null default now()
);
create table if not exists public.strength_sessions (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 session_date date not null default current_date,
 duration_min numeric not null default 0, focus text,
 exercises jsonb not null default '[]'::jsonb,
 volume_kg numeric not null default 0, calories_burned numeric not null default 0,
 notes text, created_at timestamptz not null default now()
);
create table if not exists public.body_metrics (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 measured_on date not null default current_date,
 weight_kg numeric, waist_cm numeric, chest_cm numeric, arm_cm numeric, thigh_cm numeric,
 created_at timestamptz not null default now()
);
create table if not exists public.water_entries (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 amount_ml integer not null check(amount_ml > 0),
 logged_on date not null default current_date, created_at timestamptz not null default now()
);
create table if not exists public.recovery_logs (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 sleep_hours numeric not null check(sleep_hours >= 0 and sleep_hours <= 24),
 energy_level integer check(energy_level between 1 and 5),
 soreness integer check(soreness between 1 and 5),
 notes text, logged_on date not null default current_date,
 created_at timestamptz not null default now(),
 unique(user_id, logged_on)
);

alter table public.food_entries enable row level security;
alter table public.food_library enable row level security;
alter table public.running_entries enable row level security;
alter table public.strength_sessions enable row level security;
alter table public.body_metrics enable row level security;
alter table public.water_entries enable row level security;
alter table public.recovery_logs enable row level security;

drop policy if exists "owner_food_entries" on public.food_entries;
create policy "owner_food_entries" on public.food_entries for all to authenticated using(auth.uid()=user_id) with check(auth.uid()=user_id);
drop policy if exists "owner_food_library" on public.food_library;
create policy "owner_food_library" on public.food_library for all to authenticated using(auth.uid()=user_id) with check(auth.uid()=user_id);
drop policy if exists "owner_running_entries" on public.running_entries;
create policy "owner_running_entries" on public.running_entries for all to authenticated using(auth.uid()=user_id) with check(auth.uid()=user_id);
drop policy if exists "owner_strength_sessions" on public.strength_sessions;
create policy "owner_strength_sessions" on public.strength_sessions for all to authenticated using(auth.uid()=user_id) with check(auth.uid()=user_id);
drop policy if exists "owner_body_metrics" on public.body_metrics;
create policy "owner_body_metrics" on public.body_metrics for all to authenticated using(auth.uid()=user_id) with check(auth.uid()=user_id);
drop policy if exists "owner_water_entries" on public.water_entries;
create policy "owner_water_entries" on public.water_entries for all to authenticated using(auth.uid()=user_id) with check(auth.uid()=user_id);
drop policy if exists "owner_recovery_logs" on public.recovery_logs;
create policy "owner_recovery_logs" on public.recovery_logs for all to authenticated using(auth.uid()=user_id) with check(auth.uid()=user_id);

create index if not exists food_entries_user_day_idx on public.food_entries(user_id,logged_on desc);
create index if not exists food_library_user_idx on public.food_library(user_id,food_name);
create index if not exists running_user_day_idx on public.running_entries(user_id,session_date desc);
create index if not exists strength_user_day_idx on public.strength_sessions(user_id,session_date desc);
create index if not exists body_user_day_idx on public.body_metrics(user_id,measured_on desc);
create index if not exists water_user_day_idx on public.water_entries(user_id,logged_on desc);
create index if not exists recovery_user_day_idx on public.recovery_logs(user_id,logged_on desc);
