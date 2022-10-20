package greetings

import "fmt"

const defaultMessage = "Hello world"
const customMessage = "Hello %s"

func GetMessage(s string) (string, error) {
	if s == "" {
		return defaultMessage, nil
	}

	return fmt.Sprintf(customMessage, s), nil
}
