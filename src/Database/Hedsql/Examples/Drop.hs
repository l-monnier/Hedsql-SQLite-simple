{-|
Module      : Tests/Hedsql/Common/Parser/TableManipulations/Drop.hs
Description : Collection of DROP statements.
Copyright   : (c) Leonard Monnier, 2015
License     : GPL-3
Maintainer  : leonard.monnier@gmail.com
Stability   : experimental
Portability : portable

A collection of DROP statements to be used in tests or as examples.
-}
module Database.Hedsql.Examples.Drop
    ( dropTableStmt
    , dropTableIfExistsStmt
    ) where

--------------------------------------------------------------------------------
-- IMPORTS
--------------------------------------------------------------------------------

import Database.Hedsql.SqLite

--------------------------------------------------------------------------------
-- PUBLIC
--------------------------------------------------------------------------------

-- | > DROP TABLE "People"
dropTableStmt :: DropTable a
dropTableStmt = dropTable "People"

-- | > DROP IF EXISTS "People"
dropTableIfExistsStmt :: DropTable a
dropTableIfExistsStmt = dropTableIfExists "People"