# Challenges and Learnings

This living document captures design choices, debugging notes and lessons learned.

## Template entry
- **Date:** <YYYY-MM-DD>
- **Module:** <module-name>
- **Issue:** Short description of the problem
- **Root cause:** What caused it
- **Fix / workaround:** Summary of solution
- **Impact / lesson:** What to avoid next time

## Example
- Date: 2025-09-10
- Module: UART RX
- Issue: Bit-sampling drift at high baud
- Root cause: Clock domain and sampling edge mismatch
- Fix: Adjust mid-bit sampling to use phase-aligned clock and add metastability filter
- Lesson: Always verify baud counter with multiple clocks and noisy stimulus
