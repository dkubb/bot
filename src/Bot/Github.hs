-- | Github Resource module
module Bot.Github (resource) where

import           Airship
import           Bot.Internal
import qualified Data.ByteString.Lazy as LB
import           Data.Int             (Int64)
import           Data.Maybe           (fromJust)
import           Network.HTTP.Media   (MediaType, mapContentMedia)
import qualified Network.HTTP.Types   as HTTP
import           Prelude

maximumPayloadSize :: Int64
maximumPayloadSize = 1048576  -- 1MB

-- | Github resource
resource :: Resource s IO
resource = defaultResource
    { allowedMethods       = return [HTTP.methodPost]
    , malformedRequest     = testRequest
    , forbidden            = testSignatureHeader
    , entityTooLarge       = testPayloadSize
    , knownContentType     = contentTypeMatches (fmap fst accepted)
    , processPost          = return (PostProcess negotiatePostHandler)
    , contentTypesProvided = return [("application/json", return Empty)]
    }

-- | Accepted media types
accepted :: [(MediaType, Handler s m ())]
accepted = [("application/json", pushEvent)]

-- | Test the event header
testRequest :: Handler s m Bool
testRequest = testHeader "X-GitHub-Event" (== "push")

-- | Test the signature header
testSignatureHeader :: Handler s IO Bool
testSignatureHeader = do
    payload <- requestPayload
    testHeader "X-Hub-Signature" (verifySignature hmacKey payload)
  where
    hmacKey = "secret"  -- TODO: make this configurable

-- | Test the request payload size
testPayloadSize :: Handler s IO Bool
testPayloadSize = do
    payload <- requestPayload
    return $ LB.length payload > maximumPayloadSize

-- | Negotiate the request handler
negotiatePostHandler :: Handler s m ()
negotiatePostHandler = do
    req <- request
    let postHandler = fromJust $ do
            cType <- lookup HTTP.hContentType (requestHeaders req)
            mapContentMedia accepted cType
    postHandler

-- | Handle push event
pushEvent :: Handler s m ()
pushEvent = do
    addResponseHeader ("Push-Event", "True")  -- XXX: DEBUG
    return ()
