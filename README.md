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
   
* All braces must be closed
* If you do not put an operator, there is no assumption that you mean multiply!

   This will not work `"5 ( 3 + 3 )"`
   
   This will `"5 * ( 3 + 3 + 3 )"`
   

## Support operations

So far the calculator can handle 
* Nested braces
* Square 
* Multiplication 
* Division
* Modulas
* Addition 
* Subtraction


A more complicated example is something like so:
   `"1.5 * ( 5 + 8.25 ^ - ( 0.5 + 0.25 ) ) / 2"`
   
## Shorthands

At the moment the calculator supports very little shorthands, but you can pass in human readable constants to neaten up your
formula    

   Example is PI, `"5 * pi`"
   
## Options

The calculator supports various options, you can type `calc.rb -h` for a list, or read on

`-o` Takes a formula and calculates the result

`-v` Prints an extensive log of the calculators step by step process

`-l` Sets a delay for the verbose output, this allows you to slow down the program during debugging. Does not work if verbose is not enabled

`-h` Displays a help screen listing all the options available

