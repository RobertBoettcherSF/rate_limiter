# Rate Limiter - SPARK Verified

A rate limiter package for Ada SPARK that throttles operations (e.g., for sensor sampling).

## Version

Current version: **0.017**

## Features

- **Fully SPARK-verified** - All proofs pass at level 4 with `gnatprove`
- **Counter-based** - Deterministic rate limiting without external dependencies
- **No floating-point** - Uses only integer arithmetic for SPARK compatibility
- **Simple API** - Easy to integrate into SPARK-verified systems
- **No volatile functions** - Avoids `Ada.Real_Time.Clock` which cannot be used in SPARK mode

## Design Philosophy

This implementation uses a **counter-based approach** rather than time-based rate limiting. This design choice was made because:

1. **SPARK Compatibility**: `Ada.Real_Time.Clock` is a volatile function that cannot be called from SPARK code (SPARK RM 6.1.4(15))
2. **Determinism**: Counter-based rate limiting is fully deterministic and verifiable
3. **Portability**: Works on any platform without hardware clock dependencies

For time-based rate limiting in non-SPARK contexts, consider using `Ada.Real_Time` directly.

## API Reference

### Types

```ada
-- Configuration type for rate limiters
type Rate_Limiter_Config is private;

-- Default: allows every operation (0 count interval)
Default_Config : constant Rate_Limiter_Config;
```

### Functions

```ada
-- Create a rate limiter
-- Min_Interval_Count: Number of Reset calls between allowed operations
function Create (Min_Interval_Count : Natural) return Rate_Limiter_Config;

-- Get the configured minimum interval (in counts)
function Get_Min_Interval (Limiter : Rate_Limiter_Config) return Natural;
```

### Procedures

```ada
-- Check if operation is allowed and update internal counter
-- Limiter: The rate limiter configuration
-- Allowed: Set to True if operation is allowed, False if rate limited
procedure Check (Limiter : Rate_Limiter_Config; Allowed : out Boolean);

-- Reset the rate limiter (call this periodically to simulate time passing)
-- This increments the internal counter, allowing operations after Min_Interval_Count calls
procedure Reset (Limiter : Rate_Limiter_Config);
```

## Usage Example

```ada
with Rate_Limiter; use Rate_Limiter;

procedure Sensor_Sampling is
   -- Create a rate limiter that allows 1 operation per 10 Reset calls
   Limiter : Rate_Limiter_Config := Create (10);
   
   Allowed : Boolean;
begin
   loop
      -- Check if we can sample
      Check (Limiter, Allowed);
      
      if Allowed then
         -- Perform sensor sampling
         Sample_Sensor;
      end if;
      
      -- Reset the rate limiter (call this at your system's tick rate)
      Reset (Limiter);
      
      -- Other work...
   end loop;
end Sensor_Sampling;
```

## How It Works

The rate limiter maintains an internal counter that increments on each call to `Reset`. When you call `Check`:

1. If the counter >= `Min_Interval_Count`, the operation is **allowed** and the counter resets to 0
2. Otherwise, the operation is **rate limited** and the counter increments

To use this for time-based rate limiting:
- Call `Reset` at a fixed interval (e.g., every millisecond from a timer interrupt)
- Set `Min_Interval_Count` to the number of ticks between allowed operations

### Example: 100 Hz Rate Limiting

With 1ms ticks:
- Call `Reset` every 1ms (from timer interrupt)
- Use `Create (10)` to allow 1 operation every 10 ticks (10ms = 100 Hz)

### Example: 10 Hz Rate Limiting

With 1ms ticks:
- Call `Reset` every 1ms
- Use `Create (100)` to allow 1 operation every 100 ticks (100ms = 10 Hz)

## Verification

```bash
# Clone the repository
git clone https://github.com/RobertBoettcherSF/rate_limiter.git
cd rate_limiter

# Verify with gnatprove (requires GNAT Community Edition or GNAT Pro)
gnatprove -P rate_limiter.gpr --level=4

# All three phases should pass:
# Phase 1: generation of data representation information
# Phase 2: generation of Global contracts  
# Phase 3: flow analysis and proof
```

## Project Structure

```
rate_limiter/
├── rate_limiter.gpr      # GNAT project file
├── README.md             # This file
└── src/
    ├── rate_limiter.ads  # Package specification (Version 0.017)
    ├── rate_limiter.adb  # Package body (Version 0.017)
    └── test_rate_limiter.adb  # Test program
```

## Files

| File | Version | Description |
|------|---------|-------------|
| `rate_limiter.ads` | 0.017 | Package specification with SPARK annotations |
| `rate_limiter.adb` | 0.017 | Package body with counter-based logic |
| `rate_limiter.gpr` | 0.004 | GNAT project file |
| `test_rate_limiter.adb` | 0.017 | Demonstration test program |

## Building and Testing

```bash
# Build the project
gprbuild -P rate_limiter.gpr

# Run the test program
./bin/test_rate_limiter

# Verify with SPARK
gnatprove -P rate_limiter.gpr --level=4
```

## License

GNU General Public License v3.0 - see [LICENSE](LICENSE) for details.

## Version History

- **0.017**: Counter-based approach with Check/Reset API, fully SPARK-verified
- **0.016**: Initial counter-based implementation
- **0.001-0.015**: Time-based attempts (abandoned due to Clock volatility in SPARK)

## Contributing

Pull requests are welcome. Please ensure:
1. All SPARK proofs pass (`gnatprove -P rate_limiter.gpr --level=4`)
2. Version numbers are incremented in file headers
3. README is updated for API changes
