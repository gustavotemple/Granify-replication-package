# Granify-replication-package
Granify replication package

## Content

1. [Analyzed Repositories](https://github.com/gustavotemple/MSc-host-env-config#repositories-list)
2. [How to build](https://github.com/gustavotemple/MSc-host-env-config#how-to-build)
3. [How to run](https://github.com/gustavotemple/MSc-host-env-config#how-to-run)
4. [Database seeding/initialization](https://github.com/gustavotemple/MSc-host-env-config#database-seedinginitialization)
5. [Postman collections](https://github.com/gustavotemple/MSc-host-env-config#postman-collections)
6. [Profiling](https://github.com/gustavotemple/MSc-host-env-config#profiling)
7. [Gatling simulations](https://github.com/gustavotemple/MSc-host-env-config#gatling-simulations)
8. [Aegeus](https://github.com/gustavotemple/MSc-host-env-config#aegeus)

## Analyzed Repositories (Experimental Unities)

`git clone` the repositories below:

### Spinnaker

#### Front50

- Repo: https://github.com/gustavotemple/front50
- Branch: `v2.28.4`
- Swagger: http://127.0.0.1:8080/swagger-ui.html

#### Orca

- Repo: https://github.com/gustavotemple/orca)
- Branch: `v8.31.5`
- Swagger: http://127.0.0.1:8083/swagger-ui.html

#### Clouddriver

- Repo: https://github.com/gustavotemple/clouddriver)
- Branch: `v5.80.7`
- Swagger: http://127.0.0.1:7002/swagger-ui.html

### Choerodon

#### hzero-starter-parent

- Repo: https://github.com/gustavotemple/hzero-starter-parent
- Branch: `1.4`

#### Register

- Repo: https://github.com/gustavotemple/choerodon-register
- Branch: `v2.0.0`
- URL: http://localhost:8000

#### Platform

- Repo: https://github.com/gustavotemple/choerodon-platform
- Branch: `v2.0.3`

#### IAM

- Repo: https://github.com/gustavotemple/choerodon-iam
- Branch: `v2.0.8`
- Swagger: http://localhost:8030/v2/api-docs

#### Asgard

- Repo: https://github.com/gustavotemple/choerodon-asgard
- Branch: `v2.0.3`
- Swagger: http://localhost:8040/v2/api-docs 

#### Workflow

- Repo: https://github.com/gustavotemple/workflow-service
- Branch: `v2.0.3`
- Swagger: http://localhost:8065/v2/api-docs

## How to build

All repositories have a `Dockerfile` with instructions on how to build inside.
Examples below:

### Spinnaker

```bash
./gradlew clean build -x test
./gradlew --no-daemon <REPO>-web:installDist -x test
docker build -t <REPO> -f Dockerfile.ubuntu .
```

### Choerodon

First of all, you need to build the `hzero-starter`, which is a dependency library.
After that:

```bash
mvn clean package spring-boot:repackage -Dmaven.test.skip=true
docker build -t choerodon-<REPO> -f Dockerfile .
```

## How to run

### Containerized

`docker-compose.yml` folder:

https://github.com/gustavotemple/MSc-host-env-config/tree/main/docker-composes

**Run:**

```bash
docker stack deploy --compose-file docker-compose.yml <NAME>
```

### Locally

#### Spinnaker

`./gradlew run`

#### Choerodon

```bash
mvn spring-boot:run
# or:
java -jar target/app.jar
```

## Database seeding/initialization

### Spinnaker

Just run the front50 Postman collection.

### Choerodon

Just follow the instructions in the Choerodon service READMEs.
Example:

```bash
./init-database.sh
```

In case of case-sensitive errors, use: `lower_case_table_names=1`

## Postman collections

### Spinnaker

- [front50](https://github.com/gustavotemple/front50/tree/v2.28.4-branch/postman)
- [orca](https://github.com/gustavotemple/orca/tree/v8.31.5-branch/postman)
- [clouddriver](https://github.com/gustavotemple/clouddriver/tree/v5.80.7-branch/postman)

### Choerodon

- [choerodon-iam](https://github.com/gustavotemple/choerodon-iam/tree/v2.0.8-branch/postman)
- [choerodon-asgard](https://github.com/gustavotemple/choerodon-asgard/tree/v2.0.3-branch/postman)
- [workflow-service](https://github.com/gustavotemple/workflow-service/tree/v2.0.3-branch/postman)


## Profiling

### How to build

Setup:
https://github.com/async-profiler/async-profiler

### How to run

CPU:

```bash
# spinnaker:
async-profiler/build/bin/asprof -I 'com/netflix/spinnaker/*' -d <SECONDS> -f <FILE-NAME>-cpu.html --title <TITLE>-cpu -e itimer <PID>
# choerodon
async-profiler/build/bin/asprof -I 'io/choerodon/*' -d <SECONDS> -f <FILE-NAME>-cpu.html --title <TITLE>-cpu -e itimer <PID>
```

Memory:

```bash
# spinnaker:
async-profiler/build/bin/asprof -I 'com/netflix/spinnaker/*' -d <SECONDS> -f <FILE-NAME>-mem.html --title <TITLE>-mem -e alloc <PID>
# choerodon
async-profiler/build/bin/asprof -I 'io/choerodon/*' -d <SECONDS> -f <FILE-NAME>-mem.html --title <TITLE>-mem -e alloc <PID>
```

## Gatling simulations

### Spinnaker

- [orca](https://github.com/gustavotemple/orca/tree/v8.31.5-branch/gatling)
- [clouddriver](https://github.com/gustavotemple/clouddriver/tree/v5.80.7-branch/gatling)

### Choerodon

- [choerodon-iam](https://github.com/gustavotemple/choerodon-iam/tree/v2.0.8-branch/gatling)
- [choerodon-asgard](https://github.com/gustavotemple/choerodon-asgard/tree/v2.0.3-branch/gatling)

### How to build

Using the SBT project:
https://github.com/gatling/gatling-sbt-plugin-demo

### How to run

```bash
sbt clean compile
sbt "gatling:testOnly gatling.<SIMULATION>Test"
```

## Aegeus
 
### Repositories

- https://github.com/MateusGabi/Aegeus
- https://github.com/MateusGabi/Aegeus-scripts

### Steps

**Step 1:** Get the path of each controller in the microservice

```bash
bash get_implementations_and_run_aegeus.sh /home/user/choerodon-repos
```

_Result:_ `SERVICES.out` file containing the paths of the controllers

**Step 2:** Aggregate the individual analyses of the controllers using the `writemsdescriptor` flag

```bash
java -jar Aegeus/target/Aegeus-1.0-SNAPSHOT-jar-with-dependencies.jar -ms ~/.aegeus/repos/home/user/choerodon-repos -p java -writemsdescriptor
```

_Result:_ `.msd` file with the analysis of each controller, containing `params`, `output` and `types`

**Step 3:** Analyze the metrics of the entire microservice using the `assessmetricsinmsa` flag

```bash
java -jar Aegeus/target/Aegeus-1.0-SNAPSHOT-jar-with-dependencies.jar -ms ~/.aegeus/repos/home/user/choerodon-repos -p java -assessmetricsinmsa
```

_Result:_ `.mr` file with the microservice analysis, containing `ServiceInterfaceDataCohesion`, `StrictServiceImplementationCohesion`, `LackOfMessageLevelCohesion` and `NumberOfOperations`

