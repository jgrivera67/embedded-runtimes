--
--  Copyright (c) 2017, German Rivera
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

with Interfaces.Bit_Types;
with System;

--
--  @summary ARMv7-M MPU registers
--
package ARMv7M_MPU is
   pragma No_Elaboration_Code_All;
   pragma Preelaborate;

   use System;
   use Interfaces.Bit_Types;
   use Interfaces;

      --  MPU type register
   type MPU_TYPE_Register_Type is record
      --  Separate regions for data and instructions (not supported in ARMv7-M)
      SEPARATE_Flag : Bit := 0; --  RAZ

      --  Number of regions supported by the MPU. If RAZ, the MPU is not
      --  supported.
      DREGION_Num : Byte;

      --  Number separate regions for instructions (not supported by ARMv7-M)
      IREGION_Num : Byte := 0; --  RAZ
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for MPU_TYPE_Register_Type use record
      SEPARATE_Flag at 0 range 0 .. 0;
      DREGION_Num   at 0 range 8 .. 15;
      IREGION_Num   at 0 range 16 .. 23;
   end record;

   --  MPU control register
   type MPU_CTRL_Register_Type is record
      --  When set, the MPU is enabled.
      ENABLE : Bit := 0;

      --  When set along with the ENABLE bit, the MPU is enabled for
      --  HardFault, NMI, and exception handlers with FAULTMASK
      HFNMIENA : Bit := 0;

      --  When the bit is set along with the ENABLE bit, the Default
      --  memory map is enabled as a background region for privileged
      --  access. The background region acts as though it were region
      --  number -1. MPU configured regions will override (take
      --  priority over) the default memory map. When the bit is clear, the
      --  default map is disabled. Instruction or data accesses not covered by
      --  a region will fault.
      PRIVDEFENA :  Bit := 0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for MPU_CTRL_Register_Type use record
      ENABLE  at 0 range 0 .. 0;
      HFNMIENA at 0 range 1 .. 1;
      PRIVDEFENA at 0 range 2 .. 2;
   end record;

   --  MPU Region Number Register
   type MPU_RNR_Register_Type is record
      --  Region selector index
      REGION : Byte := 0;
      Reserved : UInt24 := 0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for MPU_RNR_Register_Type use record
      REGION   at 0 range 0 .. 7;
      Reserved at 0 range 8 .. 31;
   end record;

   --  MPU Region Base Address Register
   type MPU_RBAR_Register_Type is record
      --  Region selector index.
      REGION : UInt4 := 0;

      --  is zero extended and copied into the MPU_RNR.
      VALID : Bit := 0;

      --  Most significant 27 bits of the region's base address. The least
      --  significant bits of the address are always 0, as the minimum
      --  alignment is 32 bytes.
      ADDR : UInt27;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for MPU_RBAR_Register_Type use record
      REGION  at 0 range 0 .. 3;
      VALID   at 0 range 4 .. 4;
      ADDR    at 0 range 5 .. 31;
   end record;

   --  Privileged and unprivileged read/write permissions
   type Read_Write_Permissions_Type is
     (No_Access,
      Privileged_Read_Write_Unprivileged_No_Access,
      Privileged_Read_Write_Unprivileged_Read_Only,
      Privileged_Read_Write_Unprivileged_Read_Write,
      Reserved,
      Privileged_Read_Only_Unprivileged_No_Access,
      Privileged_Read_Only_Unprivileged_Read_Only) with Size => 3;

   for Read_Write_Permissions_Type use
     (No_Access => 2#000#,
      Privileged_Read_Write_Unprivileged_No_Access => 2#001#,
      Privileged_Read_Write_Unprivileged_Read_Only => 2#010#,
      Privileged_Read_Write_Unprivileged_Read_Write => 2#011#,
      Reserved => 2#100#,
      Privileged_Read_Only_Unprivileged_No_Access => 2#101#,
      Privileged_Read_Only_Unprivileged_Read_Only => 2#110#);

   type Region_Attributes_Type is record
      B : Bit := 0;
      C : Bit := 0;
      S : Bit := 0;
      TEX : UInt3 := 0;
      AP : Read_Write_Permissions_Type := No_Access;
      XN : Bit := 0; --  eXecute Never (no instruction fetches allowed)
   end record
     with Size => 16,
          Bit_Order => System.Low_Order_First;

   for Region_Attributes_Type use record
      B  at 0 range 0 .. 0;
      C  at 0 range 1 .. 1;
      S  at 0 range 2 .. 2;
      TEX at 0 range 3 .. 5;
      AP  at 0 range 8 .. 10;
      XN  at 0 range 12 .. 12;
   end record;

   type  Encoded_Region_Size_Type is range 4 .. 31 with Size => 5;

   type Subregion_Index_Type is range 0 .. 7;

   type Subregions_Disabled_Mask_Type is array (Subregion_Index_Type) of Bit
      with Component_Size => 1, Size => Byte'Size;

   --  MPU Region Attribute and Size Register
   type MPU_RASR_Register_Type is record
      --  When set, the associated region is enabled within the MPU. The
      --  global MPU enable bit must also be set for it to take effect.
      ENABLE : Bit := 0;

      --  Region size encoded as a power of 2 (log base 2 of size) - 1
      SIZE : Encoded_Region_Size_Type := Encoded_Region_Size_Type'First;

      --  Subregion disabled bits
      SRD : Subregions_Disabled_Mask_Type := (others => 0);

      ATTRS : Region_Attributes_Type;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for MPU_RASR_Register_Type use record
      ENABLE  at 0 range 0 .. 0;
      SIZE    at 0 range 1 .. 5;
      SRD     at 0 range 8 .. 15;
      ATTRS   at 0 range 16 .. 31;
   end record;

   type MPU_Alias_Descriptor_Type is record
      MPU_RBAR : MPU_RBAR_Register_Type;
      MPU_RASR : MPU_RASR_Register_Type;
   end record;

   type MPU_Alias_Descriptor_Array_Type is
      array (1 .. 3) of MPU_Alias_Descriptor_Type;

   --
   --  Standard ARMv7-M MPU registers
   --
   type MPU_Registers_Type is record
      MPU_TYPE : MPU_TYPE_Register_Type;
      MPU_CTRL : MPU_CTRL_Register_Type;
      MPU_RNR : MPU_RNR_Register_Type;
      MPU_RBAR : MPU_RBAR_Register_Type;
      MPU_RASR : MPU_RASR_Register_Type;
      MPU_Alias_Descriptors : MPU_Alias_Descriptor_Array_Type;
   end record
     with Volatile;

   MPU_Registers : aliased MPU_Registers_Type
     with Import, Address => System'To_Address (16#E000ED90#);

end ARMv7M_MPU;
