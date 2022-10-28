package greetings

import "fmt"

const defaultMessage = "Hello world"
const customMessage = "Hello %s"

func GetMessage(s string) string {
	if s == "" {
		return defaultMessage
	}

	return fmt.Sprintf(customMessage, s)
}
