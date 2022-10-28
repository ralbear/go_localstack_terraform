package main

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"github.com/aws/aws-lambda-go/events"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"testing"
	"time"
)

var testingTime = time.Now()

func TestHelloWorld(t *testing.T) {

	tests := []struct {
		testName               string
		name                   string
		expectedMessage        string
		nameToGreetingsService string
		greetingsFromService   string
		expectedStatusCode     int
		expectedContentType    string
		expectedTime           string
		success                bool
	}{
		{
			"Without name",
			"",
			"Hello world",
			"",
			"Hello world",
			200,
			"application/json",
			testingTime.String(),
			true,
		},
		{
			"With name",
			"Manuel",
			"Hello Manuel",
			"Manuel",
			"Hello Manuel",
			200,
			"application/json",
			testingTime.String(),
			true,
		},
	}

	for _, tc := range tests {
		t.Run(fmt.Sprintf("Testing: %s", tc.testName), func(t *testing.T) {
			q := make(map[string]string)
			if tc.name != "" {
				q["name"] = "Manuel"
			}

			event := events.APIGatewayProxyRequest{
				QueryStringParameters: q,
			}

			currentTime = func() time.Time {
				return testingTime
			}

			getGreetings = func(name string) string {
				assert.Equal(t, tc.nameToGreetingsService, name)
				return tc.greetingsFromService
			}

			result, err := helloWorld(context.Background(), event)

			require.NoError(t, err)
			var responseBody struct {
				Success bool   `json:"success"`
				Message string `json:"message"`
				Time    string `json:"time"`
			}
			json.Unmarshal([]byte(result.Body), &responseBody)
			assert.Equal(t, tc.expectedStatusCode, result.StatusCode)
			assert.Equal(t, tc.expectedContentType, result.Headers["Content-Type"])
			assert.Equal(t, tc.success, responseBody.Success)
			assert.Equal(t, tc.expectedMessage, responseBody.Message)
			assert.Equal(t, tc.expectedTime, responseBody.Time)
		})
	}
}

func TestServerError(t *testing.T) {
	newError := errors.New("some error message")

	logError = func(errMsg string) {
		assert.Equal(t, newError.Error(), errMsg)
	}

	se, _ := serverError(newError)

	assert.Equal(t, 500, se.StatusCode)
	assert.Equal(t, "Internal Server Error", se.Body)
}
