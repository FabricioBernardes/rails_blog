# Rails Blog

## Objective
This is a simple blog application built with Ruby on Rails. The idea is based on the following MVP:

- CRUD for posts (title, body in markdown, excerpt, status: draft/published/scheduled)
- Basic authentication (sign up / sign in) and roles (author, editor, admin)
- Tags and categories
- Moderated comments
- Image uploads (ActiveStorage)
- Public page with listing, SEO-friendly permalinks, RSS
- Read-only API (list posts, show post)
- Basic tests + CI running tests
- README and basic deployment via Docker (local + instructions)

## Quick start (dev)
1. Make sure you have Docker and Docker Compose installed.
2. Create a `.env` file and add `RAILS_MASTER_KEY=<value from config/master.key>`.
3. Run `docker-compose up --build -d`.
4. In another terminal, run `docker-compose exec web bundle exec rails db:create db:migrate` to setup the database.
5. Run `docker-compose exec web ./bin/dev` to start the server. The application will be available at `http://localhost:3000`.

## Testes
`bundle exec rspec`

## Deploy
- CI runs tests and builds Docker image
- Environment variables:
