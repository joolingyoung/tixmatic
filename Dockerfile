FROM codelever/ubuntu-phoenix-docker:ubuntu-1804-erlang-21-2-2-elixir-1-7-4-node-10-8-0

# install postgres client
RUN apt-get update && apt-get install -f -y postgresql-client

# install application
ENV APP_ROOT /app
RUN mkdir -p ${APP_ROOT}

# install and compile dependencies
ENV MIX_ENV prod
WORKDIR ${APP_ROOT}
ADD mix.exs mix.exs
ADD mix.lock mix.lock
ADD config config
ADD mix.exs mix.exs
ADD config config
RUN mix deps.get --only ${MIX_ENV} \
 && mix deps.compile
# Compile argon2_elixir for password hashing
RUN cd deps/argon2_elixir && make clean && make

# copy remaining application files
WORKDIR ${APP_ROOT}
ADD . .

# build application
WORKDIR ${APP_ROOT}
RUN mix compile
