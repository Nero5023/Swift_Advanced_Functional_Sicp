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

-- Exercise 3
class Expr a where
    lit :: Integer -> a
    add :: a -> a -> a
    mul :: a -> a -> a

instance Expr ExprT where
    lit x = (Lit x)
    add lhs rhs = (Add lhs rhs)
    mul lhs rhs = (Mul lhs rhs)


reify :: ExprT -> ExprT
reify = id