--
--  Copyright (C) 2021-2024, AdaCore
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

--  Internal parser to process links, emphasis, code spans and other inline
--  items.

with VSS.String_Vectors;
with VSS.Strings;

with Markdown.Simple_Inline_Parsers;

private with Markdown.Emphasis_Delimiters;

package Markdown.Inlines.Parsers is
   pragma Preelaborate;

   type Inline_Parser is tagged limited private;

   procedure Set_Extensions
     (Self  : in out Inline_Parser;
      Value : Extension_Set);
   --  Set extensions enabled in the parser

   procedure Register
     (Self  : in out Inline_Parser'Class;
      Value : not null Simple_Inline_Parsers.Simple_Inline_Parser_Access);

   function Parse
     (Self  : Inline_Parser'Class;
      Lines : VSS.String_Vectors.Virtual_String_Vector)
     return Markdown.Inlines.Inline_Vector;

   function Parse
     (Self : Inline_Parser'Class;
      Text : VSS.Strings.Virtual_String)
     return Markdown.Inlines.Inline_Vector;

private

   type Inline_Parser is tagged limited record
      Scanner   : Markdown.Emphasis_Delimiters.Scanner;
      Parsers   : Markdown.Simple_Inline_Parsers.Simple_Parser_Vectors.Vector;
      Extension : Extension_Set;
   end record;

   function Parse
     (Self  : Inline_Parser'Class;
      Lines : VSS.String_Vectors.Virtual_String_Vector)
        return Markdown.Inlines.Inline_Vector is
          (Self.Parse (Lines.Join_Lines (VSS.Strings.LF, False)));

end Markdown.Inlines.Parsers;
