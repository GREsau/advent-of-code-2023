import Data.List

isZeroes :: [Int] -> Bool
isZeroes [] = True
isZeroes (0:l) = isZeroes l
isZeroes _ = False

readInput = do
  contents <- readFile "input.txt"
  let input :: [[Int]] = map reverse . map (map read) . map words . lines $ contents
  return input

pairs l = zip l (drop 1 l)

differences l = map (uncurry (-)) $ pairs l


findNext :: [Int] -> Int
findNext l = if isZeroes l
  then 0
  else (head l) + findNext (differences l)

part1 = do
    input <- readInput
    let answer = sum $ map findNext input
    putStrLn ("Part 1: " ++ show answer)