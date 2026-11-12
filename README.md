# Linux MSR-Based CPU Thermal Control

A small Linux system-level experiment exploring CPU temperature monitoring, Bash automation, and Intel Model-Specific Register (MSR) manipulation.

Originally developed on an **Intel Pentium N3540** laptop, the project was created to investigate persistent CPU frequency throttling associated with BD PROCHOT.

## Background

The original experiment started as a Python script and was later rewritten in Bash to keep the monitoring loop lightweight.

It combined Linux thermal-zone readings with MSR operations through [`msr-tools`](https://github.com/intel/msr-tools).

The monitoring logic used two temperature thresholds:

| Temperature | Intended action |
|---|---|
| ≥ 82°C | Enable the lock state |
| ≤ 75°C | Disable the lock state |
| 75–82°C | Preserve the current state |

The two thresholds provide hysteresis, preventing repeated state changes around a single temperature boundary.

## Technical implementation

- **Language:** Bash (originally prototyped in Python)
- **Operating system:** Linux
- **Temperature interface:** `/sys/class/thermal/thermal_zone0/temp`
- **Hardware register interface:** Linux MSR kernel module
- **Utilities:** `msr-tools` (`rdmsr`, `wrmsr`)
- **Polling interval:** 2 seconds
- **Target hardware:** Intel Pentium N3540

The original experiment used MSR `0x1FC` and the values `1` and `2`, following a community workaround for BD PROCHOT-related throttling.

The recovered implementation explores reading the current register value with `rdmsr` and modifying the relevant bit while preserving the other bits.

## Repository status

The original source code was not recovered. This repository contains a reconstruction based on remembered implementation details, terminal screenshots, and the original technical references.

The reconstructed implementation should therefore not be treated as a byte-for-byte copy of the original project.

## Safety notice

**Experimental code — not intended for production use.**

MSR meanings and supported bits depend on the processor model and generation. The BD PROCHOT workaround discussed in the original experiment was documented for other Intel processors; its behaviour on the Pentium N3540 has not been independently verified.

Changing CPU power-management registers can affect thermal and power-management behaviour. Disabling external PROCHOT responses may suppress legitimate thermal warnings from other system components.

Do not execute hardware register writes without first verifying the processor-specific documentation and understanding the consequences. Preserve the original register values and maintain independent thermal safeguards.

## References

- [Ask Ubuntu: Disable BD PROCHOT permanently or quickly](https://askubuntu.com/questions/1148941/disable-bd-prochot-permanently-or-quickly-lubuntu-18-04-2)
- [Intel MSR Tools](https://github.com/intel/msr-tools)

## Learning outcomes

This experiment provided practical exposure to:

- Linux sysfs interfaces and hardware monitoring.
- Bash scripting and periodic system monitoring.
- Linux kernel module loading.
- CPU Model-Specific Registers.
- Privileged hardware access from Linux userspace.
- Hysteresis-based control logic.
