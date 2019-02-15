# ruby_calc
# A simple ruby CLI calculator

This is a simple string parser calculator that runs in the command line.

You can run it by calling `ruby calc.rb -o "Your operation here`". 
You can also use the `-h` switch to print some help, but this needs fleshed out

## Formatting

The calculator at the moment uses ~~pretty strict formatting due to me shit with regex~~ reasonably strict formatting, the formatting rules are as follows:

* Your formula must be surrounded by double quotations

   Valid `"5 + 5"`
   
   Invalid `5 + 5`
  
* ~~Every number, brace and operator must be separated with white space~~

   ~~Valid `"5 + 5"~~
   
   ~~Invalid `"5+5"`~~
   
   Any whitespace format is now accepted!
   
* ~~All braces must be closed~~ They don't _have to_ enclose them but expect weird results
* If you do not put an operator, there is no assumption that you mean multiply!

   This will not work `"5 ( 3 + 3 )"`
   
   This will `"5 * ( 3 + 3 + 3 )"`
* Working with negative numbers, spacing is important for the parser! The negative qualifier must be directly to the left of   the number
   
   This will not work, 1 will not be interpreted as a negative number `5 - - 1`
   
   This will `5- -1` or `5--1` or `5 --1`
   
* Scientific functions must be enclosed in brackets
   
   This will not work `cos5` or `cos 5`
   
   this will `cos(5)`
   

## Support operations

So far the calculator can handle 
* Nested braces
* Square 
* Multiplication 
* Division
* Modulas
* Addition 
* Subtraction
* **NEW** Squareroot ~~(single bracket operation at the moment)~~
* **NEW** Sine
* **NEW** Cosine
* **NEW** Tangent
* **NEW** Arc Sine
* **NEW** Arc Cosine
* **NEW** Arc Tangent

*Please see the scientific section below for formatting.


A more complicated example is something like so:
   `"1.5 * ( 5 + 8.25 ^ - ( 0.5 + 0.25 ) ) / 2"`
   
   
## Shorthands

At the moment the calculator supports very little shorthands, but you can pass in human readable constants to neaten up your
formula    

   Constant PI - `2 * pi`
   
   
## Scientific Format

In order to use the scientific functions, they must be formatted in a particular way. Most of the functions are, however, very similar.

`calc.rb -o "scientific_function(value)"`

Apples to - sin, cos, tan, asin, acos, atan, atan2

`calc.rb -o "scientific_function(value, exponent)`

Applies to - pow

   
## Options

The calculator supports various options, you can type `calc.rb -h` for a list, or read on

`-o` Takes a formula and calculates the result

`-v` Prints an extensive log of the calculators step by step process

`-l` Sets a delay for the verbose output, this allows you to slow down the program during debugging. Does not work if verbose is not enabled

`-h` Displays a help screen listing all the options available
