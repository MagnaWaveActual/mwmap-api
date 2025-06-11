# MW Map API

This is a Ruby on Rails API that powers the MagnaWave Map application. The API manages users and practitioner locations, provides JWT based authentication and sends lead notifications via email.

## Requirements

- **Ruby** 3.1.2
- **Rails** 6.1.7
- **PostgreSQL** 9.1+

## Setup

1. Install Ruby and PostgreSQL.
2. Clone this repository and run `bin/setup` to install gems and prepare the database.
3. Configure the following environment variables:
   - `SECRET_KEY_BASE` – secret key for verifying JWT tokens.
   - `BACKEND_DATABASE_PASSWORD` – production database password.
   - `MAIL_USERNAME` and `MAIL_PASSWORD` – credentials for your SMTP provider.
4. Start the server with `bin/rails server`.

## Running tests

Execute the test suite with:

```bash
bin/rails test
```

## API overview

The application exposes several JSON endpoints for user registration, login and location search. Key routes include:

- `POST /user/login` – obtain a JWT token.
- `POST /user` – create a new user (admin only).
- `POST /find_locations` – search for active locations near a point.
- `POST /deactivated_locations` – list inactive locations.

Review `config/routes.rb` for the full list of paths.

## Deployment

This app is designed to run on Heroku or any environment capable of running Rails. Ensure all required environment variables are present before deploying.

