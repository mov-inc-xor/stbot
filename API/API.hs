{-# LANGUAGE OverloadedStrings #-}

module API.API (VK (..), getLongPollConnection, getLongPollData, sendMsg) where

import GHC.Generics
import System.Random
import Data.List.Split
import Network.HTTP.Req
import Control.Monad.IO.Class
import Data.Monoid ((<>))
import qualified Data.Text as T

import API.LongPoll as LP
import API.Messages as M

data VK = VK {
    groupId :: String
  , accessToken :: String
  , version :: String
} deriving (Show)

getLastPath url = getLastPath' (splitOn "/" url) where
    getLastPath' (p : []) = T.pack p
    getLastPath' (p : ps) = getLastPath' ps

getLongPollConnection vk = do
    r <- req GET (https "api.vk.com" /: "method" /: "groups.getLongPollServer") NoReqBody jsonResponse $
        "group_id"     =: (groupId vk            :: String) <>
        "access_token" =: (accessToken vk        :: String) <>
        "v"            =: (version vk            :: String)
    return $ (LP.response (responseBody r))

getLongPollData lpConnection = do
    r <- req GET (https "lp.vk.com" /: (getLastPath (server lpConnection))) NoReqBody jsonResponse $
        "act"  =: ("a_check"          :: String) <>
        "key"  =: ((key lpConnection) :: String) <>
        "ts"   =: ((ts lpConnection)  :: String) <>
        "wait" =: ("25"               :: String)
    let upds = updates ((responseBody r) :: LongPollData)
        ret = if length upds == 0 then Nothing else message (object (head (upds)))
    return $ ret

sendMsg vk id msg = do
    randId <- liftIO $ randomRIO ((- 2^63), 2^63)
    r <- req GET (https "api.vk.com" /: "method" /: "messages.send") NoReqBody jsonResponse $
        "random_id"    =: (randId                :: Int) <>
        "peer_id"      =: (id                    :: Int) <>
        "message"      =: (msg                   :: String) <>
        "access_token" =: (accessToken vk        :: String) <>
        "v"            =: (version vk            :: String)
    return $ M.response (responseBody r)