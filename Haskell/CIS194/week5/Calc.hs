module Calc where

import ExprT
import Parser

-- Exercise 1
eval :: ExprT -> Integer
eval (Lit int) = int
eval (Add lhs rhs) = (eval lhs) + (eval rhs)
eval (Mul lhs rhs) = (eval lhs) * (eval rhs)


-- Exercise 2
evalStr :: String -> Maybe Integer
evalStr exp = case parseExp Lit Add Mul exp of
                        (Just exprt) -> Just $ eval exprt
                        Nothing -> Nothing

