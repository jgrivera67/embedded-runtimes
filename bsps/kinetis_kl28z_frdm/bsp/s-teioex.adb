--
--  Copyright (c) 2016-2017, German Rivera
--  All rights reserved.
--
--  Redistribution and use in source and binary forms, with or without
--  modification, are permitted provided that the following conditions are met:
--
--  * Redistributions of source code must retain the above copyright notice,
--    this list of conditions and the following disclaimer.
--
--  * Redistributions in binary form must reproduce the above copyright notice,
--    this list of conditions and the following disclaimer in the documentation
--    and/or other materials provided with the distribution.
--
--  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
--  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
--  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
--  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
--  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
--  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
--  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
--  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
--  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
--  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
--  POSSIBILITY OF SUCH DAMAGE.

with Memory_Protection;

package body System.Text_IO.Extended is
   use Interfaces;

   --------------
   -- New_Line --
   --------------

   procedure New_Line is
   begin
      Put (ASCII.LF);
      Put (ASCII.CR);
   end New_Line;

   ----------------
   -- Put_String --
   ----------------

   procedure Put_String (Str : String) is
   begin
      for Char of Str loop
         loop
            exit when Is_Tx_Ready;
         end loop;

         Put (Char);
         if Char = ASCII.LF then
            Put (ASCII.CR);
         end if;
      end loop;
   end Put_String;

   ------------------------------
   -- Print_Uint32_Hexadecimal --
   ------------------------------

   procedure Print_Uint32_Hexadecimal (Value : Unsigned_32) is
      Buffer : String (1 .. 8);
      Hex_Digit : Unsigned_32 range 16#0# .. 16#f#;
      Start_Index : Positive range Buffer'Range := Buffer'First;
      Value_Left : Unsigned_32 := Value;
   begin
      Put_String ("0x");
      for I in reverse Buffer'Range loop
         Hex_Digit := Value_Left and 16#f#;
         if Hex_Digit < 16#a# then
            Buffer (I) := Character'Val (Hex_Digit + Character'Pos ('0'));
         else
            Buffer (I) := Character'Val ((Hex_Digit - 16#a#) +
                                         Character'Pos ('A'));
         end if;

         Value_Left := Shift_Right (Value_Left, 4);
         if Value_Left = 0 then
            Start_Index := I;
            exit;
         end if;
      end loop;

      Put_String (Buffer (Start_Index .. Buffer'Last));
   end Print_Uint32_Hexadecimal;

end System.Text_IO.Extended;
