-- exersice1
toDigitsRev :: Integer -> [Integer]
toDigitsRev 0 = []
toDigitsRev n 
    | n < 0     = []
    | otherwise = (n `mod` 10) : (toDigitsRev $ n `div` 10)

toDigits :: Integer -> [Integer]
toDigits n = reverse $ toDigitsRev n

-- exersice2
doubleEveryOther :: [Integer] -> [Integer]
doubleEveryOther = reverse . zipWith (*) (cycle [1,2]) . reverse

-- exersice3
-- sumDigits :: [Integer] -> Integer
-- sumDigits = sum . map sum . map toDigits 

-- them same as below
sumDigits :: [Integer] -> Integer
sumDigits = sum . map (sum . toDigits)

-- exersice4
validate :: Integer -> Bool
validate x = (sumDigits . doubleEveryOther . toDigits) x `mod` 10 == 0

type Peg = String
type Move = (Peg, Peg)
hanoi :: Integer -> Peg -> Peg -> Peg -> [Move]
hanoi 0 _ _ _  = []
hanoi n a b c = hanoi (n-1) a c b  ++
                [(a,b)] ++
                hanoi (n-1) c b a
