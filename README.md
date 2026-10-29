# MOD10_counter_RTL_to_GDSII_yosys_openROAD
# Mod-10 Counter RTL-to-GDSII Physical Design

A 4-bit Mod-10 counter implemented using Verilog and taken through synthesis, static timing analysis (STA), floorplanning, power distribution network (PDN) generation, placement, clock tree synthesis (CTS), routing, and physical verification using open-source EDA tools.

The project explores the RTL-to-GDSII physical design flow at the individual-command level, with recorded area, timing, placement, routing, and verification metrics.

## Table of Contents

- [1. Project Overview](#1-project-overview)
- [2. Tools and Technology](#2-tools-and-technology)
- [3. Design Specifications](#3-design-specifications)
- [4. Synthesis](#4-synthesis)
- [5. Post-Synthesis STA](#5-post-synthesis-sta)
- [6. Floorplanning](#6-floorplanning)
- [7. I/O Pin Placement](#7-io-pin-placement)
- [8. Tap-Cell Insertion](#8-tap-cell-insertion)
- [9. Power Distribution Network](#9-power-distribution-network)
- [10. Global Placement](#10-global-placement)
- [11. Detailed Placement](#11-detailed-placement)
- [12. Clock Tree Synthesis](#12-clock-tree-synthesis)
- [13. Post-CTS STA](#13-post-cts-sta)
- [14. Global and Detailed Routing](#14-global-and-detailed-routing)
- [15. Post-Route STA](#15-post-route-sta)
- [16. Physical Verification](#16-physical-verification)
- [17. Separate ORFS Automated-Flow Results](#17-separate-orfs-automated-flow-results)
- [18. Final Project Status](#18-final-project-status)
- [19. Known Issues and Future Work](#19-known-issues-and-future-work)

## 1. Project Overview

The design is a synchronous 4-bit modulo-10 counter. It counts from 0 to 9 and returns to 0 on the next counting cycle.

The design was implemented using Verilog RTL and processed through a manual, step-by-step physical design flow using Yosys, OpenSTA, and OpenROAD-based tools.

The manual flow provides visibility into the intermediate databases, timing reports, placement results, clock-tree construction, routing parasitics, and physical verification stages.

### Design characteristics

- **Design:** Mod-10 counter
- **RTL language:** Verilog
- **Counter width:** 4 bits
- **Counter range:** 0–9
- **Target clock frequency:** 100 MHz
- **Target clock period:** 10 ns
- **Technology:** SkyWater SKY130 HD
- **Nominal supply voltage:** 1.8 V
- **Implementation target:** GDSII

### Project directory

```text
/opt/asic-learning/countermod10
```

## 2. Tools and Technology

| Tool or technology | Purpose |
|---|---|
| Verilog | RTL description |
| Yosys | RTL synthesis and standard-cell mapping |
| OpenSTA 3.1.0 | Static timing analysis |
| OpenROAD | Physical implementation and optimization |
| SkyWater SKY130 HD | Standard-cell technology |
| Liberty (.lib) | Cell timing and area models |
| LEF | Standard-cell and physical technology abstracts |
| DEF | Floorplan, placement, and routing representation |
| ODB | OpenROAD physical design database |
| SPEF | Extracted parasitic information for timing analysis |
| GDSII | Final physical layout representation |
| KLayout | Layout inspection and DRC/LVS-related workflows |

The manual physical implementation flow and the separate OpenROAD Flow Scripts (ORFS) automated run are documented independently because their metrics come from different implementation runs and reporting stages.

## 3. Design Specifications

| Metric | Value |
|---|---:|
| Counter width | 4 bits |
| Modulus | 10 |
| Valid count sequence | 0–9 |
| Clock period constraint | 10 ns |
| Equivalent clock frequency | 100 MHz |
| Nominal supply voltage | 1.8 V |
| Standard-cell library | SkyWater SKY130 HD |
| Signal pins assigned during I/O placement | 6 |
| Top-level terminals including VDD and VSS | 8 |

The target clock frequency is calculated as:

\[
f_{\text{clk}}=\frac{1}{T_{\text{clk}}}
=\frac{1}{10\,\text{ns}}=100\,\text{MHz}
\]

## 4. Synthesis

Synthesis converts the RTL into a network of standard cells using the target technology library.

### Synthesis metrics

| Metric | Value |
|---|---:|
| Counter width | 4 bits |
| Counter modulus | 10 |
| Clock period target | 10 ns |
| Target clock frequency | 100 MHz |
| Reported standard-cell area | 173.9168 µm² |
| Sequential-cell area | 100.096 µm² |
| Sequential area percentage | 57.55% |
| Mapped asynchronous-reset flip-flops | 4 |
| Reported Yosys cell count | 17 |
| Standard-cell library | SkyWater SKY130 HD |
| Synthesis mapping | Liberty-based standard-cell mapping |

### Mapped sequential cells

The reported sequential cells were four instances of:

```text
sky130_fd_sc_hd__dfrtp_1
```

### Synthesis check

Yosys `check` reported an undriven-net warning involving:

```text
mod10_counter.count[3:0]
```

Although the generated netlist showed connections from the flip-flop outputs to the counter output bits, the warning was not conclusively resolved during the recorded checks.

This discrepancy remains a known issue and should be investigated before claiming that the synthesis checks are completely clean.

**Area note:** The area value is reported from the synthesis flow. Standard-cell area is distinct from the floorplan core area and die area.

## 5. Post-Synthesis STA

Post-synthesis STA evaluates timing using the synthesized netlist, timing constraints, and Liberty timing models, before the final physical routing parasitics are available.

### Maximum-delay analysis

| Metric | Value |
|---|---:|
| Clock period | 10.00 ns |
| Equivalent clock frequency | 100 MHz |
| Worst reported maximum-delay slack | +8.61 ns |
| Total negative slack (TNS) | 0.00 ns |
| Worst displayed register-to-register maximum-delay slack | +9.07 ns |
| Worst displayed reset-recovery path slack | +9.19 ns |
| Worst reported flip-flop-to-output path | `count[0]` |
| Flip-flop-to-output slack for `count[0]` | +8.61 ns |
| Flip-flop-to-output slack for `count[3]` | +8.65 ns |

### Minimum-delay analysis

| Metric | Value |
|---|---:|
| Worst reported minimum-delay slack | +0.48 ns |
| Other displayed register-to-register minimum-delay slacks | +0.49, +0.52, +0.56 ns |
| Reset-removal path slack | +0.72 ns |
| Minimum-delay output path slack to `count[3]` | +1.32 ns |

The reported setup-related and hold-related slacks were positive at this stage.

These are pre-placement timing results and must not be substituted for post-CTS or post-route timing metrics.

## 6. Floorplanning

Floorplanning establishes the die boundary, core boundary, and available physical implementation area.

### Floorplan metrics

| Metric | Value |
|---|---:|
| Requested die width | 44 µm |
| Requested die height | 44 µm |
| Die area | 1,936 µm² |
| Core lower-left coordinate | (2.300, 2.720) µm |
| Core upper-right coordinate | (41.860, 40.800) µm |
| Actual core width | 39.56 µm |
| Actual core height | 38.08 µm |
| Core area | 1,506.445 µm² |
| Synthesized logic-cell area | 173.9168 µm² |
| Approximate initial core utilization | 11.5% |

Die area:

\[
A_{\text{die}}=44\times44=1936\,\mu\text{m}^2
\]

Core area:

\[
A_{\text{core}}=39.56\times38.08
\approx1506.445\,\mu\text{m}^2
\]

Approximate initial utilization:

\[
U=\frac{173.9168}{1506.445}\times100
\approx11.5\%
\]

The initial utilization is low because the core is substantially larger than the synthesized logic area. This leaves room for physical implementation cells, clock-tree cells, routing, and power distribution structures.

## 7. I/O Pin Placement

I/O pin placement assigns physical locations to the design's external signal pins.

| Metric | Value |
|---|---:|
| Signal pins assigned | 6 |
| Reported half-perimeter wirelength (HPWL) | 144.24 µm |
| Pin placement layers | MET2, MET3 |
| Top-level terminals including power and ground | 8 |

HPWL is an estimate derived from net and pin bounding boxes. It is not the final routed wirelength.

The six pins refer to the signal-pin placement stage. The completed DEF contains eight top-level terminals when VDD and VSS are included.

## 8. Tap-Cell Insertion

Tap cells provide substrate and well connections required by the standard-cell technology.

| Metric | Value |
|---|---|
| Tap-cell master | `sky130_fd_sc_hd__tapvpwrvgnd_1` |
| Tap-cell spacing parameter | 14 µm |
| Tap cells inserted | 16 |

Tap-cell insertion was completed before the subsequent physical implementation stages.

## 9. Power Distribution Network

The power distribution network distributes supply and ground across the physical design.

### PDN configuration

| Metric | Value |
|---|---|
| Power net | VDD |
| Ground net | VSS |
| Nominal supply voltage | 1.8 V |
| Follow-pin rail layer | MET1 |
| Power strap layers | MET4, MET5 |
| MET1–MET4 connections | Configured |
| MET4–MET5 connections | Configured |
| PDN DEF | `physical/results/pdn.def` |
| PDN ODB | `physical/results/pdn.odb` |

### PDN generation and connectivity

| Check | Result |
|---|---|
| Initial small-floorplan PDN check | Failed because of insufficient MET4 strap width |
| Larger-floorplan PDN check | Passed |
| PDN generation | Completed successfully |
| VDD grid-shape connectivity | Passed |
| VSS grid-shape connectivity | Passed |
| Macro-grid warnings | 2; no macros were present |
| Standard-cell power-pin connectivity | Not independently confirmed |
| IR-drop analysis at this stage | Not performed |
| Electromigration analysis at this stage | Not performed |

OpenROAD reported that all VDD and VSS power-grid shapes were connected.

However, `report_net VDD` and `report_net VSS` returned zero logical pins in the recorded checks. Consequently, complete instance-level power-pin connectivity was not independently established.

The PDN generation stage should therefore be distinguished from a complete power-integrity signoff.

## 10. Global Placement

Global placement determines approximate cell locations while optimizing placement density and estimated interconnect length.

### Global placement metrics

| Metric | Value |
|---|---:|
| Total instances | 33 |
| Movable instances | 17 |
| Fixed instances | 16 |
| Nets | 19 |
| Pins | 63 |
| Reported final placed cell area | 181.4489 µm² |
| Available free area | 1,486.4256 µm² |
| Suggested minimum feasible density | 0.13 |
| Target placement density | 0.70 |
| Final HPWL | 170.68 µm |
| Placement iterations | 370 |

The target placement density was 70%, while the suggested minimum feasible density was 13%.

These are placement configuration and optimization metrics, not final core utilization or routed wirelength.

## 11. Detailed Placement

Detailed placement legalizes cell locations to satisfy placement-site and row constraints.

### Detailed placement metrics

| Metric | Value |
|---|---:|
| Total cells | 33 |
| Movable-cell area | 173.92 µm² |
| Fixed-instance area within core | 20.02 µm² |
| Reported utilization | 12.9% |
| Illegal cells | 0 |
| Illegal sites | 0 |
| Total moves | 17 |
| Total displacement | 36.5 µm |
| Average displacement | 1.1 µm |
| Maximum displacement | 4.2 µm |
| HPWL before legalization | 170.7 µm |
| HPWL after legalization | 192.5 µm |
| Approximate HPWL increase | 13% |

The legalization stage completed with zero reported illegal cells and zero illegal sites.

HPWL increased after legalization because cell locations were adjusted to satisfy physical placement constraints.

A separate placement/CTS snapshot recorded a movable-cell area of 185.18 µm² and utilization of 13.6%. Those values belong to a different reported stage or snapshot and are not substituted for the detailed-placement metrics above.

## 12. Clock Tree Synthesis

Clock tree synthesis distributes the clock signal to sequential elements while controlling clock arrival times and meeting electrical and physical constraints.

### CTS metrics

| Metric | Value |
|---|---|
| Clock roots | 1 |
| Clock nets detected | 1 |
| Clock sinks | 4 |
| Clock buffers inserted | 3 |
| Clock subnets created | 3 |
| Clock-buffer cell type | `sky130_fd_sc_hd__clkbuf_1` |
| Clock-tree maximum level reported | 1 |
| Clock path depth reported | 2 |
| Average sink wire length | 32.52 µm |
| Dummy loads inserted | 0 |
| Placement legalization violations | 0 |
| Illegal cells | 0 |
| Illegal sites | 0 |
| CTS ODB | `physical/results/cts.odb` |
| CTS DEF | `physical/results/cts.def` |

CTS completed with three inserted clock buffers for four clock sinks.

The reported clock-tree level and clock path depth use the terminology of the corresponding reports; they are retained as reported rather than interpreted as equivalent measures.

## 13. Post-CTS STA

Post-CTS STA evaluates timing with the clock tree constructed and propagated clock timing enabled.

### Post-CTS timing metrics

| Metric | Value |
|---|---:|
| Clock period | 10 ns |
| Clock frequency | 100 MHz |
| Worst setup slack / WNS | +8.3881 ns |
| Total negative setup slack / TNS | 0 ns |
| Worst register-to-register hold slack | +0.5372 ns |
| Reset recovery slack | +9.3786 ns |
| Reset removal slack | +0.5381 ns |
| Reported clock-buffer network delay to register sinks | 0.1713 ns |
| Clock timing mode | Propagated clock |
| Parasitics | Placement-estimated |
| Timing models | Liberty |

The reported setup and hold slacks are positive, and setup TNS is zero.

The clock-buffer network delay is the reported value for this stage; it should not automatically be treated as the complete clock insertion delay or clock skew.

These results use placement-estimated parasitics. They are not final routed timing results.

## 14. Global and Detailed Routing

Global routing estimates routing paths and resource demand. Detailed routing creates the physical interconnect geometry.

### Detailed routing metrics

| Metric | Value |
|---|---:|
| Detailed routing | Completed |
| Router violations at completion | 0 |
| Total routed wirelength | 265 µm |
| MET1 wirelength | 108 µm |
| MET2 wirelength | 126 µm |
| MET3 wirelength | 30 µm |
| LI1 wirelength | 0 µm reported |
| MET4 wirelength | 0 µm reported |
| MET5 wirelength | 0 µm reported |
| Total vias | 126 |
| Congestion metric | Not recorded in the available results |

The recorded layer wirelengths and total wirelength are retained from the detailed-routing summary. Rounded layer values may not sum exactly to the reported total.

Zero wirelength reported for a layer does not establish that the layer contains no physical shapes elsewhere in the layout.

The zero router-violation result is the reported detailed-router completion status. It is not, by itself, proof of foundry signoff DRC cleanliness.

## 15. Post-Route STA

Post-route STA evaluates timing using the detailed-routed database and extracted interconnect parasitics.

### Post-route analysis inputs

| Item | Value |
|---|---|
| Detailed-route ODB | `physical/results/detailed_route.odb` |
| Extracted parasitics | `physical/results/post_route.spef` |
| Clock timing | Propagated clock |
| Analysis stage | Post-route STA |

### Post-route timing metrics

| Metric | Value |
|---|---:|
| Clock period | 10 ns |
| Worst setup slack / WNS | +8.33 ns |
| Total negative setup slack / TNS | 0.00 ns |
| Worst hold slack | +0.48 ns |
| Hold TNS | 0.00 ns |

The post-route report summary records positive setup and hold slack with zero TNS for both checks.

These are the recorded post-route values and should be used instead of the post-CTS values when discussing final routed timing. The full critical-path report, explicit violation counts, and detailed path delay breakdown should be retained separately if a more complete timing audit is required.

## 16. Physical Verification

Physical verification checks whether the final layout meets geometric design rules and whether its extracted connectivity matches the intended reference netlist.

### 16.1 DRC

| Metric | Result |
|---|---|
| KLayout DRC run | Performed |
| Reported violation items | 0 |
| Foundry signoff status | Not established |

A KLayout DRC run reported zero violation items.

This is a useful result, but zero reported items should not be described as foundry signoff unless the exact rule deck, invocation, report, and applicable technology requirements have been validated.

Earlier DRC attempts encountered report-generation and KLayout compatibility issues. The final DRC report and the exact deck invocation should be retained for traceability.

### 16.2 LVS

| Metric | Result |
|---|---|
| LVS pass | No |
| Reference top-level terminals | 8 |
| Custom-deck extracted top-level terminals | 28 |
| Official-deck extracted top-level terminals | 29 |
| Custom-deck result | `ERROR : Netlists don't match` |
| Official-deck result | `ERROR : Netlists don't match` |
| Final GDS modified by these LVS tests | No |

LVS did not pass in the recorded verification attempts.

The extracted netlists contained autogenerated internal names such as `synth_1`, `synth_2`, and others as top-level terminals. In contrast, the DEF and reference CDL identified eight expected top-level ports.

The terminal-count mismatch is the principal unresolved LVS debugging issue. The extraction setup, top-level port handling, netlist naming, and reference/extracted netlist generation require further investigation.

**Important:** The project has a generated final GDSII layout, but the available verification results do not establish a successful LVS match.

## 17. Separate ORFS Automated-Flow Results

The following results belong to a separate OpenROAD Flow Scripts (ORFS) automated-flow run. They are not mixed with the manual flow metrics.

### ORFS timing metrics

| Metric | Value |
|---|---:|
| Clock period constraint | 10 ns |
| Final WNS | 0.00 ns |
| Final TNS | 0.00 ns |
| Reported worst slack | +7.82 ns |
| Minimum period | 2.18 ns |
| Equivalent maximum frequency from minimum period | 459.75 MHz |
| Hold slack | +0.55 ns |
| Setup violations | 0 |
| Hold violations | 0 |

The minimum-period frequency conversion is:

\[
f_{\max}=\frac{1}{2.18\,\text{ns}}
\approx459.75\,\text{MHz}
\]

This is a timing-derived frequency estimate from the reported minimum period, not a claim that the design was independently validated at that operating frequency under all signoff conditions.

### ORFS physical metrics

| Metric | Value |
|---|---:|
| Reported area | 320 µm² |
| Reported utilization | 13% |
| Reported power | \(3.63\times10^{-5}\) W |
| Power in microwatts | 36.3 µW |
| Routing DRC violations | 0 |
| Antenna violations | 0 |
| First reported IR-drop value | \(1.05\times10^{-4}\) V |
| Second reported IR-drop value | \(4.17\times10^{-5}\) V |

The two IR-drop values are preserved as reported. Their exact rail and location association is not established in the available summary.

### Manual flow versus ORFS

| Metric | Manual flow | ORFS flow |
|---|---|---|
| Synthesis area | 173.9168 µm² | Not treated as directly comparable |
| Reported physical area | Exact final value unavailable | 320 µm² |
| Post-route timing | WNS +8.33 ns; TNS 0 ns | Reported worst slack +7.82 ns; TNS 0 ns |
| Hold slack | +0.48 ns | +0.55 ns |
| Detailed routing | Completed | Automated flow completed |
| DRC | Zero violation items in a KLayout run; signoff not established | 0 reported routing DRC violations |
| Antenna violations | Exact final count unavailable | 0 reported |
| IR-drop results | No validated manual-flow result established | Two reported values above |
| LVS | Failed; unresolved mismatch | Not established in this summary |

The manual synthesis area and ORFS area may correspond to different implementation stages, area definitions, or optimization results. They must not be interpreted as directly comparable measurements without inspecting the original reports.

Similarly, timing results should be compared only after confirming that their constraints, parasitics, analysis corners, and reporting definitions match.

## 18. Final Project Status

### RTL-to-GDSII flow completion

| Stage | Status |
|---|---|
| RTL description | Available |
| Yosys synthesis | Completed; undriven-net warning unresolved |
| Post-synthesis STA | Completed |
| Floorplanning | Completed |
| I/O pin placement | Completed |
| Tap-cell insertion | Completed |
| PDN generation | Completed |
| Global placement | Completed |
| Detailed placement | Completed |
| Clock tree synthesis | Completed |
| Post-CTS STA | Completed |
| Global routing | Completed |
| Detailed routing | Completed |
| Post-route parasitic extraction | Reached; SPEF generated |
| Post-route STA | Completed; positive reported setup and hold slack |
| Final GDSII generation | Completed |
| DRC | Zero violation items reported in a run; signoff not established |
| LVS | Failed; unresolved netlist mismatch |

### Key recorded results

| Metric | Recorded value |
|---|---:|
| Die area | 1,936 µm² |
| Core area | 1,506.445 µm² |
| Synthesized standard-cell area | 173.9168 µm² |
| Detailed-placement movable-cell area | 173.92 µm² |
| Clock buffers inserted | 3 |
| Clock sinks | 4 |
| Detailed-route wirelength | 265 µm |
| Detailed-route vias | 126 |
| Post-route setup WNS | +8.33 ns |
| Post-route setup TNS | 0 ns |
| Post-route hold slack | +0.48 ns |
| Post-route hold TNS | 0 ns |
| KLayout DRC violation items | 0 reported |
| LVS | Failed |

## 19. Known Issues and Future Work

The next steps should focus on verification quality rather than simply rerunning the physical implementation.

1. **Resolve the Yosys undriven-net warning.** Inspect the RTL, synthesis script, and synthesized netlist to determine why `count[3:0]` was reported as undriven despite the recorded flip-flop output connections.

2. **Debug LVS terminal mismatches.** Investigate why the extracted netlists contain 28 or 29 top-level terminals while the reference netlist has eight. Verify the extraction setup, top-cell selection, power/ground treatment, and port handling.

3. **Preserve complete DRC evidence.** Retain the final DRC report, exact deck, tool version, command invocation, and violation summary.

4. **Confirm power-pin connectivity.** Independently verify standard-cell VDD/VSS connectivity instead of relying exclusively on connected power-grid shapes.

5. **Perform and document power-integrity analysis.** Record validated IR-drop and electromigration results for the manual flow if the selected platform and tools support the required analyses.

6. **Archive the final timing reports.** Keep the complete post-route setup and hold reports, critical paths, clock details, extracted SPEF, and analysis constraints.

7. **Keep flow results traceable.** Record the exact configuration, source RTL, library versions, scripts, and report files associated with each implementation run.

## Conclusion

This project demonstrates a step-by-step RTL-to-GDSII physical design flow for a 4-bit Mod-10 counter using open-source EDA tools and the SkyWater SKY130 HD technology.

The manual flow progressed from synthesis through detailed routing, generated the final GDSII layout, and recorded positive post-route setup and hold slack. The separate ORFS run provides an additional automated-flow reference.

The project remains a work in progress from a verification standpoint: the synthesis undriven-net warning and LVS mismatch require resolution, and the recorded DRC result does not independently establish foundry signoff.

The emphasis is on understanding each physical implementation stage, collecting measurable results, and maintaining traceability between RTL, timing constraints, physical databases, routing parasitics, and final layout verification.
