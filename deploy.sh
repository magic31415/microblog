#!/bin/bash

echo "Beginning Deploy"

git pull
mix deps.get
mix ecto.migrate

(cd assets && npm install)
(cd assets && ./node_modules/brunch/bin/brunch b -p)

mix release.init
mix phx.digest
mix release --env=prod

rm -rf ../release_microblog
mkdir ../release_microblog
cp _build/prod/rel/microblog/releases/0.0.1/microblog.tar.gz ../release_microblog

cd ../release_microblog
tar xzvf microblog.tar.gz

./bin/microblog stop || true
PORT=8000 ./bin/microblog start
