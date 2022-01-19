# Send to Allure Docker Service action

[![.github/workflows/main.yml](https://github.com/unickq/send-to-allure-docker-service-action/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/unickq/send-to-allure-docker-service-action/actions/workflows/main.yml)
[![GitHub release badge](https://badgen.net/github/release/unickq/send-to-allure-docker-service-action/stable)](https://github.com/unickq/send-to-allure-docker-service-action/releases/latest)
[![GitHub license badge](https://badgen.net/github/license/unickq/send-to-allure-docker-service-action)](http://www.apache.org/licenses/LICENSE-2.0)

Sends results to [fescobar/allure-docker-service](https://github.com/fescobar/allure-docker-service).

## Inputs

### `allure_results`

allure results directory to send.

Default - `allure-results`

______
### `project_id` 
project id in docker service

Default - `default`
______

### `auth`
turn auth on/off for sending

Default - `true`

______

## Secrets

- `ALLURE_SERVER_URL` - **required** server URL. 
- `ALLURE_SERVER_USER` - username. 
- `ALLURE_SERVER_PASSWORD` - password
#### [How to set secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)

## Example usage

```yml
jobs:
  allure-docker-send-example:
    runs-on: ubuntu-latest

    name: Send to Allure Docker Service

    env:
      ALLURE_SERVER_URL: ${{ secrets.ALLURE_SERVER_URL }}
      ALLURE_SERVER_USER: ${{ secrets.ALLURE_SERVER_USER }}
      ALLURE_SERVER_PASSWORD: ${{ secrets.ALLURE_SERVER_PASSWORD }}

    steps:
      - uses: actions/checkout@v2

      - uses: unickq/send-to-allure-docker-service-action@v1
        with:
          allure_results: allure-results
          project_id: actions
          auth: true
```