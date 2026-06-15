--  rate_limiter.ads
--  Version: 0.017
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

package Rate_Limiter with
   SPARK_Mode => On,
   Abstract_State => State
is
   pragma Elaborate_Body;

   --  Rate limiter configuration type
   type Rate_Limiter_Config is private;

   --  Default configuration: allows every operation (0 count interval)
   Default_Config : constant Rate_Limiter_Config;

   --  Create a rate limiter with specified minimum count interval
   --  
   --  @param Min_Interval_Count The minimum count between allowed operations
   --  @return A configured rate limiter
   function Create (Min_Interval_Count : Natural) return Rate_Limiter_Config;

   --  Check if operation is allowed based on rate limit and update state
   --  Uses a counter-based approach for SPARK verification
   --  
   --  @param Limiter The rate limiter to check and update
   --  @param Allowed Set to True if operation is allowed, False if rate limited
   procedure Check (Limiter : Rate_Limiter_Config; Allowed : out Boolean)
     with Global => (In_Out => State);

   --  Reset the rate limiter (call this periodically to allow operations)
   procedure Reset (Limiter : Rate_Limiter_Config)
     with Global => (In_Out => State);

   --  Get the minimum interval for a rate limiter
   --  
   --  @param Limiter The rate limiter to query
   --  @return Minimum interval in counts
   function Get_Min_Interval (Limiter : Rate_Limiter_Config) return Natural;

private

   --  Minimum interval between operations (in counts)
   type Rate_Limiter_Config is record
      Min_Interval_Count : Natural;
   end record;

   --  Default configuration: allows every operation
   Default_Config : constant Rate_Limiter_Config := 
     (Min_Interval_Count => 0);

end Rate_Limiter;
