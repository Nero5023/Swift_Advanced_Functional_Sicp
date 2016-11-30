bmiTell :: Double -> Double -> String
bmiTell weight height
    | bmi <= 18.5 = "You're underweight."
    | bmi <= 25.0 = "You're supposedly normal."
    | bmi <= 30.0 = "You're fat."
    | otherwise = "You're a whale."
    where bmi = weight / height^2

calcBmis :: [(Double, Double)] -> [Double]
calcBmis xs = [bmi w h | (w, h) <- xs]
    where bmi weight height = weight / height^2