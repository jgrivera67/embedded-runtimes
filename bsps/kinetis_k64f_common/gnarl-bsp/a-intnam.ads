------------------------------------------------------------------------------
--                                                                          --
--                  GNAT RUN-TIME LIBRARY (GNARL) COMPONENTS                --
--                                                                          --
--                   A D A . I N T E R R U P T S . N A M E S                --
--                                                                          --
--                                  S p e c                                 --
--                                                                          --
--          Copyright (C) 1991-2013, Free Software Foundation, Inc.         --
--                                                                          --
-- GNAT is free software;  you can  redistribute it  and/or modify it under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion.  GNAT is distributed in the hope that it will be useful, but WITH- --
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.                                     --
--                                                                          --
--                                                                          --
--                                                                          --
--                                                                          --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
-- GNARL was developed by the GNARL team at Florida State University.       --
-- Extensive contributions were provided by Ada Core Technologies, Inc.     --
--                                                                          --
------------------------------------------------------------------------------

--  This is the version for Cortex M4F Kinetis K64F targets
with Kinetis_K64F;

package Ada.Interrupts.Names is

   --  All identifiers in this unit are implementation defined

   pragma Implementation_Defined;

   Sys_Tick_Interrupt               : constant Interrupt_ID := -1;

   DMA0_Interrupt                   : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.DMA0_IRQ);

   DMA1_Interrupt                   : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.DMA1_IRQ);

   DMA2_Interrupt                   : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.DMA2_IRQ);

   DMA3_Interrupt                   : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.DMA3_IRQ);

   DMA4_Interrupt                   : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.DMA4_IRQ);

   DMA5_Interrupt                   : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.DMA5_IRQ);

   DMA6_Interrupt                   : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.DMA6_IRQ);

   DMA7_Interrupt                   : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.DMA7_IRQ);

   DMA8_Interrupt                   : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.DMA8_IRQ);

   DMA9_Interrupt                   : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.DMA9_IRQ);

   DMA10_Interrupt                  : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.DMA10_IRQ);

   DMA11_Interrupt                  : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.DMA11_IRQ);

   DMA12_Interrupt                  : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.DMA12_IRQ);

   DMA13_Interrupt                  : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.DMA13_IRQ);

   DMA14_Interrupt                  : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.DMA14_IRQ);

   DMA15_Interrupt                  : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.DMA15_IRQ);

   DMA_Error_Interrupt              : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.DMA_Error_IRQ);

   PORTA_Interrupt                   : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.PORTA_IRQ);

   PORTB_Interrupt                   : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.PORTB_IRQ);

   PORTC_Interrupt                   : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.PORTC_IRQ);

   PORTD_Interrupt                   : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.PORTD_IRQ);

   PORTE_Interrupt                   : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.PORTE_IRQ);

   I2C0_Interrupt                   : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.I2C0_IRQ);

   I2C1_Interrupt                   : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.I2C1_IRQ);

   I2C2_Interrupt                   : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.I2C2_IRQ);

   UART0_Interrupt                   : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.UART0_RX_TX_IRQ);

   UART1_Interrupt                   : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.UART1_RX_TX_IRQ);

   UART2_Interrupt                   : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.UART2_RX_TX_IRQ);

   UART3_Interrupt                   : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.UART3_RX_TX_IRQ);

   UART4_Interrupt                   : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.UART4_RX_TX_IRQ);

   UART5_Interrupt                   : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.UART5_RX_TX_IRQ);

   LLWU_Interrupt                   : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.LLWU_IRQ);

   CAN0_ORed_Message_Buffer_Interrupt : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (
       Kinetis_K64F.CAN0_ORed_Message_Buffer_IRQ);

   CAN0_Bus_Off_Interrupt : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.CAN0_Bus_Off_IRQ);

   CAN0_Error_Interrupt : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.CAN0_Error_IRQ);

   CAN0_Tx_Warning_Interrupt : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (
       Kinetis_K64F.CAN0_Tx_Warning_IRQ);

   CAN0_Rx_Warning_Interrupt : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (
       Kinetis_K64F.CAN0_Rx_Warning_IRQ);

   CAN0_Wake_Up_Interrupt : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.CAN0_Wake_Up_IRQ);

   RTC_Interrupt : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.RTC_IRQ);

   RTC_Seconds_Interrupt : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.RTC_Seconds_IRQ);

   ENET0_Transmit_Interrupt : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.ENET_Transmit_IRQ);

   ENET0_Receive_Interrupt : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.ENET_Receive_IRQ);

   ENET0_Error_Interrupt : constant Interrupt_ID :=
     Kinetis_K64F.External_Interrupt_Type'Pos (Kinetis_K64F.ENET_Error_IRQ);

   --  ...

end Ada.Interrupts.Names;
