# Locals
- terraform locals only accessible within the function or within the scope on terraform file 
- Normally in Programming world  we have a concept like locals that same concept also works here same 

# Normal Syntax of Locals

    locals {
        my_local = "value"
    }

# Two types of Locals

- static values 
- Dynamic value

# Dynamic value Syntax

    locals {
        my_local = "${var.my_variable_value}"
    }

# To pass locals in main terraform file 

    