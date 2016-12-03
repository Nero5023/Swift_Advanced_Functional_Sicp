data IntList = Empty | Cons Int IntList
  deriving Show

intListProd :: IntList -> Int
intListProd Empty = 1
intListProd (Cons x list) = x * intListProd list

data Tree = Leaf Char
          | Node Tree Int Tree
  deriving Show
  