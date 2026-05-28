alter table public.allocation_runs
alter column owner_id drop not null;

alter table public.master_data_files
alter column owner_id drop not null;

drop policy if exists "runs_public_all" on public.allocation_runs;
create policy "runs_public_all"
on public.allocation_runs for all
using (owner_id is null)
with check (owner_id is null);

drop policy if exists "master_files_public_all" on public.master_data_files;
create policy "master_files_public_all"
on public.master_data_files for all
using (owner_id is null)
with check (owner_id is null);

drop policy if exists "results_public_select" on public.allocation_results;
create policy "results_public_select"
on public.allocation_results for select
using (
  exists (
    select 1
    from public.allocation_runs runs
    where runs.id = allocation_results.run_id
      and runs.owner_id is null
  )
);

drop policy if exists "gaps_public_select" on public.gap_summaries;
create policy "gaps_public_select"
on public.gap_summaries for select
using (
  exists (
    select 1
    from public.allocation_runs runs
    where runs.id = gap_summaries.run_id
      and runs.owner_id is null
  )
);

drop policy if exists "input_files_public_select" on storage.objects;
create policy "input_files_public_select"
on storage.objects for select
using (
  bucket_id = 'workforce-inputs'
  and (storage.foldername(name))[1] = 'public'
);

drop policy if exists "input_files_public_insert" on storage.objects;
create policy "input_files_public_insert"
on storage.objects for insert
with check (
  bucket_id = 'workforce-inputs'
  and (storage.foldername(name))[1] = 'public'
);

drop policy if exists "input_files_public_update" on storage.objects;
create policy "input_files_public_update"
on storage.objects for update
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
using (
  bucket_id = 'workforce-outputs'
  and (storage.foldername(name))[1] = 'public'
);
