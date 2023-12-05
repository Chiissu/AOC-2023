package main

import (
	"fmt"
	"unicode"
	"strings"
	"os"
	"log"
)

func main() {
	input, err := os.ReadFile("../input.txt")
	if err != nil {
		log.Fatal(err)
	}

	lines := strings.Split(string(input), "\n")
	res := 0

	// Get the result
	for _, l := range lines {
		numbers := GetNumbers(l)
		res = res + numbers[0] * 10 + numbers[len(numbers)-1]
	}

	fmt.Println(res)
}

func GetNumbers(input string) []int {
	var numbers []int
	for _, sol := range input {
		if unicode.IsNumber(sol) {
			numbers = append(numbers, int(sol) - 48)
		}
	}
	return numbers
}
