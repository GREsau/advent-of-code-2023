with Ada.Text_IO; use Ada.Text_IO;
with Ada.Containers.Vectors;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package body Part1 is

  package String_Vectors is new
    Ada.Containers.Vectors
      (Index_Type   => Positive,
       Element_Type => Unbounded_String);

  package Integer_Vectors is new
    Ada.Containers.Vectors
      (Index_Type   => Positive,
       Element_Type => Integer);

  type Pattern is new String_Vectors.Vector with null record;
  type Lines is new Integer_Vectors.Vector with null record;

  function Mirror_Row (L: Lines) return Natural is
    Y0, Y1: Natural;
  begin
    for Y in 1 .. (L.Last_Index - 1) loop
      for DY in 0 .. Y loop
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

  function Parse_Row (Rows: Pattern; Y: Positive) return Natural is
    Result: Natural := 0;
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

  function Parse_Col (Rows: Pattern; X: Positive) return Natural is
    Result: Natural := 0;
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

  procedure Run is
    F: File_Type;
    P: Pattern;
    Result: Natural := 0;
  begin
    Open (F, In_File, "input.txt");

    while not End_Of_File (F) loop
      P := Next_Pattern (F);
      Result := Result + 100 * Mirror_Row (Parse_Rows (P)) + Mirror_Row (Parse_Cols (P));
    end loop;

    Put_Line ("Part 1: " & Integer'Image (Result));
  end Run;

end Part1;