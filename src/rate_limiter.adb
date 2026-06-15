--  rate_limiter.adb
--  Version: 0.017
--  
--  Rate Limiter Package Body
--  Implementation of rate limiting functionality
--  
--  SPARK Annotated for Formal Verification
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

package body Rate_Limiter with
   SPARK_Mode => On,
   Refined_State => (State => (Current_Count, Target_Count))
is

   --  State variables to track execution counts
   Current_Count : Natural := 0;
   Target_Count  : Natural := 0;

   --  Create a rate limiter with specified minimum count interval
   function Create (Min_Interval_Count : Natural) return Rate_Limiter_Config is
   begin
      return (Min_Interval_Count => Min_Interval_Count);
   end Create;

   --  Check if operation is allowed based on rate limit and update state
   procedure Check (Limiter : Rate_Limiter_Config; Allowed : out Boolean) is
   begin
      if Current_Count >= Limiter.Min_Interval_Count then
         Current_Count := 0;
         Allowed := True;
      else
         Current_Count := Current_Count + 1;
         Allowed := False;
      end if;
   end Check;

   --  Reset the rate limiter (call this periodically to increment counter)
   procedure Reset (Limiter : Rate_Limiter_Config) is
   begin
      if Current_Count < Limiter.Min_Interval_Count then
         Current_Count := Current_Count + 1;
      end if;
   end Reset;

   --  Get the minimum interval for a rate limiter
   function Get_Min_Interval (Limiter : Rate_Limiter_Config) return Natural is
   begin
      return Limiter.Min_Interval_Count;
   end Get_Min_Interval;

end Rate_Limiter;
