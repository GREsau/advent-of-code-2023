module CharMap = Map.Make(Char)

let increment option =
  Some (1 + Option.value option ~default:0)

let rec count_chars charseq =
  match Seq.uncons charseq with
  | None -> CharMap.empty
  | Some (c, rest) -> count_chars rest |> CharMap.update c increment

(* this returns lines in reverse-order, which is fine *)
let read_lines () =
  let lines = ref [] in
  let f = open_in "input.txt" in
  ( try
      while true; do
        lines := input_line f :: !lines
      done
    with End_of_file ->
      close_in f);
  !lines

(* convert face card chars to enable lexicographic comparison *)
let lex_char c =
  match c with
  | 'J' -> 'W'
  | 'Q' -> 'X'
  | 'K' -> 'Y'
  | 'A' -> 'Z'
  | c -> c

let parse_hand line =
  let [cards; bid] = String.split_on_char ' ' line in
  let lex_cards = String.map lex_char cards in
  let counts = cards
    |> String.to_seq
    |> count_chars
    |> CharMap.to_list
    |> List.map snd
    |> List.sort (Fun.flip compare) in
  ((counts, lex_cards), int_of_string bid)

let () =
  read_lines()
  |> List.map parse_hand
  |> List.sort compare
  |> List.mapi (fun i hand -> (i + 1) * snd hand)
  |> List.fold_left (+) 0
  |> Printf.printf "Part 1: %d\n"
