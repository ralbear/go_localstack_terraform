package main

import (
	"context"
	"encoding/json"
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/ralbear/go_aws_hello_world/internal/greetings"
	"log"
	"net/http"
	"os"
	"time"
)

var currentTime = func() time.Time {
	return time.Now()
}

var logError = func(errMsg string) {
	log.New(os.Stderr, "ERROR ", log.Llongfile).Println(errMsg)
}

var getGreetings = func(name string) string {
	return greetings.GetMessage(name)
}

type ResponseBody struct {
	Success bool   `json:"success"`
	Message string `json:"message"`
	Time    string `json:"time"`
}

func helloWorld(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	message := getGreetings(req.QueryStringParameters["name"])

	response := &ResponseBody{
		Success: true,
		Message: message,
		Time:    currentTime().String(),
	}

	responseJson, err := json.Marshal(response)

	if err != nil {
		return serverError(err)
	}

	return events.APIGatewayProxyResponse{
		StatusCode: http.StatusOK,
		Body:       string(responseJson),
		Headers: map[string]string{
			"Content-Type": "application/json",
		},
	}, nil
}

func main() {
	lambda.Start(helloWorld)
}

func serverError(err error) (events.APIGatewayProxyResponse, error) {
	logError(err.Error())

	return events.APIGatewayProxyResponse{
		StatusCode: http.StatusInternalServerError,
		Body:       http.StatusText(http.StatusInternalServerError),
	}, nil
}
