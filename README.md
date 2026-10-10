# Java Web App: Maven, Docker, Jenkins and Kubernetes

A Java web application (WAR) built with Maven, packaged into a Tomcat container,
and deployed with a Jenkins pipeline, Ansible and Kubernetes. The repository
name refers to Docker, not Python: there is no Python code in this project.

> **Source note:** The web application and the pipeline examples are based on
> tutorial material from other authors. The Jenkinsfiles clone their repositories
> from the URLs shown below. This repository is a learning copy for practising the
> pipeline; it is not original application code.

## Contents

| File | Purpose |
|------|---------|
| `pom.xml` | Maven build, packages the app as `maven-web-app.war` |
| `src/main/webapp/` | JSP pages and `web.xml` |
| `Dockerfile` | Copies the WAR into Tomcat 9 on JDK 11 |
| `Jenkinsfile` | Pipeline: clone, build with Maven, then run the Ansible playbook |
| `Declarative-JenkinsFile` | Simpler pipeline: clone and build with Maven |
| `task.yml` | Ansible playbook: copies the Dockerfile and WAR, builds and pushes the image, applies the Kubernetes manifest |
| `k8s-deploy.yml` | Kubernetes Deployment (2 replicas) and LoadBalancer Service |

## Build and run locally

Requirements: JDK 11, Maven 3.9, Docker.

```bash
mvn clean package                    # creates target/maven-web-app.war
docker build -t maven-web-app:local .
docker run --rm -p 8080:8080 maven-web-app:local
# open http://localhost:8080/
```

## Deployment flow

1. Jenkins runs `mvn clean package` to produce the WAR file.
2. The `Create Image` stage runs `task.yml` with Ansible, which copies the Dockerfile and WAR to a build host, builds the image and pushes it to a registry.
3. The second play applies `k8s-deploy.yml` to the Kubernetes cluster, creating two pods and a LoadBalancer on port 80.

## Known issues to fix before use

- `task.yml` and `k8s-deploy.yml` reference the image `ashokit/mavenwebapp`, which belongs to the original tutorial author. Change these to an image in your own registry.
- The `Declarative-JenkinsFile` clones a different tutorial repository from the one used by `Jenkinsfile`. Pick one source.
- The Jenkins agent label `Ansible-Node` and the Maven tool name `Maven-3.9.6` must exist in your Jenkins configuration.
- The `task.yml` build and push steps use `command:` rather than the Ansible `docker_image` module. This works, but the module gives better error reporting.
- `pom.xml` depends on JUnit 3.8.1, which is very old. Update it if you add tests.

## What this project demonstrates

- Building a Java WAR with Maven.
- Packaging a web app in a Tomcat container.
- Writing a Jenkins declarative pipeline.
- Running an Ansible playbook from a pipeline stage.
- Deploying to Kubernetes with a Deployment and a LoadBalancer Service.
