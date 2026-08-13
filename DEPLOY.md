# Program Command Center Deployment

## Architecture

This version works on GitHub Pages as a static site.

- GitHub Pages hosts `index.html`.
- Supabase stores the shared Program JSON.
- Everyone can read the Program.
- Only authenticated users whose email is listed in `public.program_editors` can save changes.

No database password or `service_role` key is used by the frontend.

## Supabase Setup

1. Open Supabase SQL Editor.
2. Run `supabase-setup.sql`.
3. Add editor emails:

```sql
insert into public.program_editors (email)
values ('your-editor@example.com')
on conflict (email) do nothing;
```

4. In Supabase `Authentication` -> `Providers`, enable `Email`.

5. Create editor users in Supabase `Authentication` -> `Users`.

Use the same email that you inserted into `public.program_editors`.

For the simplest internal setup, either:

- create users manually and mark the email as confirmed, or
- disable email confirmation in Supabase Auth email settings.

6. In Supabase Authentication URL settings, set `Site URL` to your GitHub Pages URL, for example:

```text
https://<github-user>.github.io/<repo-name>/
```

7. In the same Supabase Authentication URL settings, add the same GitHub Pages URL as an allowed redirect URL:

```text
https://<github-user>.github.io/<repo-name>/
```

## GitHub Pages Setup

1. Create a GitHub repository.
2. Upload `index.html`, `DEPLOY.md`, and `supabase-setup.sql`.
3. Go to repository `Settings` -> `Pages`.
4. Select deploy from branch, usually `main` and `/root`.
5. Open the GitHub Pages URL.

## Usage

- Visitors can view without signing in.
- Editors click `Sign In`, enter their approved email and password.
- After sign-in, edits are saved to Supabase automatically.
- `Export JSON` remains available as a backup.
