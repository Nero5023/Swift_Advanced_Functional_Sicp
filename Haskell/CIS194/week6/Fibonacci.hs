-- Exercise 1
fib :: Integer -> Integer
fib 0 = 0
fib 1 = 1
fib n = fib (n-1) + fib (n-2)

fibs1 :: [Integer]
fibs1 = [x | i <- [0,1..], let x = fib i ]

-- Exercise 2
fibs2 :: [Integer]
fibs2 = [0,1] ++ [x | i<-[2..], let x = fibs2!!(i-1) + fibs2!!(i-2)]

fibs2' :: [Integer]
fibs2' = 0:1:zipWith (+) fibs2' (tail fibs2')

-- Exercise 3
data Stream a = Cons a (Stream a)

streamToList :: Stream a -> [a]
streamToList (Cons a stream) = a: streamToList stream

instance Show a => Show (Stream a) where
    show = show . take 20 . streamToList
    -- show stream = show $ take 20 $ streamToList stream

streamRepeat :: a -> Stream a
streamRepeat x = Cons x $ streamRepeat x

streamMap :: (a -> b) -> Stream a -> Stream b
streamMap f (Cons x xs) = Cons (f x)  (streamMap f xs)

streamFromSeed :: (a->a) -> a -> Stream a
streamFromSeed f x = Cons x $ streamFromSeed f $ f x