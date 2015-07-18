-- | Main bot executable
module Main where

import           Airship
import qualified Bot.Github               as Github
import           Network.Wai.Handler.Warp (defaultSettings, runSettings,
                                           setHost, setPort)
import           Prelude

routes :: RoutingSpec s IO ()
routes = "github" #> Github.resource

notFound :: Resource s m
notFound = defaultResource
    { resourceExists       = return False
    , contentTypesProvided = return [("application/json", return Empty)]
    }

main :: IO ()
main = do
    let port = 3000
        host = "127.0.0.1"
        settings = setPort port (setHost host defaultSettings)
    putStrLn "Listening on port 3000"
    runSettings settings (resourceToWai routes notFound undefined)
