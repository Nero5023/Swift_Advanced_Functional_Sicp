firstletter :: String -> String
firstletter "" = "empty stirng, woops!"
firstletter all@(x:xs) = "The first letter of " ++ all ++ " is " ++ [x]