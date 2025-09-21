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
2. `docker-compose up --build`
3. `bundle exec rails db:create db:migrate`
4. `rails server`

## Testes
`bundle exec rspec`

## Deploy
- CI runs tests and builds Docker image
- Environment variables:
