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

-- Exercise 4
streamRepeat :: a -> Stream a
streamRepeat x = Cons x $ streamRepeat x

streamMap :: (a -> b) -> Stream a -> Stream b
streamMap f (Cons x xs) = Cons (f x)  (streamMap f xs)

streamFromSeed :: (a->a) -> a -> Stream a
streamFromSeed f x = Cons x $ streamFromSeed f $ f x

-- Exercise 5
nats :: Stream Integer
nats = streamFromSeed (+1) 0

-- Exercise 6
interleaveStreams :: Stream a -> Stream a -> Stream a
interleaveStreams (Cons x xs) ys = Cons x $ interleaveStreams ys xs

-- interleaveStreams nats nats 但用 startRuler x = interleaveStreams (streamRepeat x) (startRuler (x+1)) 这句话就是错的，会 stack overflow
-- 因为会不停的去解开 后面 startRuler (x+1), 不停地解下去，就栈溢出了
-- interleaveStreams (Cons x xs) (Cons y ys) = 
--         Cons x $ Cons y $ interleaveStreams xs ys

ruler :: Stream Integer
ruler = interleaveStreams (streamRepeat 0) (Cons 1 ruler)

startRuler :: Integer -> Stream Integer
startRuler x = interleaveStreams (streamRepeat x) (startRuler (x+1))

-- Exercise 7