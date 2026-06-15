--  rate_limiter.ads
--  Version: 0.005
--  
--  Rate Limiter Package Specification
--  Throttles operations (e.g., for sensor sampling)
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

package Rate_Limiter with
   SPARK_Mode => On,
   Abstract_State => State
is
   pragma Elaborate_Body;

   --  Rate limiter configuration type
   type Rate_Limiter_Config is private;

   --  Default configuration: 100 Hz rate limit (10 ms interval)
   Default_Config : constant Rate_Limiter_Config;

   --  Create a rate limiter with specified minimum interval
   --  
   --  @param Min_Interval The minimum time between allowed operations (in milliseconds)
   --  @return A configured rate limiter
   function Create (Min_Interval_Ms : Natural) return Rate_Limiter_Config;

   --  Check if operation is allowed based on rate limit
   --  
   --  @param Limiter The rate limiter to check
   --  @return True if operation is allowed, False if rate limited
   function Is_Allowed (Limiter : Rate_Limiter_Config) return Boolean
     with Global => (Input  => Ada.Real_Time.Clock,
                     In_Out => State),
          Depends => (Is_Allowed => (Limiter, State, Ada.Real_Time.Clock));

   --  Get the minimum interval for a rate limiter
   --  
   --  @param Limiter The rate limiter to query
   --  @return Minimum interval in milliseconds
   function Get_Min_Interval (Limiter : Rate_Limiter_Config) return Natural;

private

   --  Minimum interval between operations (in milliseconds)
   type Rate_Limiter_Config is record
      Min_Interval_Ms : Natural;
   end record;

   --  Default configuration: 100 Hz (10 ms interval)
   Default_Config : constant Rate_Limiter_Config := 
     (Min_Interval_Ms => 10);

end Rate_Limiter;
