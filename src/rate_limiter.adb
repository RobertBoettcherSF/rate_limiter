--  rate_limiter.adb
--  Version: 0.016
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
   Refined_State => (State => (Last_Execution_Count, Last_Reset_Count))
is

   --  State variables to track execution counts
   Last_Execution_Count : Natural := 0;
   Last_Reset_Count    : Natural := 0;

   --  Create a rate limiter with specified minimum interval
   function Create (Min_Interval_Ms : Natural) return Rate_Limiter_Config is
   begin
      return (Min_Interval_Ms => Min_Interval_Ms);
   end Create;

   --  Check if operation is allowed based on rate limit
   --  Counter-based: allows operation if count >= min_interval
   function Is_Allowed (Limiter : Rate_Limiter_Config) return Boolean is
   begin
      if Last_Execution_Count >= Limiter.Min_Interval_Ms then
         Last_Execution_Count := 0;
         return True;
      else
         Last_Execution_Count := Last_Execution_Count + 1;
         return False;
      end if;
   end Is_Allowed;

   --  Reset the rate limiter (call this periodically)
   procedure Reset (Limiter : Rate_Limiter_Config) is
   begin
      Last_Reset_Count := Last_Reset_Count + 1;
      if Last_Execution_Count < Limiter.Min_Interval_Ms then
         Last_Execution_Count := Last_Execution_Count + 1;
      end if;
   end Reset;

   --  Get the minimum interval for a rate limiter
   function Get_Min_Interval (Limiter : Rate_Limiter_Config) return Natural is
   begin
      return Limiter.Min_Interval_Ms;
   end Get_Min_Interval;

end Rate_Limiter;
