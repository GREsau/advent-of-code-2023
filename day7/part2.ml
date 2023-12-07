module CharMap = Map.Make(Char)

let increment option =
  Some (1 + Option.value ~default:0 option)

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
  | 'J' -> '0'
  | 'Q' -> 'X'
  | 'K' -> 'Y'
  | 'A' -> 'Z'
  | c -> c

let get_counts cards =
  match cards with
  | "JJJJJ" -> [5]
  | _ ->
    let count_map = cards
      |> String.to_seq
      |> count_chars in
    let joker_count = count_map
      |> CharMap.find_opt 'J'
      |> Option.value ~default:0 in
    let counts = count_map
      |> CharMap.remove 'J'
      |> CharMap.to_list
      |> List.map snd
      |> List.sort (Fun.flip compare) in
    (joker_count + List.hd counts) :: (List.tl counts)

let parse_hand line =
  let [cards; bid] = String.split_on_char ' ' line in
  let lex_cards = String.map lex_char cards in
  ((get_counts cards, lex_cards), int_of_string bid)

let () =
  read_lines()
  |> List.map parse_hand
  |> List.sort compare
  |> List.mapi (fun i hand -> (i + 1) * snd hand)
  |> List.fold_left (+) 0
  |> Printf.printf "Part 2: %d\n"
