:- use_module(library(dcg/basics)).
:- use_module(library(clpfd)).

run(O) :-
  findall(X, run_(X), S), label(S), list_min(S, O), !.

% thank you, https://stackoverflow.com/questions/3965054/prolog-find-minimum-in-a-list!
list_min([L|Ls], Min) :- foldl(num_num_min, Ls, L, Min).
num_num_min(X, Y, Min) :- Min is min(X, Y).

run_(O) :-
  phrase_from_file(input_file(Seeds, Mss1), "input.txt"),
  maplist(fixup_mappings, Mss1, Mss2),
  pairs_to_domain(Seeds, SeedRange),
  S in SeedRange,
  map_multi(S, Mss2, O).

pairs_to_domain([Start, Length | Rest], O) :-
  End #= Start + Length - 1,
  pairs_to_domain(Rest, R),
  O = Start..End \/ R.
pairs_to_domain([], O) :-
  O = 1..0.

map_multi(I, [Ms | Mss], O) :-
  map(I, Ms, X),
  map_multi(X, Mss, O).
map_multi(I, [], I).

map(I, [M | _], O) :-
  map1(I, M, O).
map(I, [_ | Ms], O) :-
  map(I, Ms, O).
map1(I, mapping(D, S, L), O) :-
  End #= S + L - 1,
  I in S..End,
  O #= I - S + D.

fixup_mappings(Ms, O) :-
  sort_by_source(Ms, Ms2),
  Ms3 = [mapping(0,0,0) | Ms2],
  fill_source_gaps(Ms3, O).

fill_source_gaps([mapping(D1, S1, L1), mapping(D2, S2, L2) | Rest], O) :-
  S is S1 + L1,
  L is S2 - S,
  M = mapping(S, S, L),
  fill_source_gaps([mapping(D2, S2, L2) | Rest], N),
  O = [mapping(D1, S1, L1), M | N].
fill_source_gaps([mapping(D1, S1, L1)], O) :-
  S is S1 + L1,
  L is S * 2,
  M = mapping(S, S, L),
  O = [mapping(D1, S1, L1), M].

sort_by_dest(Ms, O) :-
  sort(1, @<, Ms, O).

sort_by_source(Ms, O) :-
  sort(2, @<, Ms, O).

input_file(S, [SS, SF, FW, WL, LT, TH, HL]) -->
    seeds_line(S),
    eol,
    "seed-to-soil map:", eol,
    map_lines(SS),
    eol,
    "soil-to-fertilizer map:", eol,
    map_lines(SF),
    eol,
    "fertilizer-to-water map:", eol,
    map_lines(FW),
    eol,
    "water-to-light map:", eol,
    map_lines(WL),
    eol,
    "light-to-temperature map:", eol,
    map_lines(LT),
    eol,
    "temperature-to-humidity map:", eol,
    map_lines(TH),
    eol,
    "humidity-to-location map:", eol,
    map_lines(HL).

seeds_line(L) -->
  "seeds:",
  whites,
  numbers_line(L).

map_lines([M | Ms]) -->
  map_line(M),
  map_lines(Ms).
map_lines([]) --> [].

map_line(mapping(Dst, Src, Len)) -->
  numbers_line([Dst, Src, Len]).

numbers_line([N | Ns]) -->
  integer(N),
  whites,
  numbers_line(Ns).
numbers_line([]) --> eol.
numbers_line([]) --> eos.
