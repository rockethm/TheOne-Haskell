-- KWIC Implementation in Haskell following "The One" Style
-- This implements the Identity monad pattern for chaining operations

module Main where

import Data.List (sort, isPrefixOf)
import Data.Char (toLower, isAlphaNum, isSpace)
import System.Environment (getArgs)
import System.IO

-- The One abstraction - wraps values and provides bind operation
data TFTheOne a = TFTheOne a deriving (Show)

-- Wrap operation (constructor)
wrap :: a -> TFTheOne a
wrap = TFTheOne

-- Bind operation - applies function to wrapped value and rewraps result
bind :: TFTheOne a -> (a -> b) -> TFTheOne b
bind (TFTheOne value) func = TFTheOne (func value)

-- Unwrap operation - extracts value for final output
unwrap :: TFTheOne a -> a
unwrap (TFTheOne value) = value

-- Print operation for final output
printResult :: TFTheOne [String] -> IO ()
printResult (TFTheOne lines) = mapM_ putStrLn lines

-- KWIC Processing Functions

-- Read file content
readFileContent :: FilePath -> IO String
readFileContent filepath = readFile filepath

-- Split content into lines and filter empty ones
splitIntoLines :: String -> [String]
splitIntoLines content = filter (not . null) $ lines content

-- Predefined stop words (common Portuguese and English words)
stopWords :: [String]
stopWords = ["a", "o", "as", "os", "um", "uma", "e", "de", "da", "do", "das", "dos",
             "para", "com", "em", "na", "no", "nas", "nos", "por", "se", "que",
             "the", "an", "and", "or", "but", "in", "on", "at", "to", "for",
             "of", "with", "by", "is", "are", "was", "were", "be", "been", "have",
             "has", "had", "do", "does", "did", "will", "would", "could", "should",
             "sat"]

-- Clean and split line into words
cleanAndSplitWords :: String -> [String]
cleanAndSplitWords line = 
    let cleanLine = map (\c -> if isAlphaNum c || isSpace c then c else ' ') line
        words' = words cleanLine
    in map (map toLower) words'

-- Check if a word is a stop word
isStopWord :: String -> Bool
isStopWord word = map toLower word `elem` stopWords

-- Generate keyword contexts from a single line
-- Returns (keyword, originalLine) pairs
generateKeywordContexts :: String -> [(String, String)]
generateKeywordContexts line =
    let words' = cleanAndSplitWords line
        keywords = filter (not . isStopWord) words'
    in [(kw, line) | kw <- keywords]

-- Generate all keyword contexts from all lines
generateAllKeywordContexts :: [String] -> [(String, String)]
generateAllKeywordContexts lines = 
    concatMap generateKeywordContexts lines

-- Create circular shift for a keyword in its context
-- Returns (shiftedLine, originalLine)
createCircularShift :: (String, String) -> (String, String)
createCircularShift (keyword, originalLine) =
    let words' = words originalLine
        keywordLower = map toLower keyword
        -- Find the position of the keyword (case insensitive)
        findKeywordPos [] _ = Nothing
        findKeywordPos (w:ws) pos 
            | map toLower w == keywordLower = Just pos
            | otherwise = findKeywordPos ws (pos + 1)
        
        keywordPos = findKeywordPos words' 0
    in case keywordPos of
        Just pos -> 
            let (before, after) = splitAt pos words'
                shifted = after ++ before
            in (unwords shifted, originalLine)
        Nothing -> (originalLine, originalLine)

-- Apply circular shifts to all keyword contexts
applyCircularShifts :: [(String, String)] -> [(String, String)]
applyCircularShifts = map createCircularShift

-- Sort keyword contexts alphabetically by shifted line
sortKeywordContexts :: [(String, String)] -> [(String, String)]
sortKeywordContexts contexts = 
    sort contexts

-- Format output lines with context information
formatOutput :: [(String, String)] -> [String]
formatOutput sortedContexts =
    [shiftedLine ++ " (from \"" ++ originalLine ++ "\")" | (shiftedLine, originalLine) <- sortedContexts]

-- Main processing pipeline using The One style
processKWIC :: FilePath -> IO ()
processKWIC filepath = do
    content <- readFileContent filepath
    let result = wrap content
                `bind` splitIntoLines
                `bind` generateAllKeywordContexts
                `bind` applyCircularShifts
                `bind` sortKeywordContexts
                `bind` formatOutput
    printResult result

-- Main function
main :: IO ()
main = do
    args <- getArgs
    case args of
        [filepath] -> processKWIC filepath
        [] -> do
            putStrLn "Please provide input file path as argument"
            putStrLn "Usage: ./kwic input.txt"
        _ -> do
            putStrLn "Too many arguments"
            putStrLn "Usage: ./kwic input.txt"