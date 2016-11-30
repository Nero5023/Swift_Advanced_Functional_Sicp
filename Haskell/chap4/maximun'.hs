maximun' :: (Ord a) => [a] -> a
maximun' [] = error "maximun of empty list"
maximun' [x] = x
maximun' (x:xs) = max x (maximun' xs)