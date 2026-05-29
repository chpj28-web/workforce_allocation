create table if not exists public.timestamp_with_dept (
  id bigint generated always as identity primary key,
  run_id uuid not null references public.allocation_runs(id) on delete cascade,
  target_date text,
  emp_id text not null,
  name text,
  dept text,
  position text,
  shift text,
  shift_start text,
  scan_in text,
  attendance_status text,
  minutes_late integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (run_id, emp_id)
);

alter table public.timestamp_with_dept enable row level security;

grant select, insert, update, delete on public.timestamp_with_dept to anon, authenticated;
grant usage, select on sequence public.timestamp_with_dept_id_seq to anon, authenticated;

drop policy if exists "timestamp_with_dept_public_all" on public.timestamp_with_dept;
create policy "timestamp_with_dept_public_all"
on public.timestamp_with_dept for all
to anon, authenticated
using (
  exists (
    select 1
    from public.allocation_runs runs
    where runs.id = timestamp_with_dept.run_id
      and runs.owner_id is null
  )
)
with check (
  exists (
    select 1
    from public.allocation_runs runs
    where runs.id = timestamp_with_dept.run_id
      and runs.owner_id is null
  )
);

drop policy if exists "timestamp_with_dept_owner_all" on public.timestamp_with_dept;
create policy "timestamp_with_dept_owner_all"
on public.timestamp_with_dept for all
to authenticated
using (
  exists (
    select 1
    from public.allocation_runs runs
    where runs.id = timestamp_with_dept.run_id
      and runs.owner_id = auth.uid()
  )
)
with check (
  exists (
    select 1
    from public.allocation_runs runs
    where runs.id = timestamp_with_dept.run_id
      and runs.owner_id = auth.uid()
  )
);
