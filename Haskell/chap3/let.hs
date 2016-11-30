-- let

(let a = 100; b = 20; c = 300 in a*b*c)
(let (a,b,c) = (100, 20, 300) in a*b*c)

calcBmis :: [(Double, Double)] -> String
calcBmis xs = [bmi | (w,h)<-xs, let bmi = w / h^2]