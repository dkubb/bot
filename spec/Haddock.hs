module Main (main) where

import           Data.List      (genericLength)
import           Data.Maybe     (catMaybes)
import           Prelude
import           System.Exit    (exitFailure, exitSuccess)
import           System.Process (readProcess)
import           Text.Regex     (matchRegex, mkRegex)

main :: IO ()
main = do
    output <- readProcess "cabal" ["haddock"] ""
    if average (match output) == expected
    then exitSuccess
    else putStr output >> exitFailure

average :: [Integer] -> Double
average [] = 0
average xs = realToFrac (sum xs) / genericLength xs

expected :: Double
expected = 100

match :: String -> [Integer]
match = fmap read . concat . catMaybes . fmap (matchRegex pattern) . lines
  where
    pattern = mkRegex "^ *(0|[1-9][0-9]?|100)% "
