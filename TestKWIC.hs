module TestKWIC where

import Test.HUnit
import Main (
  TFTheOne(..), wrap, bind, unwrap,
  splitIntoLines, cleanAndSplitWords, isStopWord
  )

-- Test using The One style for splitIntoLines
testSplitIntoLines = TestCase $
  let input = "The quick brown fox\nA brown cat sat\nThe cat is brown\n"
      expected = ["The quick brown fox", "A brown cat sat", "The cat is brown"]
      result = unwrap (wrap input `bind` splitIntoLines)
  in assertEqual "Split lines (The One)" expected result

-- Test using The One style for cleanAndSplitWords
testCleanAndSplitWords = TestCase $
  let input = "The quick, brown fox!"
      expected = ["the", "quick", "brown", "fox"]
      result = unwrap (wrap input `bind` cleanAndSplitWords)
  in assertEqual "Clean and split (The One)" expected result

-- Test stop word (does not require The One)
testIsStopWord = TestCase $
  assertBool "'the' is stop word" (isStopWord "the")

tests = TestList
  [ TestLabel "Split Into Lines" testSplitIntoLines
  , TestLabel "Clean And Split Words" testCleanAndSplitWords
  , TestLabel "Is Stop Word" testIsStopWord
  ]

main :: IO Counts
main = runTestTT tests
