open Core
open Hardcaml
open Hardcaml_waveterm
open Hardcaml_example

let test_counter () =
  let module Sim = Cyclesim.With_interface (Counter.I) (Counter.O) in
  let sim = Sim.create Counter.create in
  let waves, sim = Waveform.create sim in
  let inputs = Cyclesim.inputs sim in
  inputs.enable := Bits.gnd;
  inputs.reset := Bits.vdd;
  inputs.clear := Bits.gnd;
  inputs.d := Bits.of_string "111";
  Cyclesim.cycle ~n:1 sim;

  inputs.d := Bits.of_string "101";
  inputs.enable := Bits.vdd;
  Cyclesim.cycle ~n:2 sim;

  inputs.enable := Bits.gnd;
  inputs.d := Bits.of_string "001";
  Cyclesim.cycle ~n:1 sim;

  inputs.d := Bits.of_string "001";
  Cyclesim.cycle ~n:1 sim;

  inputs.d := Bits.of_string "110";
  Cyclesim.cycle ~n:1 sim;

  inputs.reset := Bits.vdd;
  Cyclesim.cycle ~n:3 sim;
  waves
;;

let%expect_test "test counter" =
  Waveform.print (test_counter ());
  [%expect {|
    ┌Signals────────┐┌Waves──────────────────────────────────────────────┐
    │clock          ││┌───┐   ┌───┐   ┌───┐   ┌───┐   ┌───┐   ┌───┐   ┌──│
    │               ││    └───┘   └───┘   └───┘   └───┘   └───┘   └───┘  │
    │reset          ││                                                   │
    │               ││───────────────────────────────────────────────────│
    │clear          ││                                                   │
    │               ││───────────────────────────────────────────────────│
    │enable         ││        ┌───────────────┐                          │
    │               ││────────┘               └──────────────────────────│
    │               ││────────┬───────────────┬───────────────┬──────────│
    │d              ││ 7      │5              │1              │6         │
    │               ││────────┴───────────────┴───────────────┴──────────│
    │               ││────────────────┬──────────────────────────────────│
    │q              ││ 0              │5                                 │
    │               ││────────────────┴──────────────────────────────────│
    └───────────────┘└───────────────────────────────────────────────────┘
    |}]
;;
