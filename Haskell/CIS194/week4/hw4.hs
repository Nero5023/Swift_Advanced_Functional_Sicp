import Data.List

-- Exercise 1
fun1 :: [Integer] -> Integer 
fun1 [] = 1
fun1 (x:xs)
     | even x    = (x - 2) * fun1 xs
     | otherwise = fun1 xs

fun1' :: [Integer] -> Integer
fun1' = foldl (*) 1 . map (subtract 2) . filter even 


fun2 :: Integer -> Integer 
fun2 1 = 0
fun2 n | even n = n + fun2 (n `div` 2) 
       | otherwise = fun2 (3 * n + 1)

fun2' :: Integer -> Integer
fun2' = sum . filter even . takeWhile (>1) 
        . iterate (\x -> if even x then x `div` 2 else 3*x+1)

-- Exercise 2
data Tree a = Leaf
            | Node Integer (Tree a) a (Tree a)
    deriving (Show, Eq)

foldTree :: [a] -> Tree a
foldTree [] = Leaf
foldTree xs = Node height
             (foldTree $ take half xs)
             (xs !! half)
             (foldTree $ drop (half+1) xs)
            where
                len = length xs
                half = len `div` 2
                height = floor (logBase 2 (fromIntegral len)::Double)

-- Exercise 3
xor :: [Bool] -> Bool
xor = foldl (\acc x -> (acc || x) && not (acc && x)) False

map' :: (a -> b) -> [a] -> [b]
map' f = foldr (\x acc -> f x : acc) []

myFoldl :: (a -> b -> a) -> a -> [b] -> a
myFoldl f base xs = foldr (flip f) base $ reverse xs

-- Exercise 4

-- \\ is list difference


cardProd :: [a] -> [b] -> [(a,b)]
cardProd xs ys = [(x,y) | x <- xs, y<-ys]

sieveSundaram :: Integer -> [Integer]
sieveSundaram n = map (\x -> x*2+1) $ [1..n] \\ sieve
                where sieve = map (\(i,j) -> (i+j+2*j*i)) $ filter (\(i, j) -> i<=j && i+j+2*i*j<=n) $ cardProd [1..n] [1..n]