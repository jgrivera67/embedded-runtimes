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

--
--  @summary Memory Protection Services
--
package Memory_Protection is
   pragma Preelaborate;

   use System.Storage_Elements;
   use System;
   use Interfaces.Bit_Types;

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
      Global_Background_Region_Before_Secret_Area,
      Global_Background_Region_After_Secret_Area,
      Task_Private_Stack_Data_Region,
      Task_Private_Writable_Data_Region,

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
                               Global_Background_Region_Before_Secret_Area
                                  => 5,
                               Global_Background_Region_After_Secret_Area
                                  => 6,
                               Task_Private_Stack_Data_Region => 7,
                               Task_Private_Writable_Data_Region => 8,
                               DMA_Region1 => 9,
                               DMA_Region2 => 10,
                               DMA_Region3 => 11);

   --
   --  Address range and permissions for a given writable region
   --
   type Writable_Region_Type is record
      First_Address : System.Address;
      Last_Address : System.Address;
      Enabled : Boolean := False;
   end record;

   --
   --  Task-specific MPU regions
   --
   --  @field Stack_Region MPU region for the task's stack
   --  @field Writable_Data_Region MPU region for current writable data
   --  region for the task. It is typically corresponds to the no more than the
   --  the non-stack variables of the current component being invoked by the
   --  task.
   --
   type Task_Regions_Type is limited record
      Stack_Region : Writable_Region_Type;
      Writable_Data_Region : Writable_Region_Type;
      Writable_Background_Region_Enabled : Boolean := False;
   end record;

   type Task_Regions_Access_Type is access all Task_Regions_Type;

   procedure Initialize;
   --
   --  Initializes memory protection unit
   --
   --  NOTE: This subprogram is called during Ada startup code, before global
   --  package elaboration is done.
   --

   function Is_Valid_Writable_Region (Region : Writable_Region_Type)
      return Boolean;

   --
   --  Subprograms to be invoked only from the Ada runtime library
   --

   procedure Restore_Thread_MPU_Regions (Thread_Regions : Task_Regions_Type);
   --
   --  NOTE: This subporgram is tobe invoked only from the Ada runtime's
   --  context switch code and with the background region enabled
   --

   procedure Save_Thread_MPU_Regions (Thread_Regions : out Task_Regions_Type);
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

   --
   --  Public interfaces to be invoked from applications
   --

   procedure Enable_MPU;
   --
   --  This subprogram should be invoked at the beginning of the main program
   --

   procedure Set_CPU_Writable_Data_Region (
      New_Region : Writable_Region_Type)
      with Pre => Is_Valid_Writable_Region (New_Region);
      --  with Inline;

   procedure Set_CPU_Writable_Data_Region (
      New_Region : Writable_Region_Type;
      Old_Region : out Writable_Region_Type)
      with Pre => Is_Valid_Writable_Region (New_Region),
           Post => Is_Valid_Writable_Region (Old_Region);
      --  with Inline;

   procedure Set_CPU_Writable_Data_Region (
      Start_Address : System.Address;
      Size_In_Bits : Integer_Address)
      with Pre => Start_Address /= Null_Address and
                  Size_In_Bits > 0 and
                  Size_In_Bits mod Byte'Size = 0;
      --  with Inline;

   procedure Set_CPU_Writable_Data_Region (
      Start_Address : System.Address;
      Size_In_Bits : Integer_Address;
      Old_Region : out Writable_Region_Type)
      with Pre => Start_Address /= Null_Address and
                  Size_In_Bits > 0 and
                  Size_In_Bits mod Byte'Size = 0,
           Post => Is_Valid_Writable_Region (Old_Region);
      --  with Inline;

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
                             Read_Only : Boolean := False)
      with Pre => DMA_Master in Dma_Device_DMA_Engine .. Dma_Device_Master7
                  and
                  Region_Id >= DMA_Region1
                  and
                  Start_Address /= Null_Address and
                  Size_In_Bits > 0 and Size_In_Bits mod Byte'Size = 0;

   procedure Unset_DMA_Region (Region_Id : MPU_Region_Id_Type)
      with Pre => Region_Id >= DMA_Region1;

   function Last_Address (First_Address : System.Address;
                          Size_In_Bits : Integer_Address) return System.Address
   is (To_Address (To_Integer (First_Address) +
                   (Size_In_Bits / Interfaces.Bit_Types.Byte'Size) - 1))
   with Inline;

   procedure Dump_MPU_Error_Registers;

   procedure Dump_MPU_Region_Descriptors;

private

   function Is_Valid_Writable_Region (Region : Writable_Region_Type)
      return Boolean is
   (Region.Enabled
    and
    To_Integer (Region.First_Address) <
                   To_Integer (Region.Last_Address)
    and
    To_Integer (Region.First_Address) mod MPU_Region_Alignment = 0
    and
    (To_Integer (Region.Last_Address) + 1) mod MPU_Region_Alignment = 0);

end Memory_Protection;
