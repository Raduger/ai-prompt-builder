create table analytics_events (
  id serial primary key,
  user_id uuid references auth.users(id),
  event_type text not null,
  event_data jsonb,
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- Add tables for subscriptions, prompt_history, user roles, etc. here
