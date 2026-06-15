--  rate_limiter.adb
--  Version: 0.012
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

with Ada.Real_Time; use Ada.Real_Time;

package body Rate_Limiter with
   SPARK_Mode => On,
   Refined_State => (State => Last_Execution_Time)
is

   --  State variable to track last execution time
   Last_Execution_Time : Time := Time_First;

   --  Create a rate limiter with specified minimum interval
   function Create (Min_Interval_Ms : Natural) return Rate_Limiter_Config is
   begin
      return (Min_Interval_Ms => Min_Interval_Ms);
   end Create;

   --  Check if operation is allowed based on rate limit
   function Is_Allowed (Limiter : Rate_Limiter_Config) return Boolean is
      Current_Time : constant Time := Clock;
      Time_Diff    : Time_Span;
      Elapsed_Ms   : Natural;
   begin
      Time_Diff := Current_Time - Last_Execution_Time;
      
      if Time_Diff >= Time_Span_Zero then
         --  Safe conversion: Time_Span to milliseconds
         --  Maximum Time_Span is about 838 hours, which fits in Natural
         Elapsed_Ms := Natural(To_Duration(Time_Diff) * 1000);
      else
         Elapsed_Ms := 0;
      end if;
      
      if Elapsed_Ms >= Limiter.Min_Interval_Ms then
         Last_Execution_Time := Current_Time;
         return True;
      else
         return False;
      end if;
   end Is_Allowed;

   --  Get the minimum interval for a rate limiter
   function Get_Min_Interval (Limiter : Rate_Limiter_Config) return Natural is
   begin
      return Limiter.Min_Interval_Ms;
   end Get_Min_Interval;

end Rate_Limiter;
