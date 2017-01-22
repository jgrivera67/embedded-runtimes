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

pragma Restrictions (No_Elaboration_Code);

with System; use System;
with System.BB.Parameters;
with Interfaces; use Interfaces;
with Interfaces.Bit_Types; use Interfaces.Bit_Types;

--
--  @summary Parent package for rI/O egister definitions for the Kinetis KL28Z
--  (ARM Cortex M0+) microcontrollers from NXP.
--
package Kinetis_KL28Z is
   pragma Preelaborate;

   type Bytes_Array is array (Positive range <>) of Byte;

   subtype Two_Bits is UInt2;
   subtype Three_Bits is UInt3;
   subtype Four_Bits is UInt4;
   subtype Five_Bits is UInt5;
   subtype Six_Bits is UInt6;
   subtype Half_Word is Unsigned_16;

   type External_Interrupt_Type is
     (DMA0_4_IRQ,
      DMA1_5_IRQ,
      DMA2_6_IRQ,
      DMA3_7_IRQ,
      CTI0_DMA0_Error_IRQ,
      FLEXIO0_IRQ,
      TPM0_IRQ,
      TPM1_IRQ,
      TPM2_IRQ,
      LPIT0_IRQ,
      LPSPI0_IRQ,
      LPSPI1_IRQ,
      LPUART0_IRQ,
      LPUART1_IRQ,
      LPI2C0_IRQ,
      LPI2C1_IRQ,
      Reserved32_IRQ,
      PORTA_IRQ,
      PORTB_IRQ,
      PORTC_IRQ,
      PORTD_IRQ,
      PORTE_IRQ,
      LLWU0_IRQ,
      I2S0_IRQ,
      USB0_IRQ,
      ADC0_IRQ,
      LPTMR0_IRQ,
      RTC_Seconds_IRQ,
      INTMUX0_0_IRQ,
      INTMUX0_1_IRQ,
      INTMUX0_2_IRQ,
      INTMUX0_3_IRQ,
      LPTMR1_IRQ,
      Reserved49_IRQ,
      Reserved50_IRQ,
      Reserved51_IRQ,
      LPSPI2_IRQ,
      LPUART2_IRQ,
      EMVSIM0_IRQ,
      LPI2C2_IRQ,
      TSI0_IRQ,
      PMC_IRQ,
      FTFA_IRQ,
      SCG_IRQ,
      WDOG0_IRQ,
      DAC0_IRQ,
      TRNG_IRQ,
      RCM_IRQHandler,
      CMP0_IRQ,
      CMP1_IRQ,
      RTC_IRQ,
      Reserved67_IRQ,
      Reserved68_IRQ,
      Reserved69_IRQ,
      Reserved70_IRQ,
      Reserved71_IRQ,
      Reserved72_IRQ,
      Reserved73_IRQ,
      Reserved74_IRQ,
      Reserved75_IRQ,
      Reserved76_IRQ,
      Reserved77_IRQ,
      Reserved78_IRQ,
      Reserved79_IRQ);

   pragma Compile_Time_Error
     (External_Interrupt_Type'Pos (DMA0_4_IRQ) /= 0,
      "First IRQ number must be 0");
   pragma Compile_Time_Error
     (External_Interrupt_Type'Pos (Reserved79_IRQ) /=
      System.BB.Parameters.Number_Of_Interrupt_ID,
      "Last IRQ number is wrong");

end Kinetis_KL28Z;
