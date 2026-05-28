insert into storage.buckets (id, name, public)
values ('workforce-inputs', 'workforce-inputs', false)
on conflict (id) do nothing;

insert into storage.buckets (id, name, public)
values ('workforce-outputs', 'workforce-outputs', false)
on conflict (id) do nothing;

alter table public.allocation_runs
alter column owner_id drop not null;

alter table public.master_data_files
alter column owner_id drop not null;

alter table public.allocation_runs enable row level security;
alter table public.master_data_files enable row level security;

grant select, insert, update on public.allocation_runs to anon, authenticated;
grant select, insert, update on public.master_data_files to anon, authenticated;

drop policy if exists "runs_public_all" on public.allocation_runs;
create policy "runs_public_all"
on public.allocation_runs for all
to anon, authenticated
using (owner_id is null)
with check (owner_id is null);

drop policy if exists "master_files_public_all" on public.master_data_files;
create policy "master_files_public_all"
on public.master_data_files for all
to anon, authenticated
using (owner_id is null)
with check (owner_id is null);

drop policy if exists "input_files_public_select" on storage.objects;
create policy "input_files_public_select"
on storage.objects for select
to anon, authenticated
using (
  bucket_id = 'workforce-inputs'
  and (storage.foldername(name))[1] = 'public'
);

drop policy if exists "input_files_public_insert" on storage.objects;
create policy "input_files_public_insert"
on storage.objects for insert
to anon, authenticated
with check (
  bucket_id = 'workforce-inputs'
  and (storage.foldername(name))[1] = 'public'
);

drop policy if exists "input_files_public_update" on storage.objects;
create policy "input_files_public_update"
on storage.objects for update
to anon, authenticated
using (
  bucket_id = 'workforce-inputs'
  and (storage.foldername(name))[1] = 'public'
)
with check (
  bucket_id = 'workforce-inputs'
  and (storage.foldername(name))[1] = 'public'
);

drop policy if exists "output_files_public_select" on storage.objects;
create policy "output_files_public_select"
on storage.objects for select
to anon, authenticated
using (
  bucket_id = 'workforce-outputs'
  and (storage.foldername(name))[1] = 'public'
);
