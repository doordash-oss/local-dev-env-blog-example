# Local Microservice Development Environment Example

_By Mac Watrous mac.watrous@doordash.com_

This repository is intended as a companion piece for the following blog:

## Prerequisites

To run the example backend microservice in this repository you will need the following:

- Node version >= 16.13 but <17 installed.
  - https://nodejs.org/en/download/
- Docker Desktop installed and running.
  - https://www.docker.com/products/docker-desktop/
- postgresql installed.
  - `brew install postgresql`
- awslocal installed.
  - https://docs.localstack.cloud/integrations/aws-cli/#localstack-aws-cli-awslocal

## Running

First run the following commands:

```
npm install
```

Then to start the local development environment run:

```
docker-compose up
```

To spin down the local development environment you can just quit the docker-compose process by using `ctrl-c`.

## Making Changes

While the docker-compose environment is up the Node service will hotswap every time there is a change in the `src` directory. If you make changes outside of this directory that would affect the microservice application, such as installing a new npm package, etc. you will need to rebuild the backend microservice application for this change to reflect.

```
docker-compose build api
```

If you modify anything related to the database or the Terraform for the Localstack configuration, you will need to restart the docker-compose environment for these changes to take effect (aka there is no hotswapping for anything outside of the Node application). This can be down by quitting the docker-compose process (if its running) via `ctrl-c` and then starting it back up with `docker-compose up`.

## Example Requests

Add a new note

```
curl -H "Content-Type: application/json" -d '{"contents":"This is my test note!"}' "http://127.0.0.1:8080/notes"
```

Get a note by id

```
curl -H "Content-Type: application/json" "http://127.0.0.1:8080/notes/<id>"
```

## License

This library is released under the Apache 2.0 license. See [LICENSE](LICENSE.txt) for details.
