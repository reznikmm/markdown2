--
--  Copyright (C) 2021-2023, AdaCore
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

--  Annotated text contains a plain text with all markup removed and
--  a list of corresponding annotations. Each annotation has a segment of
--  the plain text and some additional information if required.

with Ada.Containers.Vectors;

with VSS.Strings;
with VSS.String_Vectors;

with Markdown.Attribute_Lists;

package Markdown.Inlines is
   pragma Preelaborate;

   type Inline_Kind is
     (Text,
      Soft_Line_Break,
      Hard_Line_Break,
      Start_Emphasis,
      End_Emphasis,
      Start_Strong,
      End_Strong,
      Start_Link,
      End_Link,
      Start_Image,
      End_Image,
      Code_Span,
      HTML_Open_Tag,
      HTML_Close_Tag,
      HTML_Comment,
      HTML_Processing_Instruction,
      HTML_Declaration,
      HTML_CDATA);
   --  Kind of annotation for parsed inline content

   type Inline (Kind : Inline_Kind := Inline_Kind'First) is record
      case Kind is
         when Text =>
            Text : VSS.Strings.Virtual_String;

         when Code_Span =>
            Code_Span : VSS.Strings.Virtual_String;

         when Soft_Line_Break
            | Hard_Line_Break
            | Start_Emphasis
            | End_Emphasis
            | Start_Strong
            | End_Strong
            | End_Link
            | End_Image
         =>
            null;

         when Start_Link | Start_Image =>
            Destination : VSS.Strings.Virtual_String;
            Title       : VSS.String_Vectors.Virtual_String_Vector;
            --  Link/image title could span several lines
            Attributes  : Markdown.Attribute_Lists.Attribute_List;
            --  Link/image attributes if Link_Attributes extension is on

         when HTML_Open_Tag =>
            HTML_Open_Tag   : VSS.Strings.Virtual_String;
            HTML_Attributes : Markdown.Attribute_Lists.Attribute_List;

         when HTML_Close_Tag =>
            HTML_Close_Tag : VSS.Strings.Virtual_String;

         when HTML_Comment =>
            HTML_Comment : VSS.String_Vectors.Virtual_String_Vector;

         when HTML_Processing_Instruction =>
            HTML_Instruction : VSS.String_Vectors.Virtual_String_Vector;

         when HTML_Declaration =>
            HTML_Declaration : VSS.String_Vectors.Virtual_String_Vector;

         when HTML_CDATA =>
            HTML_CDATA : VSS.String_Vectors.Virtual_String_Vector;
      end case;
   end record;
   --  An annotation for particular inline content segment

   package Inline_Vectors is new Ada.Containers.Vectors (Positive, Inline);

   type Inline_Vector is new Inline_Vectors.Vector with null record;

end Markdown.Inlines;
