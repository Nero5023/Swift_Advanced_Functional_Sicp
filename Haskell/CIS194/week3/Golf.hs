module Golf where

-- Exercise 1
--  return contain every nth element from the input list
skip :: Int -> [a] -> [a]
skip n = map snd . filter (\(x, _) -> x==n) . zip (cycle [1..n])

skips :: [a] -> [[a]]
skips xs = map (\x -> skip x xs) [1..(length xs)]


tails :: [a] -> [[a]]
tails [] = []
tails (x:[]) = [[x]]
tails xs = xs : (tails $ tail xs)

isLocalMax :: (Ord a) => [a] -> Bool
isLocalMax (x:y:z:xs) = y>x && y>z
isLocalMax _ = False

localMaxima :: [Int] -> [Int]
localMaxima xs = map (!!1) $ filter isLocalMax $ tails xs


-- Frequebct [1,2,3,4,5,6,7,8,9] result [0,1,1,1,1,1,1,1,1,1]
frequency :: [Int] -> [Int]
frequency xs = map (\n -> length $ filter (==n) xs) [0..9]

-- frequencyToStr [0,1,1,1,1,1,1,1,1,1] 1 result " *********"
frequencyToStr :: [Int] -> Int -> String
frequencyToStr [] _ = ""
frequencyToStr (x:xs) apperTimes = str ++ (frequencyToStr xs apperTimes)
                                    where str = (if (apperTimes <= x) then "*" else "-")

histogram :: [Int] -> String
histogram xs = let frequencyCount = frequency xs
                   m = maximum frequencyCount in
                   (unlines $ map (frequencyToStr frequencyCount) $ reverse [1..m]) ++ "==========\n0123456789\n"