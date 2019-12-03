# eShop on AWS - Docker App Template demo

In this demo you'll learn how to deploy applications to EKS on AWS using Docker Application Templates and GitHub Actions.

This is what you'll be doing:

- create a GitHub repository to store your demo code and the credentials to deploy to AWS

- run a Docker Application Template which generates code and a CI/CD pipelie for the .NET Core demo app [eShopOnWeb](https://github.com/dotnet-architecture/eShopOnWeb)

- push your local code to GitHub which runs a workflow to create an AWS SQL Server database and an AWS Kubernetes cluster

- run the app locally in Docker containers to see how it works, and make some simple changes

- push the changed code to GitHub which runs a workflow to build Docker images, push them to Docker Hub, and deploy the app onto your EKS cluster.

It sounds like a lot, but it's really simple because the template generates documentation for you which guides you through all the steps.

## Pre-requisites

You'll need a few things before you start:

1. A version of [Docker Desktop](https://www.docker.com/products/docker-desktop) with [Application Templates](https://blog.docker.com/2019/07/application-templates-docker-desktop-enterprise/) enabled.

> The demo is a Linux app, so on Windows you need to use Linux container mode. That's the default so you only need to change it if you've switched to Windows container mode.

2. A [Docker Hub account](https://hub.docker.com/signup), so the pipeline can push the Docker images it builds, and the Kubernetes cluster can pull them.

3. Some tools to work with the source code - [Git](https://gitforwindows.org) and [Visual Studio Code](https://code.visualstudio.com). If you have [Chocolatey](https://chocolatey.org) set up you can install them with:

```
choco install -y git
choco install -y visualstudiocode
```

4. AWS access key

> Make a note of the output, you'll need to add the details to GitHub

5. A GitHub repo. The pipeline runs using [GitHub Actions](https://help.github.com/en/articles/about-github-actions). Create an empty repo and set the following secrets (under _Settings...Secrets_):

- `AWS_ACCESS_KEY_ID` - the access key ID for AWS
- `AWS_SECRET_ACCESS_KEY` - the secret key for AWS
- `RDS_SQL_DATABASE_NAME` - the name of the SQL Server database to create
- `RDS_SQL_PASSWORD` - the password for the `master` SQL Server user
- `DOCKER_HUB_USERNAME` - Docker Hub username
- `DOCKER_HUB_ACCESS_TOKEN` - Docker Hub [Personal Access Token](https://www.docker.com/blog/docker-hub-new-personal-access-tokens/)

## Setup

Update your App Template config in `~/.docker/application-template/preferences.yaml` to include the template library at `https://raw.githubusercontent.com/sixeyed/eshoponaws/master/eshoponaws.yaml`.

This example includes the local demo libraries and the main Docker library:

```
apiVersion: v1alpha1
disableFeedback: false
kind: Preferences
repositories:
- name: eshoponaws
  url: https://raw.githubusercontent.com/sixeyed/eshoponaws/master/eshoponaws.yaml
- name: library
  url: https://docker-application-template.s3.amazonaws.com/production/v0.1.7/library.yaml
```

## Run the template

Right-click the Docker whale icon in your taskbar and select _Design new application..._ A window launches asking if you want to choose an existing template or design a custom app; select _Choose a template_.

> If you're running Docker Desktop on Windows you'll be asked if you want to run a Linux or Windows app - the template we'll be using is Linux so select _Linux_.

Now select the _eShop on Web_ template from the gallery:

![The Docker app template gallery](docs/img/choose-template.png)

From here you'll need to add some details about the deployment, which the template captures as parameters:

![Adding deployment parameters to the template](docs/img/template-parameters.png)

- _GitHub Username_ and _Repository name_ - use the repo you created earlier with all the secrets stored for AWS and Docker Hub

- _AWS region_ - region to deploy the EKS cluster & RDS database

- _EKS Cluster name_ - any name for the cluster to create

The other parameters have default values, and you can leave them as they are or change them to suit your deployment.

> The SQL Server password is only used when you run the app locally, the AWS deployment uses the password you stored in the GitHub secret

Now click _Continue_, give your application a name and click _Scaffold_. Docker Desktop runs the template and generates the source code and GitHub workflows on you local machine.

When the scaffolding process finishes click _Run application_. That builds and runs the app in local containers. While it's building click _Open in Visual Studio Code_ to launch a VS Code instance with the generated application code:

![Running the application locally with Docker Desktop](docs/img/run-application.png)

## Head over to the new docs

Now you can follow the generated documentation from the source code. Browse to the README file in the `eshop-web` folder and contine from there.

Good luck :)
