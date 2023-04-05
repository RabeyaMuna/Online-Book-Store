## Online Book Store
These steps are necessary to get the
application up and running..

## Rule Set for PR Reviews
A list of useful rules curated from PR reviews is complied into the following doc.

[Rule Set for PR Reviews](https://docs.google.com/document/d/1PF_Y5FHR9r9pMtIre9G2rp9hakSjsn9Qsi-savMjEac/edit)

## Run the Project in Development

#### Create your personal database config and edit it if necessary

```bash
cp config/database.example.yml config/database.yml
```

#### Create your personal environment configuration

```bash
cp .env.example .env
```

#### Install dependencies

```bash
bundle install
```

#### Create database, add migrations

```bash
bundle exec rails db:create
bundle exec rails db:migrate
```

##### Run Server

```bash
bundle exec rails server
```
