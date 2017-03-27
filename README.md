# TriviaCompass

Find and play some trivia with triviacompass.com!

## set up database users
```sh
sudo psql -U <username> -1 -c "CREATE USER trivia_user WITH PASSWORD 'password';"
```

```sh
sudo psql -U <username> -1 -c "ALTER USER trivia_user WITH SUPERUSER;"
```

## create db
```sh
rake db:create
rake db:schema:load
rake db:seed
```
