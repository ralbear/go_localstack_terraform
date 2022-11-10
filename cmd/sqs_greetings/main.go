package main

import (
	"context"
	"fmt"
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

func helloSqs(ctx context.Context, e events.SQSEvent) (err error) {
	for _, r := range e.Records {
		fmt.Println("Received a message: ", r.MessageId)
		if err = processMessage(r.Body); err != nil {
			return err
		}
	}
	return nil
}

func main() {
	lambda.Start(helloSqs)
}

func processMessage(b string) (err error) {

	fmt.Println("Message body: ", b)

	return nil
}
