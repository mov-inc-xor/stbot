module Main where

import Network.HTTP.Req
import Control.Monad
import Control.Monad.IO.Class
import Data.Maybe

import API.API
import API.LongPoll

vk = VK {
    groupId = "195877323"
  , accessToken = "f022db701e9d1932231e2722d245778ce9bf483ad179beccc7545d4c1b956e6df632f7b264f2f7a2bcef9"
  , version = "5.107"
}

handler = do
    lpConnection <- getLongPollConnection vk
    lpData <- getLongPollData lpConnection
    when (isJust lpData) $ do
        let msg = fromJust lpData
            id = peer_id msg
            txt = "Я Вам запрещаю " ++ (text msg)
        respId <- sendMsg vk id txt
        liftIO $ print $ "response=" ++ show respId
    handler
    

main :: IO ()
main = runReq defaultHttpConfig $ do
    handler
