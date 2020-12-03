## Deploy locally

Install Docker & Docker Compose
```
docker build -t test .
docker run -p 0.0.0.0:80:80 test
```
Go to http://localhost
```
docker-compose up
```

## Deploy to Remote Host VM

```
terraform init
terraform plan
terrafor apply
```
