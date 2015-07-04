-- | Bot internal module
module Bot.Internal
    ( verifySignature
    , testHeader
    , requestPayload) where

import           Airship
import           Control.Monad.IO.Class (liftIO)
import           Data.ByteString        as B
import           Data.ByteString.Char8  as B8
import qualified Data.ByteString.Lazy   as LB
import qualified Data.Digest.Pure.SHA   as SHA
import           Data.SecureMem
import qualified Network.HTTP.Types     as HTTP
import           Prelude

-- | Verify the HMAC of the text and key
verifySignature :: LB.ByteString -> LB.ByteString -> B.ByteString -> Bool
verifySignature key text = secureCompare expected
  where
    expected = B8.pack ("sha1=" ++ SHA.showDigest (SHA.hmacSha1 key text))

-- | Secure constant time comparison
secureCompare :: (ToSecureMem a, ToSecureMem b) => a -> b -> Bool
secureCompare a b = toSecureMem a == toSecureMem b

-- | Test request header if it exists
testHeader :: HTTP.HeaderName -> (B.ByteString -> Bool) -> Handler s m Bool
testHeader name test = do
    req <- request
    case lookup name $ requestHeaders req of
        Nothing    -> return True
        Just value -> return $ not $ test value

-- | Request payload
requestPayload :: Handler s IO LB.ByteString
requestPayload = do
    req <- request
    liftIO (entireRequestBody req)
