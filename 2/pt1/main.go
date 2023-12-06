package main

import (
	"os"
	"log"
)

func main() {
	input, err := os.ReadFile("../input.txt")
	if err != nil {
		log.Fatal(err)
	}

	for _, line := range input {
		
	}
}
