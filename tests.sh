#!/bin/bash

# Isolated tests, add as neccessaryp

echo "Positive number test"
echo "Testing addition, expected result = 2"
echo $(ruby ./calc.rb -o "2+2")
echo "Testing subtraction, expected result = 2"
echo $(ruby ./calc.rb -o "4-2")
echo "Testing multiplication, expected result = 10"
echo $(ruby ./calc.rb -o "2*5")
echo "Testing division, expected result = 4"
echo $(ruby ./calc.rb -o "8/2")
echo "Testing modulas, expected result = 0"
echo $(ruby ./calc.rb -o "4%2")
echo "Testing square, expected result = 4"
echo $(ruby ./calc.rb -o "2^")
echo "Testing square root, expected result = 3"
echo $(ruby ./calc.rb -o "sqrt(9)")

echo "Testing PEDMAS (* priority right to left), expected result = 22"
echo $(ruby ./calc.rb -o "2+5*4")
echo "Testing PEDMAS (* priority left to right), expected result = 22"
echo $(ruby ./calc.rb -o "5*4+2")
echo "Testing PEDMAS (/ priority right to left), expected result = 13"
echo $(ruby ./calc.rb -o "10+6/2")
echo "Testing PEDMAS (/ priority left to right), expected result = 13"
echo $(ruby ./calc.rb -o "6/2+10")
echo "Testing PEDMAS (^ priority left to right), expected result = 8"
echo $(ruby ./calc.rb -o "2 + 2 + 2^)")
echo "Testing PEDMAS (^ priority right to left), expected result = 8"
echo $(ruby ./calc.rb -o "2 + 2 + 2^")
echo "Testing PEDMAS (sqrt priority left to right), expected result = 8"
echo $(ruby ./calc.rb -o "2 + 3 + sqrt(9)")
echo "Testing PEDMAS (sqrt priority right to left), expected result = 8"
echo $(ruby ./calc.rb -o "2 + 3 + sqrt(9)")

echo "Testing PEDMAS (bracket), expected result = 20"
echo $(ruby ./calc.rb -o "3*5+(2+3)")
echo "Testing PEDMAS (bracket nested), expected result = 25"
echo $(ruby ./calc.rb -o "3*5+(2*2+(3+3))")
