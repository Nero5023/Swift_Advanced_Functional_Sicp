quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort (x:xs) =
    let smallerOrEqual = [a | a <- xs, a <= x ]
        larger = [a | a <- xs, a > x]
    in (quicksort smallerOrEqual) ++ [x] ++ (quicksort larger)

quicksort2 :: (Ord a) => [a] -> [a]
quicksort2 [] = []
quicksort2 (x:xs) = (quicksort smallerOrEqual) ++ [x] ++ (quicksort larger)
    where smallerOrEqual = [a | a <- xs, a <= x ]
          larger = [a | a <- xs, a > x]
