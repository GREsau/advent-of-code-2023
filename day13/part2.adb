with Ada.Text_IO; use Ada.Text_IO;
with Ada.Containers.Vectors;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package body Part2 is

  type Small_Natural is mod 2 ** 31;

  package String_Vectors is new
    Ada.Containers.Vectors
      (Index_Type   => Positive,
       Element_Type => Unbounded_String);

  package Natural_Vectors is new
    Ada.Containers.Vectors
      (Index_Type   => Positive,
       Element_Type => Small_Natural);

  type Pattern is new String_Vectors.Vector with null record;
  type Lines is new Natural_Vectors.Vector with null record;

  function Mirror_Row_Except (L: Lines; Original_Answer: Natural) return Natural is
    Y0, Y1: Natural;
  begin
    for Y in 1 .. (L.Last_Index - 1) loop
      for DY in 0 .. Y loop
        if Y = Original_Answer then
          exit;
        end if;
        Y0 := Y - DY;
        Y1 := Y + DY + 1;

        if Y0 < 1 or Y1 > L.Last_Index then
          return Y;
        end if;

        if Element (L, Y0) /= Element (L, Y1) then
          exit;
        end if;
      end loop;
    end loop;

    return 0;
  end;

  function Parse_Row (Rows: Pattern; Y: Positive) return Small_Natural is
    Result: Small_Natural := 0;
  begin
    for C of To_String (Rows (Y)) loop
      Result := Result * 2;
      if C = '#' then
        Result := Result + 1;
      end if;
    end loop;
    return Result;
  end Parse_Row;

  function Parse_Rows (Rows: Pattern) return Lines is
    Result: Lines;
  begin
    for X in Rows.First_Index .. Rows.Last_Index loop
      Result.Append (Parse_Row (Rows, X));
    end loop;
    return Result;
  end Parse_Rows;

  function Parse_Col (Rows: Pattern; X: Positive) return Small_Natural is
    Result: Small_Natural := 0;
  begin
    for Row of Rows loop
      Result := Result * 2;
      if Element (Row, X) = '#' then
        Result := Result + 1;
      end if;
    end loop;
    return Result;
  end Parse_Col;

  function Parse_Cols (Rows: Pattern) return Lines is
    Result: Lines;
  begin
    for Y in 1 .. Length (Rows(1)) loop
      Result.Append (Parse_Col (Rows, Y));
    end loop;
    return Result;
  end Parse_Cols;

  function Next_Pattern (F: in out File_Type) return Pattern is
    Result: Pattern;
    Line: Unbounded_String;
  begin
    while not End_Of_File (F) loop
      Line := To_Unbounded_String(Get_Line (F));
      if Length (Line) = 0 then
        exit;
      end if;
      Result.Append (Line);
    end loop;
    return Result;
  end Next_Pattern;

  function Max (L: Lines) return Small_Natural is
    Result: Small_Natural := 0;
  begin
    for Y in 1 .. L.Last_Index loop
      if L (Y) > Result then
        Result := Element (L, Y);
      end if;
    end loop;
    return Result;
  end Max;

  function Smudge (L: Lines) return Natural is
    Xp2, MaxL: Small_Natural;
    Original_Answer, Result: Natural;
    Smudged: Lines;
  begin
    Original_Answer := Mirror_Row_Except (L, 424242);
    MaxL := Max (L);
    for Y in 1 .. L.Last_Index loop
      Xp2 := 1;
      while Xp2 < 2 ** 30 loop
        Smudged := L;
        Smudged (Y) := Element (L, Y) xor Xp2;
        Result := Mirror_Row_Except (Smudged, Original_Answer);
        if Result > 0 and Result /= Original_Answer then
          return Result;
        end if;
        Xp2 := Xp2 * 2;
      end loop;
    end loop;

    return 0;
  end Smudge;

  procedure Run is
    F: File_Type;
    P: Pattern;
    Result1: Natural;
    Result: Natural := 0;
  begin
    Open (F, In_File, "input.txt");

    while not End_Of_File (F) loop
      P := Next_Pattern (F);
      Result1 := 100 * Smudge (Parse_Rows (P));
      if Result1 = 0 then
        Result1 := Smudge (Parse_Cols (P));
      end if;
      if Result1 = 0 then
        Put_Line("UH OH, no result found for one of the patterns!");
      end if;
      Result := Result + Result1;
    end loop;

    Close (F);

    Put_Line ("Part 2: " & Natural'Image (Result));
  end Run;

end Part2;