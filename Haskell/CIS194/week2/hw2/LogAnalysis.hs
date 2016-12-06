{-# OPTIONS_GHC -Wall #-}
module LogAnalysis where

import Log

-- data MessageType = Info
--                  | Warning
--                  | Error Int
--   deriving (Show, Eq)

-- type TimeStamp = Int

-- data LogMessage = LogMessage MessageType TimeStamp String
--                 | Unknown String
--   deriving (Show, Eq)

-- data MessageTree = Leaf
--                  | Node MessageTree LogMessage MessageTree
--   deriving (Show, Eq)

-- Exercise 1
parseMessage :: String -> LogMessage
parseMessage = parseMessageList . words 

parseMessageList :: [String] -> LogMessage
parseMessageList ("E" : n : time : xs) = LogMessage (Error (read n::Int)) (read time :: TimeStamp) (unwords xs)
parseMessageList ("W" : time : xs) = LogMessage Warning (read time::Int) (unwords xs)
parseMessageList ("I" : time : xs) = LogMessage Info (read time::Int) (unwords xs)
parseMessageList xs = Unknown (unwords xs)

parse :: String -> [LogMessage]
parse = map parseMessage . lines

newNode :: LogMessage -> MessageTree
newNode msg = Node Leaf msg Leaf


instance Ord LogMessage where
    (LogMessage _ ts1 _) `compare` (LogMessage _ ts2 _) = ts1 `compare` ts2
    _ `compare` _ = error "Compare error"

insert :: LogMessage -> MessageTree -> MessageTree
insert (Unknown _ ) tree = tree
insert message Leaf = newNode message
insert message (Node Leaf node rightChild)
    | message < node = Node (newNode message) node rightChild
insert message (Node leftChild node Leaf)
    | message > node = Node leftChild node (newNode message)
insert message (Node leftChild node rightChild)
    | message < node = Node (insert message leftChild) node rightChild
    | otherwise = Node leftChild node (insert message rightChild)


-- Exercise 3
build :: [LogMessage] -> MessageTree
build [] = Leaf
build (x:xs) = insert x $ build xs

-- Exercise 4
inOrder :: MessageTree -> [LogMessage]
inOrder Leaf = []
inOrder (Node leftChild node rightChild) = (inOrder leftChild) ++ [node] ++ (inOrder rightChild)

-- Exercise 5
toStr :: LogMessage -> String
toStr (LogMessage _ _ message) = message

wentWrong :: LogMessage -> Bool
wentWrong  (LogMessage (Error severity) _ _) = severity >= 50
wentWrong _ = False

whatWentWrong :: [LogMessage] -> [String]
whatWentWrong mesgs = map toStr $ inOrder . build $ filter wentWrong mesgs

-- whatWentWrong :: [LogMessage] -> [String]
-- whatWentWrong mesgs = map (\(LogMessage _ _ message) -> message) $ inOrder . build $ filter wentWrong mesgs