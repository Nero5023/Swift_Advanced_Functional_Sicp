sumEveryTwo:: [Integer] -> [Integer]
sumEveryTwo []      = []
sumEveryTwo (x:[])  = [x]
sumEveryTwo (x:(y:zs)) = (x+y) : sumEveryTwo zs
