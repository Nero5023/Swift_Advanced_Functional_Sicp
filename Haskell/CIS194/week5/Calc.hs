{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances #-}

module Calc where

import ExprT
import Parser
import StackVM
import Data.Maybe

import qualified Data.Map as M

-- Exercise 1
eval :: ExprT -> Integer
eval (ExprT.Lit int) = int
eval (ExprT.Add lhs rhs) = (eval lhs) + (eval rhs)
eval (ExprT.Mul lhs rhs) = (eval lhs) * (eval rhs)


-- Exercise 2
evalStr :: String -> Maybe Integer
evalStr exp = case parseExp ExprT.Lit ExprT.Add ExprT.Mul exp of
                        (Just exprt) -> Just $ eval exprt
                        Nothing -> Nothing

-- Exercise 3
class Expr a where
    lit :: Integer -> a
    add :: a -> a -> a
    mul :: a -> a -> a

instance Expr ExprT where
    lit x = (Lit x)
    add lhs rhs = (ExprT.Add lhs rhs)
    mul lhs rhs = (ExprT.Mul lhs rhs)


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

testExp :: Expr a => Maybe a
testExp = parseExp lit add mul "(3 * -4) + 5"

-- Exercise 5
instance Expr Program where
    lit x = [PushI x]
    add lhs rhs = lhs ++ rhs ++ [StackVM.Add]
    mul lhs rhs = lhs ++ rhs ++ [StackVM.Mul]

compile :: String -> Maybe Program
compile str = parseExp lit add mul str :: Maybe Program

-- Exercise 6

class HasVars a where
    var :: String -> a


data VarExprT = VarExprT String Integer
    deriving (Show, Eq)

instance Expr VarExprT where
    lit x = VarExprT "" x
    add (VarExprT _ a) (VarExprT _ b) = VarExprT "" (a + b)
    mul (VarExprT _ a) (VarExprT _ b) = VarExprT "" (a * b) 

-- data VarExprT = Lit Integer
--                 | Var String
--                 | Add VarExprT VarExprT
--                 | Mul VarExprT VarExprT

type MapExpr = M.Map String Integer -> Maybe Integer

instance HasVars MapExpr where
    var =  M.lookup

instance Expr MapExpr where
    lit a _ =  Just a
    add lhs rhs map = case (isNothing (lhs map) || isNothing (rhs map)) of 
                                True -> Nothing
                                _ -> Just (fromJust (lhs map) + fromJust (rhs map))

    mul lhs rhs map = case (isNothing (lhs map) || isNothing (rhs map)) of 
                                True -> Nothing
                                _ -> Just (fromJust (lhs map) * fromJust (rhs map))

withVars :: [(String, Integer)] -> MapExpr -> Maybe Integer
withVars list expr = expr $ M.fromList list
