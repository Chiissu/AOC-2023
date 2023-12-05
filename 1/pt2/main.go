package main

import (
	"fmt"
	"unicode"
	"strings"
	"os"
	"log"
)

func main() {
	input, err := os.ReadFile("./input.txt")
	if err != nil {
		log.Fatal(err)
	}

	lines := strings.Split(string(input), "\n")
	res := 0

	// Iterate through every line
	for _, line := range lines {
		numbers := GetNumbers(line)
		res = res + numbers[0] * 10 + numbers[len(numbers)-1]
	}

	fmt.Println(res)
}

func CheckForNum(line string, position int) (int, bool) {
	numNames := [10]string{"zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"}
	if len(line) > position + 4 {
		slice := line[position:position + 5]
		if slice == numNames[3] { return 3, false }
		if slice == numNames[7] { return 7, false }
		if slice == numNames[8] { return 8, false }
	}
	if len(line) > position + 3 {
		slice := line[position:position + 4]
		if slice == numNames[0] { return 0, false }
		if slice == numNames[4] { return 4, false }
		if slice == numNames[5] { return 5, false }
		if slice == numNames[9] { return 9, false }
	}
	if len(line) > position + 2 {
		slice := line[position:position + 3]
		if slice == numNames[1] { return 1, false }
		if slice == numNames[2] { return 2, false }
		if slice == numNames[6] { return 6, false }
	}
	return 0, true
}

func GetNumbers(input string) []int {
	var numbers []int
	for i, sol := range input {
		if unicode.IsNumber(sol) {
			numbers = append(numbers, int(sol) - 48)
		} 
		if unicode.IsLetter(sol) {
			num, hasErr := CheckForNum(input, i)
			if !hasErr {
				numbers = append(numbers, num)
			}
		}
 	}
	return numbers
}
