create table if not exists public.program_state (
  id text primary key,
  data jsonb not null,
  updated_at timestamptz not null default now()
);

create table if not exists public.program_editors (
  email text primary key,
  created_at timestamptz not null default now()
);

alter table public.program_state enable row level security;
alter table public.program_editors enable row level security;

drop policy if exists "Anyone can read program state" on public.program_state;
create policy "Anyone can read program state"
on public.program_state
for select
to anon, authenticated
using (true);

drop policy if exists "Editors can insert program state" on public.program_state;
create policy "Editors can insert program state"
on public.program_state
for insert
to authenticated
with check (
  exists (
    select 1
    from public.program_editors
    where email = auth.jwt() ->> 'email'
  )
);

drop policy if exists "Editors can update program state" on public.program_state;
create policy "Editors can update program state"
on public.program_state
for update
to authenticated
using (
  exists (
    select 1
    from public.program_editors
    where email = auth.jwt() ->> 'email'
  )
)
with check (
  exists (
    select 1
    from public.program_editors
    where email = auth.jwt() ->> 'email'
  )
);

drop policy if exists "Editors can read editor list" on public.program_editors;
create policy "Editors can read editor list"
on public.program_editors
for select
to authenticated
using (
  exists (
    select 1
    from public.program_editors
    where email = auth.jwt() ->> 'email'
  )
);

-- Add editor emails after running the table setup, for example:
-- insert into public.program_editors (email) values ('alex@example.com');
