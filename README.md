# GO - Localstack - Terraform

## Setup

```shell
$ make setup
```

## Build & deploy

```shell
$ make build-and-deploy
```

Functions should be inside a new folder on `cmd/`, when we build the app, all them will be build independently

## Interact with localstack

### Local AWS credentials
Content of `/home/<user>/.aws/credentials`
```shell
[localstack]
aws_access_key_id = test
aws_secret_access_key = test
region = us-east-1
```

### Push a new SQS event

```shell
$ aws sqs send-message --queue-url http://localhost:4566/000000000000/sqs_greetings\
    --message-body "Information about the largest city in Any Region."\
    --profile localstack --endpoint-url=http://localhost:4566
```

### Access cloudwatch logs

```shell
$ aws logs describe-log-groups --profile localstack --endpoint-url=http://localhost:4566
{
    "logGroups": [
        {
            "logGroupName": "/aws/lambda/func1",
            ...
        }
    ]
}
$ aws logs describe-log-streams --log-group-name /aws/lambda/func1 \
  --profile localstack --endpoint-url=http://localhost:4566
{
    "logStreams": [
        {
            "logStreamName": "2020/08/03/[LATEST]95350151",
            ...
        }
    ]
}
$ aws logs get-log-events --log-group-name /aws/lambda/func1 \
  --log-stream-name "2020/08/03/[LATEST]95350151" \
  --profile localstack --endpoint-url=http://localhost:4566
{
    "events": [
        {
            "timestamp": 1596456607456,
            "message": "INFO: Debug output from Lambda function ...",
            "ingestionTime": 1596456607548
        }
    ]
}
```
[Source](https://github.com/localstack/localstack/issues/2061#issuecomment-667992579)

### List lambda functions

```shell
aws lambda list-functions --profile localstack \
  --endpoint-url=http://localhost:4566
```

### List sqs functions

```shell
aws sqs list-queues --profile localstack \
  --endpoint-url=http://localhost:4566
```

### List Api Gateway endpoints

```shell
aws apigateway get-rest-apis \
  --profile localstack --endpoint-url=http://localhost:4566
```
