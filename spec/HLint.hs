module Main (main) where

import           Language.Haskell.HLint (hlint)
import           Prelude
import           System.Exit            (exitFailure, exitSuccess)
import           System.FilePath.Glob   (glob)

main :: IO ()
main = do
    hlints <- hlint =<< glob "**/*.hs"
    if null hlints
    then exitSuccess
    else exitFailure
