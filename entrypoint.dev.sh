#!/bin/bash -x
# Docker entrypoint script.
# -x echos commands

# Wait until Postgres is ready
while ! pg_isready -q -h $PGHOST -p $PGPORT -U $PGUSER
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

# Compile argon2_elixir for password hashing
RUN cd deps/argon2_elixir && make clean && make

# Enable this just to keep the server open
tail -f /dev/null

# cd /app
# exec mix do ecto.create, ecto.migrate, phx.server
# mix run priv/repo/seeds.exs