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
		var firstNumFound bool = false
		var firstNum uint8 = 0
		var lastNum uint8 = 0

		for _, char := range line {
			if unicode.IsNumber(char) {
				var num uint8 = uint8(char) - 48
				lastNum = num

				if !firstNumFound {
					firstNumFound = true
					firstNum = num
				}
			}
		}

		res = uint16(firstNum * 10 + lastNum) + res
	}

	fmt.Println(res)
}
