package greetings

import (
	"fmt"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestGetMessage(t *testing.T) {
	tests := []struct {
		testName        string
		name            string
		expectedMessage string
	}{
		{
			"Without name",
			"",
			"Hello world",
		},
		{
			"With name",
			"Manuel",
			"Hello Manuel",
		},
	}

	for _, tc := range tests {
		t.Run(fmt.Sprintf("Testing: %s", tc.testName), func(t *testing.T) {
			gt, err := GetMessage(tc.name)

			assert.Nil(t, err)
			assert.Equal(t, tc.expectedMessage, gt)
		})
	}
}
