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
