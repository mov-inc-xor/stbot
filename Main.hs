module Main where

import Network.HTTP.Req
import Control.Monad
import Control.Monad.IO.Class
import Data.Maybe

import API.API
import API.LongPoll

vk = VK {
    groupId = ""
  , accessToken = ""
  , version = ""
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
