| f inputs nums median partOneFuel partTwoFuel sum mean |

f := FileStream open: (Smalltalk arguments first) mode: FileStream read.
f linesDo: [ 
    :line | inputs := line substrings: ','.
].
f close.


nums := SortedCollection new.
sum := 0.
inputs do: [ :s |
    nums add: (s asNumber).
    sum := sum + (s asNumber).
].
nums sort.

"
Part one
"
median := (nums at: (nums size) / 2).
partOneFuel := 0.
nums do: [ :n |
    partOneFuel := partOneFuel + ((n - median) abs).
].
partOneFuel displayNl.

"
Part two
"
mean := (sum / (nums size) asFloat) floor.
partTwoFuel := 0.
nums do: [ :n |
    partTwoFuel := partTwoFuel + ((((n - mean) abs) * ((n - mean) abs + 1)) / 2).
].
partTwoFuel displayNl.