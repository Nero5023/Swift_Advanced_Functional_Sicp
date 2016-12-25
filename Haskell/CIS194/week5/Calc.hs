module Calc where

import ExprT

eval :: ExprT -> Integer
eval (Lit int) = int
eval (Add lhs rhs) = (eval lhs) + (eval rhs)
eval (Mul lhs rhs) = (eval lhs) * (eval rhs)