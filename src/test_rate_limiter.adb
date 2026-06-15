--  test_rate_limiter.adb
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
with Ada.Real_Time; use Ada.Real_Time;
with Rate_Limiter; use Rate_Limiter;

procedure Test_Rate_Limiter is

   --  Create a rate limiter for 100 Hz (10 ms interval)
   Sensor_Limiter : Rate_Limiter_Config := Create (10);

   --  Create a rate limiter for 10 Hz (100 ms interval)
   Slow_Limiter : Rate_Limiter_Config := Create (100);

   --  Test counter
   Count : Natural := 0;

begin
   Put_Line ("Rate Limiter Test");
   Put_Line ("=================");
   New_Line;

   --  Test fast rate limiter (100 Hz)
   Put_Line ("Testing 100 Hz rate limiter (10 ms interval):");
   for I in 1 .. 20 loop
      if Is_Allowed (Sensor_Limiter) then
         Count := Count + 1;
         Put_Line ("  Operation &" & Count'Image & " allowed");
      else
         Put_Line ("  Operation rate limited");
      end if;
      delay 0.005; -- 5 ms delay between checks
   end loop;

   New_Line;
   Count := 0;

   --  Test slow rate limiter (10 Hz)
   Put_Line ("Testing 10 Hz rate limiter (100 ms interval):");
   for I in 1 .. 20 loop
      if Is_Allowed (Slow_Limiter) then
         Count := Count + 1;
         Put_Line ("  Operation &" & Count'Image & " allowed");
      else
         Put_Line ("  Operation rate limited");
      end if;
      delay 0.05; -- 50 ms delay between checks
   end loop;

   New_Line;
   Put_Line ("Test completed.");

end Test_Rate_Limiter;
