module Part2

import Data.List
import Data.SortedMap
import Data.SortedSet
import Data.String
import System.File

data Direction = Up | Right | Down | Left

castDirection : Direction -> Nat
castDirection Up = 0
castDirection Right = 1
castDirection Down = 2
castDirection Left = 3

Eq Direction where
  (==) Up Up = True
  (==) Right Right = True
  (==) Down Down = True
  (==) Left Left = True
  (==) _ _ = False
Ord Direction where
  compare a b = compare (castDirection a) (castDirection b)

record Input where
  constructor MkInput
  width, height : Int
  chars : SortedMap (Int, Int) Char

build_chars : (x: Int) -> (y: Int) -> List (List Char) -> SortedMap (Int, Int) Char
build_chars _ _ Nil = empty
build_chars x y (('.' :: l) :: ls) = build_chars (x+1) y (l :: ls)
build_chars x y ((c :: l) :: ls) = insert (x, y) c (build_chars (x+1) y (l :: ls))
build_chars _ y (Nil :: ls) = build_chars 0 (y+1) ls

parse_input : List String -> Input
parse_input Nil = MkInput 0 0 empty
parse_input (l :: ls) = MkInput (cast (length l)) (cast (length (l :: ls))) (build_chars 0 0 (map unpack (l :: ls)))

record Beam where
    constructor MkBeam
    pos : (Int, Int)
    direction : Direction

Eq Beam where
  (==) a b = (a.pos, a.direction) == (b.pos, b.direction)
Ord Beam where
  compare a b = compare (a.pos, a.direction) (b.pos, b.direction)

record State where
  constructor MkState
  input : Input
  all_beams : SortedSet Beam
  active_beams : List Beam

initial_beams : Input -> List Beam
initial_beams (MkInput width height _) =
  let xs = [0 .. width-1]
      ys = [0 .. height-1]
      left = map (\y => MkBeam (0, y) Right) ys
      right = map (\y => MkBeam (width-1, y) Left) ys
      top = map (\x => MkBeam (x, 0) Down) xs
      bottom = map (\x => MkBeam (x, height-1) Up) xs in
    left ++ right ++ top ++ bottom

initial_states : List String -> List State
initial_states lines =
  let input = parse_input lines in
    map (\b => MkState input empty [b]) (initial_beams input)

trimmed : List String -> List String
trimmed lines = filter (/= "") (map trim lines)

move_forward : Beam -> Beam
move_forward (MkBeam (x, y) direction) = case direction of
  Up => MkBeam (x, y-1) direction
  Down => MkBeam (x, y+1) direction
  Left => MkBeam (x-1, y) direction
  Right => MkBeam (x+1, y) direction

run_one : Beam -> State -> State
run_one beam state =
  let (MkBeam (x, y) direction) = beam in
    if x < 0 || x >= state.input.width || y < 0 || y >= state.input.height then
      -- beam is outside the map and should be ignored
      state
    else if contains beam state.all_beams then
      -- we've processed this beam before
      state
    else
      let tile = lookup (x, y) state.input.chars
          next_directions = case (tile, direction) of
            (Just '/', Right) => [Up]
            (Just '/', Down) => [Left]
            (Just '/', Left) => [Down]
            (Just '/', Up) => [Right]
            (Just '\\', Right) => [Down]
            (Just '\\', Down) => [Right]
            (Just '\\', Left) => [Up]
            (Just '\\', Up) => [Left]
            (Just '|', Right) => [Up, Down]
            (Just '|', Left) => [Up, Down]
            (Just '-', Up) => [Left, Right]
            (Just '-', Down) => [Left, Right]
            _ => [direction]
          next_beams = map (\d => move_forward (MkBeam (x, y) d)) next_directions in
        { all_beams $= (insert beam), active_beams $= (++ next_beams) } state

run : State -> State
run (MkState input all_beams (ab :: abs)) = run (run_one ab (MkState input all_beams abs))
run s = s

maxl : List Nat -> Nat
maxl l = foldl max 0 l

energized_tiles : State -> Nat
energized_tiles initial_state =
  let end_state = run initial_state
      positions = SortedSet.fromList (map Beam.pos (SortedSet.toList end_state.all_beams)) in
    length (SortedSet.toList positions)

max_energized_tiles : List String -> Nat
max_energized_tiles lines =
  let states = initial_states (trimmed lines)
      scores = map energized_tiles states in
    maxl scores

export
part2 : IO ()
part2 = do  Right (_, lines) <- readFilePage 0 forever "input.txt"
              | Left err => printLn err
            putStrLn ("Part 2: " ++ (show (max_energized_tiles lines)))