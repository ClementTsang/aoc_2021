import qualified Control.Monad
import System.IO

readDataFrom fileHandle index zeroes ones =
  do
    isFileEnd <- hIsEOF fileHandle
    if isFileEnd
      then
        if zeroes > ones
          then return (0, 1)
          else return (1, 0)
      else do
        line <- hGetLine fileHandle
        let bit = fromEnum (line !! index) - fromEnum '0'
        if bit == 0
          then readDataFrom fileHandle index (zeroes + 1) ones
          else readDataFrom fileHandle index zeroes (ones + 1)

binToInt =
  foldl (\acc x -> x + 2 * acc) 0

partOne digit gamma epsilon =
  if digit < 12
    then do
      fileHandle <- openFile "input.txt" ReadMode
      (g, e) <- readDataFrom fileHandle digit 0 0

      let gl = gamma ++ [g]
      let el = epsilon ++ [e]
      partOne (digit + 1) gl el
    else return (binToInt epsilon * binToInt gamma)

readFileToList fileHandle currentList =
  do
    isFileEnd <- hIsEOF fileHandle
    if isFileEnd
      then return currentList
      else do
        line <- hGetLine fileHandle
        let newList = currentList ++ [line]
        readFileToList fileHandle newList

filterListOxygen currentList index zeroes ones =
  if null currentList
    then if length zeroes > length ones then zeroes else ones
    else do
      let bit = fromEnum (head currentList !! index) - fromEnum '0'
      if bit == 0
        then filterListOxygen (tail currentList) index (zeroes ++ [head currentList]) ones
        else filterListOxygen (tail currentList) index zeroes (ones ++ [head currentList])

getOxygen currentList index
  | index == 12 = head currentList
  | length currentList == 1 = head currentList
  | otherwise = do
    let newList = filterListOxygen currentList index [] []
    getOxygen newList (index + 1)

filterListCO2 currentList index zeroes ones =
  if null currentList
    then if length zeroes <= length ones then zeroes else ones
    else do
      let bit = fromEnum (head currentList !! index) - fromEnum '0'
      if bit == 0
        then filterListCO2 (tail currentList) index (zeroes ++ [head currentList]) ones
        else filterListCO2 (tail currentList) index zeroes (ones ++ [head currentList])

getCO2 currentList index
  | index == 12 = head currentList
  | length currentList == 1 = head currentList
  | otherwise = do
    let newList = filterListCO2 currentList index [] []
    getCO2 newList (index + 1)

stringToIntArr l acc =
  if null l
    then acc
    else stringToIntArr (tail l) (acc ++ [fromEnum (head l) - fromEnum '0'])

partTwo =
  do
    fileHandle <- openFile "input.txt" ReadMode
    currentList <- readFileToList fileHandle []

    let o = binToInt (stringToIntArr (getOxygen currentList 0) [])
    let c = binToInt (stringToIntArr (getCO2 currentList 0) [])
    return (o * c)

main =
  do
    valOne <- partOne 0 [] []
    print valOne

    valTwo <- partTwo
    print valTwo

    return ()
