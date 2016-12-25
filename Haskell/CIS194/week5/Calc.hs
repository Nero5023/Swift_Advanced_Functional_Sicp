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

-- Exercise 4


instance Expr Integer where
    lit x = x
    add = (+)
    mul = (*)

instance Expr Bool where
    lit = (>0)
    add = (||)
    mul = (&&)

data MinMax = MinMax Integer 
    deriving (Eq, Show)

instance Expr MinMax where
    lit = MinMax 
    add (MinMax lhs) (MinMax rhs) = MinMax $ max lhs rhs
    mul (MinMax lhs) (MinMax rhs) = MinMax $ min lhs rhs

data Mod7 = Mod7 Integer
    deriving (Eq, Show)

instance Expr Mod7 where
    lit = Mod7
    add (Mod7 lhs) (Mod7 rhs) = Mod7 $ (`mod` 7) $ lhs + rhs
    mul (Mod7 lhs) (Mod7 rhs) = Mod7 $ (`mod` 7) $ lhs * rhs


