--
--  Copyright (c) 2016, German Rivera
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
--

--
--  Note: This package cannot contain any elaboration code, since procedure
--  Initialize needs to be invoked from the startup code, before package
--  elaboration code is executed
--
pragma Restrictions (No_Elaboration_Code);

with System.Storage_Elements;
with Interfaces.Bit_Types;
private with Kinetis_K64F.MPU;

--
--  @summary Memory Protection Services
--
package Memory_Protection is
   pragma SPARK_Mode (Off);
   pragma Preelaborate;

   use System.Storage_Elements;
   use System;
   use Interfaces.Bit_Types;
   use Interfaces;

   --
   --  MPU region alignment (in bytes)
   --
   MPU_Region_Alignment : constant := 32;

   --
   --  MPU regions assignment
   --
   type MPU_Region_Id_Type is (
      --
      --  Regions accessible by the CPU core only
      --  (CPU core is the bus master):
      --
      Default_Background_Region,
      Global_Flash_Code_Region,
      Global_RAM_Code_Region,
      Global_Interrupt_Stack_Region,
      Global_MPU_IO_Region,
      Global_Background_Data_Region,
      Thread_Stack_Data_Region,
      Private_Data_Region,
      Private_Code_Region,

      --
      --  Regions accessible by DMA-capable devices
      --
      DMA_Region1,
      DMA_Region2,
      DMA_Region3);

   for MPU_Region_Id_Type use (Default_Background_Region => 0,
                               Global_Flash_Code_Region => 1,
                               Global_RAM_Code_Region => 2,
                               Global_Interrupt_Stack_Region => 3,
                               Global_MPU_IO_Region => 4,
                               Global_Background_Data_Region => 5,
                               Thread_Stack_Data_Region => 6,
                               Private_Data_Region => 7,
                               Private_Code_Region => 8,
                               DMA_Region1 => 9,
                               DMA_Region2 => 10,
                               DMA_Region3 => 11);

   --
   --  Saved MPU region descriptor
   --
   type MPU_Region_Descriptor_Type is private;

   --
   --  Thread-private MPU regions
   --
   --  @field Stack_Region MPU region for the thread's stack
   --  @field Object_Data_Region MPU region for current provate object data
   --  region for the thread.
   --  @field Code_Region MPU region for the current private code region
   --  for the thread.
   --  @field Writable_Background_Region_Enabled Flag indicating if the
   --  background region is currently writable for the thread (true) or
   --  read-only (false).
   --
   type Thread_Regions_Type is limited record
      Stack_Region : MPU_Region_Descriptor_Type;
      Private_Data_Region : MPU_Region_Descriptor_Type;
      Private_Code_Region : MPU_Region_Descriptor_Type;
      Writable_Background_Region_Enabled : Boolean := False;
   end record with Volatile;

   type Thread_Regions_Access_Type is access all Thread_Regions_Type;

   type Data_Permissions_Type is (None,
                                  Read_Only,
                                  Read_Write);

   -------------------------------------------------------------------
   --  Subprograms to be invoked only from the Ada runtime library  --
   -------------------------------------------------------------------

   procedure Initialize;
   --
   --  Initializes memory protection unit
   --
   --  NOTE: This subprogram is called during Ada startup code, before global
   --  package elaboration is done.
   --

   procedure Restore_Thread_MPU_Regions (
      Thread_Regions : Thread_Regions_Type);
   --
   --  NOTE: This subporgram is tobe invoked only from the Ada runtime's
   --  context switch code and with the background region enabled
   --

   procedure Save_Thread_MPU_Regions (
      Thread_Regions : out Thread_Regions_Type);
   --
   --  NOTE: This subporgram is to be invoked only from the Ada runtime's
   --  context switch code and with the background region enabled
   --

   procedure Set_CPU_Writable_Background_Region (Enabled : Boolean);
   --  with Inline;

   procedure Set_CPU_Writable_Background_Region (Enabled : Boolean;
                                                 Old_Enabled : out Boolean);
   --  with Inline;

   procedure Disable_MPU;

   function Is_MPU_Enabled return Boolean;

   ---------------------------------------------------------
   --  Public interfaces to be invoked from applications  --
   ---------------------------------------------------------

   procedure Enable_MPU (Enable_Precise_Write_Faults : Boolean := False);
   --
   --  Enable MPU to enforce memory protection
   --
   --  NOTE: Set Enable_Precise_Write_Faults may degrade performance.
   --  It should be used only for debugging faults.
   --
   --  This subprogram should be invoked at the beginning of the main program
   --

   procedure Initialize_Private_Data_Region (
         Region : out MPU_Region_Descriptor_Type;
         First_Address : System.Address;
         Last_Address : System.Address;
         Permissions : Data_Permissions_Type)
         with Pre => First_Address /= Null_Address and
                     Last_Address /= Null_Address  and
                     To_Integer (First_Address) < To_Integer (Last_Address) and
                     Permissions /= None;

   procedure Initialize_Private_Data_Region (
      Region : out MPU_Region_Descriptor_Type;
      Start_Address : System.Address;
      Size_In_Bits : Integer_Address;
      Permissions : Data_Permissions_Type)
      with Pre => Start_Address /= Null_Address and
                  Size_In_Bits > 0 and
                  Size_In_Bits mod Byte'Size = 0 and
                  Permissions /= None;

   procedure Initialize_Private_Code_Region (
      Region : out MPU_Region_Descriptor_Type;
      First_Address : System.Address;
      Last_Address : System.Address)
      with Pre => First_Address /= Null_Address and
                  Last_Address /= Null_Address  and
                  To_Integer (First_Address) < To_Integer (Last_Address);

   procedure Restore_Private_Code_Region (
      Saved_Region : MPU_Region_Descriptor_Type);
      --  with Inline;

   procedure Restore_Private_Data_Region (
      Saved_Region : MPU_Region_Descriptor_Type);
      --  with Inline;

   --  Linker script symbol for the start address of the global RAM
   --  text region
   RAM_Text_Start : constant Unsigned_32;
   pragma Import (Asm, RAM_Text_Start, "__ram_text_start");

   --  Linker script symbol for the end address of the global RAM text
   --  region
   RAM_Text_End : constant Unsigned_32;
   pragma Import (Asm, RAM_Text_End, "__ram_text_end");

   --  Linker script symbol for the start address of the sectet flash
   --  text region
   Secret_Flash_Text_Start : constant Unsigned_32;
   pragma Import (Asm, Secret_Flash_Text_Start, "__secret_flash_text_start");

   --  Linker script symbol for the end address of the secret flash text
   --  region
   Secret_Flash_Text_End : constant Unsigned_32;
   pragma Import (Asm, Secret_Flash_Text_End, "__secret_flash_text_end");

   --  Linker script symbol for the start address of the sectet RAM
   --  text region
   Secret_RAM_Text_Start : constant Unsigned_32;
   pragma Import (Asm, Secret_RAM_Text_Start, "__secret_ram_text_start");

   --  Linker script symbol for the end address of the secret RAM text
   --  region
   Secret_RAM_Text_End : constant Unsigned_32;
   pragma Import (Asm, Secret_RAM_Text_End, "__secret_ram_text_end");

   procedure Set_Private_Code_Region (
      First_Address : System.Address;
      Last_Address : System.Address)
      with Pre => To_Integer (First_Address) < To_Integer (Last_Address) and
                  ((To_Integer (First_Address) >=
                      To_Integer (Secret_Flash_Text_Start'Address) and
                    To_Integer (Last_Address) <
                      To_Integer (Secret_Flash_Text_End'Address)) or else
                   (To_Integer (First_Address) >=
                      To_Integer (Secret_RAM_Text_Start'Address)
                    and
                    To_Integer (Last_Address) <
                      To_Integer (Secret_RAM_Text_End'Address)));
      --  with Inline;

   procedure Set_Private_Code_Region (
      First_Address : System.Address;
      Last_Address : System.Address;
      Old_Region : out MPU_Region_Descriptor_Type)
      with Pre => To_Integer (First_Address) < To_Integer (Last_Address) and
                  ((To_Integer (First_Address) >=
                      To_Integer (Secret_Flash_Text_Start'Address) and
                    To_Integer (Last_Address) <
                      To_Integer (Secret_Flash_Text_End'Address)) or else
                   (To_Integer (First_Address) >=
                      To_Integer (Secret_RAM_Text_Start'Address)
                    and
                    To_Integer (Last_Address) <
                      To_Integer (Secret_RAM_Text_End'Address)));
      --  with Inline;

   procedure Set_Private_Code_Region (
      New_Region : MPU_Region_Descriptor_Type;
      Old_Region : out MPU_Region_Descriptor_Type);

   procedure Unset_Private_Code_Region;

   procedure Set_Private_Data_Region (
      Start_Address : System.Address;
      Size_In_Bits : Integer_Address;
      Permissions : Data_Permissions_Type)
      with Pre => Start_Address /= Null_Address and
                  Size_In_Bits > 0 and
                  Size_In_Bits mod Byte'Size = 0 and
                  Permissions /= None;
      --  with Inline;

   procedure Set_Private_Data_Region (
      Start_Address : System.Address;
      Size_In_Bits : Integer_Address;
      Permissions : Data_Permissions_Type;
      Old_Region : out MPU_Region_Descriptor_Type)
      with Pre => Start_Address /= Null_Address and
                  Size_In_Bits > 0 and
                  Size_In_Bits mod Byte'Size = 0 and
                  Permissions /= None;
      --  with Inline;

   procedure Set_Private_Data_Region (
      New_Region : MPU_Region_Descriptor_Type;
      Old_Region : out MPU_Region_Descriptor_Type);

   procedure UnSet_Private_Data_Region;

   type Bus_Master_Type is (Cpu_Core0,
                            Debugger,
                            Dma_Device_DMA_Engine,
                            Dma_Device_ENET,
                            Dma_Device_USB,
                            Dma_Device_SDHC,
                            Dma_Device_Master6,
                            Dma_Device_Master7);

   procedure Set_DMA_Region (Region_Id : MPU_Region_Id_Type;
                             DMA_Master : Bus_Master_Type;
                             Start_Address : System.Address;
                             Size_In_Bits : Integer_Address;
                             Permissions : Data_Permissions_Type)
      with Pre => DMA_Master in Dma_Device_DMA_Engine .. Dma_Device_Master7 and
                  Region_Id >= DMA_Region1 and
                  Start_Address /= Null_Address and
                  Size_In_Bits > 0 and Size_In_Bits mod Byte'Size = 0 and
                  Permissions /= None;

   procedure Unset_DMA_Region (Region_Id : MPU_Region_Id_Type)
      with Pre => Region_Id >= DMA_Region1;

   function Last_Address (First_Address : System.Address;
                          Size_In_Bits : Integer_Address) return System.Address
   is (To_Address (To_Integer (First_Address) +
                   (Size_In_Bits / Interfaces.Bit_Types.Byte'Size) - 1))
   with Inline;

   procedure Dump_MPU_Error_Registers;

   procedure Dump_MPU_Region_Descriptors;

   function Size_Is_MPU_Region_Aligned (Size_In_Bits : Integer_Address)
      return Boolean
   is ((Size_In_Bits / Byte'Size) mod MPU_Region_Alignment = 0);

private

   --
   --  Saved MPU region descriptor
   --
   type MPU_Region_Descriptor_Type is array (0 .. 3) of Unsigned_32
     with Size => 4 * Unsigned_32'Size;

   pragma Compile_Time_Error (MPU_Region_Descriptor_Type'Size /=
                              Kinetis_K64F.MPU.Region_Descriptor_Type'Size,
                              "MPU_Region_Descriptor_TYpe has the wrong size");

end Memory_Protection;
