:- use_module(library(dcg/basics)).

run(O) :-
  phrase_from_file(input_file(S, SS, SF, FW, WL, LT, TH, HL), "input.txt"),
  map_multi(S, [SS, SF, FW, WL, LT, TH, HL], O).

map_multi([N | Ns], Ms, O) :-
  map_multi(N, Ms, O1),
  map_multi(Ns, Ms, O2),
  O is min(O1, O2).
map_multi([], _, O) :-
  O is inf.
map_multi(N, [M | Ms], O) :-
  integer(N),
  map(N, M, O1),
  map_multi(O1, Ms, O).
map_multi(N, [], O) :-
  integer(N),
  O is N.

map(N, [Dst, Src, Rng], O) :-
  integer(Dst),
  integer(Src),
  integer(Rng),
  SrcEnd is Src + Rng - 1,
  between(Src, SrcEnd, N),
  O is N - Src + Dst.
map(N, [[Dst, Src, Rng] | _], O) :-
  map(N, [Dst, Src, Rng], O).
map(N, [[Dst, Src, Rng] | Rest], O) :-
  \+ map(N, [Dst, Src, Rng], _),
  map(N, Rest, O).
map(N, [], O) :-
  O is N.

input_file(S, SS, SF, FW, WL, LT, TH, HL) -->
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

map_line([Dst, Src, Rng]) -->
  numbers_line([Dst, Src, Rng]).

numbers_line([N | Ns]) -->
  integer(N),
  whites,
  numbers_line(Ns).
numbers_line([]) --> eol.
numbers_line([]) --> eos.
