module Main (main) where

import           Prelude
import           System.FilePath.Glob (glob)
import           Test.DocTest         (doctest)

main :: IO ()
main = doctest =<< glob "src/**/*.hs"
