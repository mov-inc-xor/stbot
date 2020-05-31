{-# LANGUAGE DeriveGeneric     #-}

module API.LongPoll where

import Data.Aeson
import GHC.Generics

data LongPollResponse = LongPollResponse { 
    response :: LongPollConnection 
} deriving (Generic, Show)

data LongPollConnection = LongPollConnection { 
    key        :: String
  , server     :: String
  , ts         :: String
} deriving (Generic, Show)

data LongPollData = LongPollData { 
    updates :: [Update] 
} deriving (Generic, Show)

data Update = Update { 
    object :: Obj 
} deriving (Generic, Show) 

data Obj = Obj { 
    message :: Maybe Msg 
} deriving (Generic, Show) 

data Msg = Msg { 
    peer_id :: Int
  , text :: String
} deriving (Generic, Show, Eq)

instance FromJSON Msg
instance FromJSON Obj
instance FromJSON Update
instance FromJSON LongPollData
instance FromJSON LongPollResponse
instance FromJSON LongPollConnection
