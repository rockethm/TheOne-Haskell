module TestKWIC where

import Test.HUnit
import Main (
  TFTheOne(..), wrap, bind, unwrap,
  splitIntoLines, cleanAndSplitWords, isStopWord,
  generateKeywordContexts, generateAllKeywordContexts, sortKeywordContexts
  )
import Distribution.Simple.Test (test)

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

-- Test: generateKeywordContexts
testGenerateKeywordContexts = TestCase $
  let input = "The brown fox jumps"
      expected =
        [ ("brown", input)
        , ("fox", input)
        , ("jumps", input)
        ]
      result = unwrap (wrap input `bind` generateKeywordContexts)
  in assertEqual "generateKeywordContexts" expected result

-- Test: generateAllKeywordContexts
testGenerateAllKeywordContexts = TestCase $
  let inputLines = ["Jump high", "The dog sleeps"]
      expected =
        [ ("jump", "Jump high")
        , ("high", "Jump high")
        , ("dog", "The dog sleeps")
        , ("sleeps", "The dog sleeps")
        ]
      result = unwrap (wrap inputLines `bind` generateAllKeywordContexts)
  in assertEqual "generateAllKeywordContexts" expected result

-- Test: createCircularShifts
testCreateCircularShifts = TestCase $
  let input = [("cat", "The cat is brown")]
      expected = [("cat is brown The", "The cat is brown")]
      result = unwrap (wrap input `bind` createCircularShifts)
  in assertEqual "createCircularShifts" expected result

-- Test: applyCircularShifts
testApplyCircularShifts = TestCase $
  let input = [("cat", "The cat is brown")]
      expected = [("cat is brown The", "The cat is brown")]
      result = unwrap (wrap input `bind` applyCircularShifts)
  in assertEqual "applyCircularShifts" expected result

-- Test: sortKeywordContexts
testSortKeywordContexts = TestCase $
  let input =
        [ ("zebra", "A zebra")
        , ("apple", "An apple")
        , ("monkey", "A monkey")
        ]
      expected =
        [ ("apple", "An apple")
        , ("monkey", "A monkey")
        , ("zebra", "A zebra")
        ]
      result = unwrap (wrap input `bind` sortKeywordContexts)
  in assertEqual "sortKeywordContexts" expected result

-- Test: formatOutput
testFormatOutput = TestCase $
  let input = [("cat", "The cat is brown")]
      expected = ["cat (from \"The cat is brown\")"]
      result = unwrap (wrap input `bind` formatOutput)
  in assertEqual "formatOutput" expected result

tests = TestList
  [ TestLabel "Split Into Lines" testSplitIntoLines
  , TestLabel "Clean And Split Words" testCleanAndSplitWords
  , TestLabel "Is Stop Word" testIsStopWord
  , TestLabel "generateKeywordContexts" testGenerateKeywordContexts
  , TestLabel "generateAllKeywordContexts" testGenerateAllKeywordContexts
  , TestLabel "createCircularShifts" testCreateCircularShifts
  , TestLabel "applyCircularShifts" testApplyCircularShifts
  , TestLabel "sortKeywordContexts" testSortKeywordContexts
  , TestLabel "formatOutput" testFormatOutput
  ]

main :: IO Counts
main = runTestTT tests