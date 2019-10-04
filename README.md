# Tixdrop

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix


## Docker

### Build and run docker

1. Create Docker image.

   ```bash
   docker-compose build
   ```

1. Run docker image.
   ```bash
   docker-compose up
   ```

### Docker Machine

Create a droplet on digital ocean named tixdroptest.

```bash
docker-machine create --driver digitalocean --digitalocean-access-token XXXXXX tixdroptest
```

Run the eval command to configure docker machine and activate tixdroptest.
Now the docker compose commands will be run on the server.

```bash
docker-machine env tixdroptest
eval $(docker-machine env tixdroptest)
```

List the images and verify that tixdroptest is active.

```bash
docker-machine ls
```

Build the server and create the docker image.
Start it on the server.

```bash
docker-compose build
docker-compose up
```

To start the composed images on the server, but leave them running.

```bash
docker-compose up -d
```

To stop the server.

```bash
docker-compose stop
```

To remove a host and all of its containers and images, first stop the machine, then use

```bash
docker-machine rm tixdroptest
```

To SSH into the host

```bash
docker-machine ssh tixdroptest
```

To remove all unused (unrunning?) images

```base
docker system prune -a
```

### Running `bash` console in the running container

1. Determine container name.

   ```bash
    $ docker ps
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                NAMES
    a9890a2a0dbc        web:latest          "./entrypoint.sh"        8 minutes ago       Up 8 minutes        0.0.0.0:80->80/tcp   yunque_web_1
    5a9b68f3659c        postgres:10.3       "docker-entrypoint.s…"   3 weeks ago         Up 3 weeks          5432/tcp             yunque_db_1
   ```

1. Next, execute an interactive bash shell on the container.

```bash
$ docker exec -it tixmatic_web_1 bash
```

### Running `iex` console in running container

1. Determine container ID

   ```bash
   $ docker ps
   CONTAINER ID        IMAGE               COMMAND                  CREATED ...
   b65038e4ce7e        web:latest          "mix do ecto.create,…"   53 secon...
   5f02775f9714        postgres:10.3       "docker-entrypoint.s…"   3 hours ...
   ```

1. Run `docker exec`

   ```bash
   $ docker exec -it b65038e4ce7e iex -S mix
   Erlang/OTP 21 [erts-10.0.4] [source] [64-bit] [smp:1:1] [ds:1:1:10] [async-threads:1] [hipe]

   Interactive Elixir (1.7.1) - press Ctrl+C to exit (type h() ENTER for help)
   iex(1)> _
   ```

### To test the proxy servers

```bash
curl -x http://gw1.geosurf.io:8230 --proxy-user 9295:e5j5yupjy -L http://geo.geosurf.io
```

### To connect to PostgreSQL

First run bash on the web container.

The use PSQL to login to the database.

```bash
$ psql -d tix_prod -U  tix -W
Password:
```