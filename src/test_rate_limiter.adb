--  test_rate_limiter.adb
--  Version: 0.017
--  
--  Test program for Rate Limiter
--  Demonstrates usage of the rate limiting functionality
--  
--  Copyright (C) 2024 RobertBoettcherSF
--  
--  This program is free software: you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation, either version 3 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.

with Ada.Text_IO; use Ada.Text_IO;
with Rate_Limiter; use Rate_Limiter;

procedure Test_Rate_Limiter is

   --  Create a rate limiter that allows 1 operation per 10 calls
   Sensor_Limiter : Rate_Limiter_Config := Create (10);

   --  Create a rate limiter that allows 1 operation per 100 calls
   Slow_Limiter : Rate_Limiter_Config := Create (100);

   --  Test counter
   Count : Natural := 0;

   --  Variables to receive allowed status
   Allowed : Boolean;

begin
   Put_Line ("Rate Limiter Test");
   Put_Line ("=================");
   New_Line;

   --  Test fast rate limiter (1 per 10 calls)
   Put_Line ("Testing rate limiter (1 per 10 calls):");
   for I in 1 .. 20 loop
      Check (Sensor_Limiter, Allowed);
      if Allowed then
         Count := Count + 1;
         Put_Line ("  Operation &" & Count'Image & " allowed");
      else
         Put_Line ("  Operation rate limited");
      end if;
      Reset (Sensor_Limiter);
   end loop;

   New_Line;
   Count := 0;

   --  Test slow rate limiter (1 per 100 calls)
   Put_Line ("Testing rate limiter (1 per 100 calls):");
   for I in 1 .. 20 loop
      Check (Slow_Limiter, Allowed);
      if Allowed then
         Count := Count + 1;
         Put_Line ("  Operation &" & Count'Image & " allowed");
      else
         Put_Line ("  Operation rate limited");
      end if;
      Reset (Slow_Limiter);
   end loop;

   New_Line;
   Put_Line ("Test completed.");

end Test_Rate_Limiter;
