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
