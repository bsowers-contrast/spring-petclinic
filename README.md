
# Modified Petclinic app for Demo

## Changes made to upstream code:

- move readme.md to upstream-readme.md
- modified docker-compose.yml to start petclinic in addition to mysql for a fully self contained environment.
- modified petclinic to have two datasources, petclinic and pii, to get petclinic some sensitive pii information
    - The Owner object was copied to a Customer object.  The Customer object is considered PII.
    These objects are accessible via the `/customers/..` REST path.
- Added a sample SQLI vulnerability on the `DELETE /customers/{customerId}` REST path.
- modified docker-compose.yml to run an Agent and read config from the local `/agent` dir where people
can change Agent binaries and configs without needing to change any docker-compose config or other code/config
files.
- Add multi-stage Dockerfile to build petclinic and produce a docker image. It
doesn't require a person to have any dev tools installed as all building happens in the docker image
- Change database initialization from default springboot directives to manually configured beans because
springboot doesn't support automatic initialization of multiple datasources.
- Add a fake "diagnostics" page just for some interesting demo content.
- Add Basic user/password auth to `/customers/*` endpoints.
  - The username is `user` and the password is `password`.
- Add outbound service call to an astrology service on the welcome page
- Add a file read action to get the welcome message for the welcome page.


Authenticating and Authorizing:
There are 3 different users with varying levels of permissions. 
Unfortunately, there isn’t a logout button yet, so in order to change your user, you must restart the server and log in again.

- Admin: U “admin” P “password” - this is the only role that has access to /owners endpoints
- User: U “user” P “password” - this is the role that has access to /customers endpoints
- No-role User: U “bob” P “password”


## Running PetClinic with Contrast AST/ADR/AVM with Docker Compose
The docker-compose setup in this repository is configured to pull the latest 
Contrast Agent version on build. It will start several instances of PetClinic
to simulate Dev, QA and Prod environments.

Each instance consists of two microservices: 
1. Petclinic Web Application: `${INITIALS}-ADR-PetClinic-Web`
2. PetClinic Email Service (for Log4Shell): `${INITIALS}-ADR-Email-Service`

Plus a MySQL database, an Nginx reverse proxy and a Log4ShellServer (attacker controlled listener).

Add a `contrast_security.yaml` file to the root of the repository with the 
following minimum content (you can download one from the contrast platform):
```yaml
api: 
  token: <your-agent-api-token>
observe:
  enable: true
```

To start the environment, run the following command:
```bash
docker-compose up --build
```

To stop the environment, run the following command:
```bash
docker-compose down -v
```

The Nginx reverse proxy resolves the following URLs to their respective 
services, which will appear in Contrast under the Dev, QA, and Production 
columns respectively:
- `http://dev.petclinic:10000/` -> `petclinic-app-assess`
- `http://qa.petclinic:10000/` -> `petclinic-app-qa`
- `http://prod.petclinic:10000/` -> `petclinic-app-protect`


To use the Nginx proxy locally on Mac, you will need to add the following to 
your `/etc/hosts` file:
```bash
# Added for local demo environment
127.0.0.1 dev.petclinic
127.0.0.1 qa.petclinic
127.0.0.1 prod.petclinic
```

## Exercising the applications to generate vulnerability findings and attack events
1. Exercise the dev instance by browsing the application and using functionality
as a user or QA tester normally would. Contrast will automatically detect
vulnerabilities as you normally use the application.
2. Attack vulnerable parts of the application in the Prod instance to generate
attack events. For example:
    - Use SQL Injection on the search field on `/customers` page: `' OR '1' = '1`
    - Use the Log4Shell vulnerability in the Email Service to execute arbitrary
    code on the server. For instructions see [Log4Shell-README.md](Log4Shell-README.md)
