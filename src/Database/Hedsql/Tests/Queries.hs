module Database.Hedsql.Tests.Queries
    ( tests
    ) where

--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------

import Database.Hedsql.Examples.Select

import Test.Framework                 (Test, testGroup)
import Test.Framework.Providers.HUnit (testCase)
import Test.HUnit              hiding (Test)

import qualified Database.Hedsql.SqLite     as S
import qualified Database.Hedsql.PostgreSQL as P

--------------------------------------------------------------------------------
-- PRIVATE
--------------------------------------------------------------------------------

----------------------------------------
-- SELECT
----------------------------------------

testSelectAllSqLite :: Test
testSelectAllSqLite = testCase "Select all" assertSelect
    where
        assertSelect :: Assertion
        assertSelect = assertEqual
            "Select all query is incorrect"
            "SELECT * FROM \"People\""
            (S.parse selectAll)

testSelectDistinctSqLite :: Test
testSelectDistinctSqLite = testCase "Select distinct" assertSelect
    where
        assertSelect :: Assertion
        assertSelect = assertEqual
            "Select distinct query is incorrect"
            "SELECT DISTINCT \"firstName\" FROM \"People\""
            (S.parse distinctSelect)

----------------------------------------
-- Functions
----------------------------------------
          
testAdditionSqLite :: Test
testAdditionSqLite = testCase "Addition" assertSelect
    where
        assertSelect :: Assertion
        assertSelect = assertEqual
            "Addition in query is incorrect"
            "SELECT (\"age\" + 1) FROM \"People\""
            (S.parse addition)
            
testMultiplicationSqLite :: Test
testMultiplicationSqLite = testCase "Multiplication" assertSelect
    where
        assertSelect :: Assertion
        assertSelect = assertEqual
            "Multiplication in query is incorrect"
            "SELECT (3 * 4)"
            (S.parse multiplication)

testCurrentDateSqLite :: Test
testCurrentDateSqLite = testCase "Current date" assertSelect
    where
        assertSelect :: Assertion
        assertSelect = assertEqual
            "Current date function in query is incorrect"
            "SELECT Date('now')"
            (S.parse selectCurrentDate)
            
testRandomSqLite :: Test
testRandomSqLite = testCase "Random" assertSelect
    where
        assertSelect :: Assertion
        assertSelect = assertEqual
            "Random function in query is incorrect"
            "SELECT random()"
            (S.parse selectRandom)

----------------------------------------
-- FROM
----------------------------------------

testCrossJoinSqLite :: Test
testCrossJoinSqLite = testCase "Cross join" assertFrom
    where
        assertFrom :: Assertion
        assertFrom = assertEqual
            "Cross join is incorrect"
            "SELECT * FROM \"People\" CROSS JOIN \"Countries\""
            (S.parse fromCrossJoin)
            
testInnerJoinOnSqLite :: Test
testInnerJoinOnSqLite = testCase "Inner join SqLite" assertFrom
    where
        assertFrom :: Assertion
        assertFrom = assertEqual
            "SqLite inner join is incorrect"
           ("SELECT * "
         ++ "FROM \"People\" "
         ++ "INNER JOIN \"Countries\" "
         ++ "ON \"People\".\"countryId\" = \"Countries\".\"countryId\"")
            (S.parse fromInnerJoinOn)

testInnerJoinUsingSqLite :: Test
testInnerJoinUsingSqLite = testCase "Inner join USING SqLite" assertFrom
    where
        assertFrom :: Assertion
        assertFrom = assertEqual
            "SqLite inner join using is incorrect"
           ("SELECT * "
         ++ "FROM \"People\" INNER JOIN \"Countries\" USING (\"countryId\")")
            (S.parse fromInnerJoinUsing)

testNaturalInnerJoin :: Test
testNaturalInnerJoin = testCase "Natural inner join" assertFrom
    where
        assertFrom :: Assertion
        assertFrom = assertEqual
            "Natural inner join is incorrect"
            "SELECT * FROM \"People\" NATURAL INNER JOIN \"Countries\""
            (S.parse fromNaturalInnerJoin)

testLeftJoinOn :: Test
testLeftJoinOn = testCase "Left join on" assertFrom
    where
        assertFrom :: Assertion
        assertFrom = assertEqual
            "Left join on is incorrect"
            (  "SELECT * FROM \"People\" LEFT JOIN \"Countries\" "
            ++ "ON \"People\".\"countryId\" = \"Countries\".\"countryId\""
            )
            (S.parse fromLeftJoinOn)

testLeftJoinUsing :: Test
testLeftJoinUsing = testCase "Left join using" assertFrom
    where
        assertFrom :: Assertion
        assertFrom = assertEqual
            "Left join using is incorrect"
            (  "SELECT * FROM \"People\" LEFT JOIN \"Countries\" "
            ++ "USING (\"countryId\")"
            )
            (S.parse fromLeftJoinUsing)
 
testRightJoinOn :: Test
testRightJoinOn = testCase "Right join on" assertFrom
    where
        assertFrom :: Assertion
        assertFrom = assertEqual
            "Right join on is incorrect"
            (  "SELECT * FROM \"People\" RIGHT JOIN \"Countries\" "
            ++ "ON \"People\".\"countryId\" = \"Countries\".\"countryId\""
            )
            (S.parse fromRightJoinOn) 

testFullJoinOn :: Test
testFullJoinOn = testCase "Full join on" assertFrom
    where
        assertFrom :: Assertion
        assertFrom = assertEqual
            "Full join on is incorrect"
            (  "SELECT * FROM \"People\" FULL JOIN \"Countries\" "
            ++ "ON \"People\".\"countryId\" = \"Countries\".\"countryId\""
            )
            (S.parse fromFullJoinOn) 

testLeftJoinOnAnd :: Test
testLeftJoinOnAnd = testCase "Left join on and" assertFrom
    where
        assertFrom :: Assertion
        assertFrom = assertEqual
            "Left join on and is incorrect"
            (  "SELECT * FROM \"People\" LEFT JOIN \"Countries\" "
            ++ "ON (\"People\".\"countryId\" = \"Countries\".\"countryId\" "
            ++ "AND \"Countries\".\"name\" = 'Italy')"
            )
            (S.parse fromLeftJoinOnAnd) 
            
-- PostgreSQL specifics.

testSelectDistinctOnPostgreSQL :: Test
testSelectDistinctOnPostgreSQL = testCase "Select distinct on" assertSelect
    where
        assertSelect :: Assertion
        assertSelect = assertEqual
            "Select distinct on query is incorrect"
           ("SELECT DISTINCT ON (\"firstName\") * "
         ++ "FROM \"People\" ORDER BY \"age\"")
            (P.parse distinctOnSelect)

--------------------------------------------------------------------------------
-- PUBLIC
--------------------------------------------------------------------------------

-- | Gather all tests.
tests :: Test
tests = testGroup "Select"
    [ testGroup "All vendors"
        [ testSelectAllSqLite
        , testSelectDistinctSqLite
        , testAdditionSqLite
        , testCurrentDateSqLite
        , testMultiplicationSqLite
        , testCrossJoinSqLite
        , testInnerJoinOnSqLite
        , testInnerJoinUsingSqLite
        , testNaturalInnerJoin
        , testLeftJoinOn
        , testLeftJoinUsing
        , testRightJoinOn
        , testFullJoinOn
        , testLeftJoinOnAnd
        , testRandomSqLite
        ]
    , testGroup "PostgreSQL"
        [ testSelectDistinctOnPostgreSQL
        ]
    ]