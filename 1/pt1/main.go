package main

import (
	"fmt"
	"unicode"
	"strings"
	"os"
	"log"
)

func get_numbers(input string) []int {
	var numbers []int

	// If the character is a number, append it to the array
	for _, sol := range input {
		if unicode.IsNumber(sol) {
			numbers = append(numbers, int(sol) - 48)
		}
	}

	return numbers
}

func main() {
	input, err := os.ReadFile("../input.txt")
	if err != nil {
		log.Fatal(err)
	}

	lines := strings.Split(string(input), "\n")
	res := 0

	// Get the result
	for _, l := range lines {
		numbers := get_numbers(l)
		res = res + numbers[0] * 10 + numbers[len(numbers)-1]
	}

	fmt.Println(res)
}
