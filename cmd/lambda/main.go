package main

import (
	"context"
	"encoding/json"
	"fmt"
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"log"
	"net/http"
	"os"
	"time"
)

var errorLogger = log.New(os.Stderr, "ERROR ", log.Llongfile)

type ResponseBody struct {
	Success bool   `json:"success"`
	Message string `json:"message"`
	Time    string `json:"time"`
}

func helloWorld(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	now := time.Now()

	name := req.QueryStringParameters["name"]

	message := "Hello world"

	if name != "" {
		message = fmt.Sprintf("Hello %s", name)
	}

	response := &ResponseBody{Success: true, Message: message, Time: now.String()}
	responseJson, err := json.Marshal(response)

	if err != nil {
		return serverError(err)
	}

	return events.APIGatewayProxyResponse{
		StatusCode: http.StatusOK,
		Body:       string(responseJson),
	}, nil
}

func main() {
	lambda.Start(helloWorld)
}

func serverError(err error) (events.APIGatewayProxyResponse, error) {
	errorLogger.Println(err.Error())

	return events.APIGatewayProxyResponse{
		StatusCode: http.StatusInternalServerError,
		Body:       http.StatusText(http.StatusInternalServerError),
	}, nil
}
