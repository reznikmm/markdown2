--
--  Copyright (C) 2021-2023, AdaCore
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

with VSS.Regular_Expressions;

with Markdown.Inlines;

package body Markdown.Implementation.Auto_Links is

   Absolute_URI : constant Wide_Wide_String :=
     "[a-zA-Z][a-zA-Z0-9+.-]+:[^ \t\n\v\f\r<>]*";

   EMail        : constant Wide_Wide_String :=
     "[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@" &
     "[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?" &
     "(?:\." &
     "[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?)*";

   Link_Pattern : constant Wide_Wide_String :=
     "<(" & Absolute_URI & "|(" & EMail & "))>";
   --  1                     2   <-- group indexes

   Link : VSS.Regular_Expressions.Regular_Expression;
   --  Regexp of Link_Pattern

   ---------------------
   -- Parse_Auto_Link --
   ---------------------

   procedure Parse_Auto_Link
     (Text : VSS.Strings.Virtual_String;
      From : VSS.Strings.Cursors.Abstract_Character_Cursor'Class;
      Span : out Markdown.Simple_Inline_Parsers.Inline_Span)
   is
      Match : VSS.Regular_Expressions.Regular_Expression_Match;
   begin
      if not Link.Is_Valid then  --  Construct Link regexp
         Link := VSS.Regular_Expressions.To_Regular_Expression
           (VSS.Strings.To_Virtual_String (Link_Pattern));
      end if;

      Match := Link.Match (Text, From);

      if Match.Has_Match then
         declare
            Plain  : constant VSS.Strings.Virtual_String :=
              Match.Captured (1);
            URL    : VSS.Strings.Virtual_String := Plain;
            Inline : Markdown.Inlines.Inline;
         begin
            if Match.Has_Capture (2) then
               URL.Prepend ("mailto:");
            end if;

            Inline :=
              (Kind        => Markdown.Inlines.Start_Link,
               Destination => URL,
               Title       => <>,
               Attributes  => <>);

            Span :=
              (Is_Set     => True,
               From       => Match.First_Marker,
               To         => Match.Last_Marker,
               Annotation => Inline,
               Text       => Plain);
         end;
      else
         Span := (Is_Set => False);
      end if;
   end Parse_Auto_Link;

end Markdown.Implementation.Auto_Links;
