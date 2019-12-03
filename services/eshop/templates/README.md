# eShopOnWeb - running locally with Docker and in AWS with EKS

Welcome to eShop on Web!

This source code was scaffolded by a [Docker Application Template](https://github.com/sixeyed/eshoponweb-template) which also generated:

- a [Dockerfile](./src/Web/Dockerfile) to build, test and package the web app;
- a [Docker Compose](../docker-compose.yaml) file to run the app locally in containers;
- a [Docker Compose](../docker-compose.production.yaml) file to run the app in EKS.

> The output includes GitHub actions for creating a managed Kubernetes cluster and a SQL Server database in AWS, and for deploying the app to the cluster.

## Push this repo to create your EKS cluster & RDS database

You should have a [GitHub repo set up]({{range .Services}}{{if eq "github" .ID}}https://github.com/{{.Parameters.username}}/{{.Parameters.repoName}}.git{{end}}{{end}}) with all the secrets stored for the pipeline to create AWS resources.

Open a terminal for this folder and set up the GitHub remote:

```
git init
git add --all
git commit -m 'A template built all this!'
git remote add origin {{range .Services}}{{if eq "github" .ID}}https://github.com/{{.Parameters.username}}/{{.Parameters.repoName}}.git{{end}}{{end}}
```

Push the code to GitHub. This will start workflows to create your AWS resources:

```
git push -u origin master
```

[You can check on the workflows here]({{range .Services}}{{if eq "github" .ID}}https://github.com/{{.Parameters.username}}/{{.Parameters.repoName}}/actions{{end}}{{end}}). It make take a minute or so before the actions start. The workflows use secrets from your repo to connect to AWS. Then they:

- create an EKS cluster
- deploy [Helm](https://helm.sh) on the cluster
- deploy [Compose on Kubernetes](https://github.com/docker/compose-on-kubernetes) on the cluster
- create a SQL Server instance with two databases

Setting up the EKS cluster can take 10 minutes or more, but it's a one-off job that only happens when you first push your code.

## Meanwhile... run the app locally

Docker Application Designer uses the [docker-compose.yaml](../docker-compose.yaml) manifest to build and run the app locally.

Click _Start_ in Application Designer in the app isn't already running. Then browse to:

- http://localhost:{{.Parameters.externalPort}}

And you can also connect to your local SQL Server container using a SQL client - [Sqlectron](https://sqlectron.github.io) is a good choice:

- server address: `localhost:{{range .Services}}{{if eq "sql-server" .ID}}{{.Parameters.externalPort}}{{end}}{{end}}`
- username: `sa`
- password: `{{range .Services}}{{if eq "sql-server" .ID}}{{.Parameters.saPassword}}{{end}}{{end}}`

## Check the Code

The app is an ASP .NET Core MVC web app, with some core best practices for running in Docker and Kubernetes:

- the [Dockerfile](./src/Web/Dockerfile) is a multi-stage build which compiles, tests and packages the app
- [configuration files](./src/Web/Program.cs) are loaded from multiple locations, so they can be provided by the platform
- there are [healthchecks](./src/Web/HealthChecks/ApiHealthCheck.cs) in the code which tell the container platform if the app is healthy

You can edit the source code and click _Restart_ from Docker Application Designer to see your changes - try a simple UI change in [\_Layout.cshtml](./src/Web/Views/Shared/_Layout.cshtml).

## Deploy to Kubernetes

Your EKS cluster has been provisioned with [Compose on Kubernetes](https://github.com/docker/compose-on-kubernetes), so you can use **the exact same** Docker Compose format to deploy to EKS.

And your GitHub repo has another Action which deploys your app using the generated [docker-compose.production.yaml](../docker-compose.production.yaml) file when you push changes.

Now that you've edited the UI, push your changes to deploy the app to EKS:

```
git add --all
git commit -m 'I edited this myself'
git push origin master
```

[Check on the GitHub actions]({{range .Services}}{{if eq "github" .ID}}https://github.com/{{.Parameters.username}}/{{.Parameters.repoName}}/actions{{end}}{{end}}) to see when the _Deploy to EKS_ workflow has completed.

> The final output of the job shows you the external address of the app, but GitHub obfuscates part of it...

## Browse to the app on EKS

Your app is running now in AWS and you can browse to it from the load balancer, which the deployment created to make the app externally available.

Browse to [EC2 load balancers](https://eu-west-2.console.aws.amazon.com/ec2/v2/home?region=eu-west-2#LoadBalancers:sort=loadBalancerName) and you should see your new ELB. The domain name is the public URL of the eShop on AWS.

You can also browse to the other resources the pipeline created for you:

- [EKS cluster](https://{{range .Services}}{{if eq "aws" .ID}}{{.Parameters.region}}{{end}}{{end}} .console.aws.amazon.com/eks/home?region={{range .Services}}{{if eq "aws" .ID}}{{.Parameters.region}}{{end}}{{end}} #/clusters/{{range .Services}}{{if eq "eks" .ID}}{{.Parameters.clusterName}}{{end}}{{end}}) to check it

- [RDS database](https://{{range .Services}}{{if eq "aws" .ID}}{{.Parameters.region}}{{end}}{{end}}.console.aws.amazon.com/rds/home?region={{range .Services}}{{if eq "aws" .ID}}{{.Parameters.region}}{{end}}{{end}})

> You can continue to work on the code locally, push to GitHub and your changes will be deployed to EKS

### Credits

Original source code: [dotnet-architecture/eShopOnWeb](https://github.com/dotnet-architecture/eShopOnWeb).
