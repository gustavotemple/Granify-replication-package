# Granify replication package

This artifact provides the instructions for Granify, a method for guiding microservices decomposition through performance and modularity analysis.
This artifact contains a dataset with the paper's major results, microservices used, and a `README` with the steps on how to build and run the Granify method to replicate the results.
This artifact utilizes Docker to facilitate reuse.

## Content

1. [Analyzed Repositories](https://github.com/gustavotemple/Granify-replication-package#analyzed-repositories-experimental-unities)
2. [Requirements](https://github.com/gustavotemple/Granify-replication-package#requirements)
3. [How to build](https://github.com/gustavotemple/Granify-replication-package#how-to-build)
4. [How to run](https://github.com/gustavotemple/Granify-replication-package#how-to-run)
5. [Database seeding/initialization](https://github.com/gustavotemple/Granify-replication-package#database-seedinginitialization)
6. [Postman collections](https://github.com/gustavotemple/Granify-replication-package#postman-collections)
7. [Profiling](https://github.com/gustavotemple/Granify-replication-package#profiling)
8. [Gatling tests](https://github.com/gustavotemple/Granify-replication-package#gatling-tests)
9. [Aegeus](https://github.com/gustavotemple/Granify-replication-package#aegeus)
10. [Result examples](https://github.com/gustavotemple/Granify-replication-package#result-examples)

## Analyzed Repositories (Experimental Unities)

### Spinnaker

#### Front50

- Repo: https://github.com/gustavotemple/front50
- Branch: `v2.28.4`
- Swagger: http://<LOCALHOST>:8080/swagger-ui.html

#### Orca

- Repo: https://github.com/gustavotemple/orca
- Branch: `v8.31.5`
- Swagger: http://<LOCALHOST>:8083/swagger-ui.html

#### Clouddriver

- Repo: https://github.com/gustavotemple/clouddriver
- Branch: `v5.80.7`
- Swagger: http://<LOCALHOST>:7002/swagger-ui.html

### Choerodon

#### hzero-starter-parent

- Repo: https://github.com/gustavotemple/hzero-starter-parent
- Branch: `1.4`

#### Register

- Repo: https://github.com/gustavotemple/choerodon-register
- Branch: `v2.0.0`
- URL: http://<LOCALHOST>:8000

#### Platform

- Repo: https://github.com/gustavotemple/choerodon-platform
- Branch: `v2.0.3`

#### IAM

- Repo: https://github.com/gustavotemple/choerodon-iam
- Branch: `v2.0.8`
- Swagger: http://<LOCALHOST>:8030/v2/api-docs

#### Asgard

- Repo: https://github.com/gustavotemple/choerodon-asgard
- Branch: `v2.0.3`
- Swagger: http://<LOCALHOST>:8040/v2/api-docs 

#### Workflow

- Repo: https://github.com/gustavotemple/workflow-service
- Branch: `v2.0.3`
- Swagger: http://<LOCALHOST>:8065/v2/api-docs

## Requirements

- MySQL          `v5.7`
- Java           `v8` & `v11`
- Async Profiler `v2.10`
- Redis          `v6.0.16`
- Postman        `v10.19`
- Gatling        `v3.9.5`
- Docker         `v24.0.7`

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

Run `mvn clean install` in the folders below:
- hzero-starter-core
- hzero-starter-sqlparser

After that, for the other microservices:
```bash
mvn clean package spring-boot:repackage -Dmaven.test.skip=true
docker build -t choerodon-<REPO> -f Dockerfile .
```

## How to run

### Containerized

`docker-compose.yml` folder:

https://github.com/gustavotemple/Granify-replication-package/tree/main/docker-composes

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

Just run the front50 Postman collection (See [Postman collections](https://github.com/gustavotemple/Granify-replication-package#postman-collections)).

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
async-profiler/build/bin/asprof -I <PACKAGE> -d <SECONDS> -f <FILE-NAME>-cpu.html --title <TITLE>-cpu -e itimer <PID>
```

Examples:
```bash
# spinnaker:
async-profiler/build/bin/asprof -I 'com/netflix/spinnaker/*' -d 600 -f orca-cpu.html --title orca-cpu -e itimer 12345
# choerodon:
async-profiler/build/bin/asprof -I 'io/choerodon/*' -d 600 -f asgard-cpu.html --title asgard-cpu -e itimer 12345
```

Memory:
```bash
async-profiler/build/bin/asprof -I <PACKAGE> -d <SECONDS> -f <FILE-NAME>-mem.html --title <TITLE>-mem -e alloc <PID>
```

Examples:
```bash
# spinnaker:
async-profiler/build/bin/asprof -I 'com/netflix/spinnaker/*' -d 600 -f cloddriver-mem.html --title clouddriver-mem -e alloc 12345
# choerodon:
async-profiler/build/bin/asprof -I 'io/choerodon/*' -d 600 -f workflow-mem.html --title workflow-mem -e alloc 12345
```

## Gatling tests

Gatling Simulation documentation: https://docs.gatling.io/reference/script/core/simulation

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

**Step 1:** Build Aegeus with `mvn clean compile assembly:single`

https://github.com/MateusGabi/Aegeus

**Step 2:** Configure the script `get_implementations_and_run_aegeus.sh`

https://github.com/MateusGabi/Aegeus-scripts/blob/main/get_implementations_and_run_aegeus.sh

**Step 3:** Get the path of each web controller in the microservice

```bash
# Run:
bash get_implementations_and_run_aegeus.sh <PATH>
# Example:
bash get_implementations_and_run_aegeus.sh /home/user/choerodon-repos
```

_Result:_ `SERVICES.out` file containing the paths of the web controllers

**Step 4:** Aggregate the individual analyses of the web controllers using the `writemsdescriptor` flag

```bash
# Run:
java -jar Aegeus/target/Aegeus-1.0-SNAPSHOT-jar-with-dependencies.jar -ms ~/.aegeus/repos/<PATH> -p java -writemsdescriptor
# Example:
java -jar Aegeus/target/Aegeus-1.0-SNAPSHOT-jar-with-dependencies.jar -ms ~/.aegeus/repos/home/user/choerodon-repos -p java -writemsdescriptor
```

_Result:_ `.msd` file with the analysis of each web controller, containing `params`, `output` and `types`

**Step 5:** Analyze the metrics of the entire microservice using the `assessmetricsinmsa` flag

```bash
# Run:
java -jar Aegeus/target/Aegeus-1.0-SNAPSHOT-jar-with-dependencies.jar -ms ~/.aegeus/repos/<PATH> -p java -assessmetricsinmsa
# Example:
java -jar Aegeus/target/Aegeus-1.0-SNAPSHOT-jar-with-dependencies.jar -ms ~/.aegeus/repos/home/user/choerodon-repos -p java -assessmetricsinmsa
```

_Result:_ `.mr` file with the microservice analysis, containing `ServiceInterfaceDataCohesion`, `StrictServiceImplementationCohesion`, `LackOfMessageLevelCohesion` and `NumberOfOperations`

## Result examples

### Spinnaker

- [orca](https://github.com/gustavotemple/orca/tree/v8.31.5-branch/results)
- [clouddriver](https://github.com/gustavotemple/clouddriver/tree/v5.80.7-branch/results)

### Choerodon

- [choerodon-iam](https://github.com/gustavotemple/choerodon-iam/tree/v2.0.8-branch/results)
- [choerodon-asgard](https://github.com/gustavotemple/choerodon-asgard/tree/v2.0.3-branch/results)
- [workflow-service](https://github.com/gustavotemple/workflow-service/tree/v2.0.3-branch/results)
