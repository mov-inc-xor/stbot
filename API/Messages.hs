{-# LANGUAGE DeriveGeneric     #-}

module API.Messages where

import Data.Aeson
import GHC.Generics

data SuccessResponse = SuccessResponse { 
    response :: Int 
} deriving (Generic, Show)

instance FromJSON SuccessResponse