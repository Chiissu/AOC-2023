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

	var lines []string = strings.Split(string(input), "\n")
	var res uint16 = 0

	// Get the result
	for _, line := range lines {
		var firstNum uint8 = 10
		var lastNum uint8 = 0

		for i, char := range line {
			var num uint8 = 0
			if unicode.IsNumber(char) {
				num = uint8(char) - 48
				firstNum, lastNum = SetNumbers(firstNum, lastNum, num)
			}
			if unicode.IsLetter(char) {
				number, hasErr := CheckForNum(line, i)
				if hasErr { continue }
				num = uint8(number)
				firstNum, lastNum = SetNumbers(firstNum, lastNum, num)
			}
		}

		res = uint16(firstNum * 10 + lastNum) + res
	}

	fmt.Println(res)
}

func SetNumbers(firstNum uint8, lastNum uint8, num uint8) (uint8, uint8) {
	if firstNum == 10 { firstNum = num }
	lastNum = num
	return firstNum, lastNum
}

func CheckForNum(line string, position int) (int, bool) {
	var numNames [10] string = [10]string{"zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"}
	if len(line) > position + 4 {
		var slice string = line[position:position + 5]
		if slice == numNames[3] { return 3, false }
		if slice == numNames[7] { return 7, false }
		if slice == numNames[8] { return 8, false }
	}
	if len(line) > position + 3 {
		var slice string = line[position:position + 4]
		if slice == numNames[0] { return 0, false }
		if slice == numNames[4] { return 4, false }
		if slice == numNames[5] { return 5, false }
		if slice == numNames[9] { return 9, false }
	}
	if len(line) > position + 2 {
		var slice string = line[position:position + 3]
		if slice == numNames[1] { return 1, false }
		if slice == numNames[2] { return 2, false }
		if slice == numNames[6] { return 6, false }
	}
	return 0, true
}
