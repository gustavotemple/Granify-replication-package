# MSc-host-env-config
MSc host environment configuration

## Repositories list

### Spinnaker

- [front50](https://github.com/gustavotemple/front50)
- [orca](https://github.com/gustavotemple/orca)
- [clouddriver](https://github.com/gustavotemple/clouddriver)

### Choerodon

- [hzero-starter-parent](https://github.com/gustavotemple/hzero-starter-parent)
- [choerodon-register](https://github.com/gustavotemple/choerodon-register)
- [choerodon-platform](https://github.com/gustavotemple/choerodon-platform)
- [choerodon-iam](https://github.com/gustavotemple/choerodon-iam)
- [choerodon-asgard](https://github.com/gustavotemple/choerodon-asgard)
- [workflow-service](https://github.com/gustavotemple/workflow-service)

## Used repositories branch

### Spinnaker

- front50: `v2.28.4`
- orca: `v8.31.5`
- clouddriver: `v5.80.7`

### Choerodon

- hzero-starter-parent: `1.4`
- choerodon-register: `v2.0.0`
- choerodon-platform: `v2.0.3`
- choerodon-iam: `v2.0.8`
- choerodon-asgard: `v2.0.3`
- workflow-service: `v2.0.3`

## How to build

All repositories have a `Dockerfile` with instructions on how to build inside.
Examples below:

### Spinnaker

```bash
./gradlew --no-daemon <REPO>-web:installDist -x test
docker build -t <REPO> -f Dockerfile.ubuntu .
```

### Choerodon

```bash
mvn clean package spring-boot:repackage -Dmaven.test.skip=true
docker build -t choerodon-<REPO> -f Dockerfile .
```

## Repositories with Postman collection

### Spinnaker

- [front50](https://github.com/gustavotemple/front50/tree/v2.28.4-branch/postman)
- [orca](https://github.com/gustavotemple/orca/tree/v8.31.5-branch/postman)
- [clouddriver](https://github.com/gustavotemple/clouddriver/tree/v5.80.7-branch/postman)

### Choerodon

- [choerodon-iam](https://github.com/gustavotemple/choerodon-iam/tree/v2.0.8-branch/postman)
- [choerodon-asgard](https://github.com/gustavotemple/choerodon-asgard/tree/v2.0.3-branch/postman)
- [workflow-service](https://github.com/gustavotemple/workflow-service/tree/v2.0.3-branch/postman)

## Repositories with Gatling simulations

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
sbt "gatling:testOnly gatling.<Simulation>Test"
```
