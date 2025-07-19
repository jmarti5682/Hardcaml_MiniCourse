open Core
open Hardcaml
open Hardcaml_waveterm
open Hardcaml_example
(* open Hardcaml.Bits *)

let test_counter () =
  let module Sim = Cyclesim.With_interface (Counter.I) (Counter.O) in
  let sim = Sim.create Counter.create in
  let waves, sim = Waveform.create sim in
  let inputs = Cyclesim.inputs sim in

  (*Should produce a true statement=*)
  inputs.a := Bits.of_string "1";              (*1*)
  inputs.b := Bits.of_unsigned_int ~width:1 1; (*1*)
  inputs.c := Bits.of_string "0";              (*0*)
  inputs.d := Bits.of_string "0";              (*0*)
  inputs.e := Bits.of_unsigned_int ~width:1 1; (*1*)
  Cyclesim.cycle ~n:1 sim;

  (*Should produce a false statement=*)
  inputs.a := Bits.of_string "1";              (*1*)
  inputs.b := Bits.of_unsigned_int ~width:1 0; (*0*)
  inputs.c := Bits.of_string "1";              (*1*)
  inputs.d := Bits.of_string "0";              (*0*)
  inputs.e := Bits.of_unsigned_int ~width:1 0; (*0*)
  Cyclesim.cycle ~n:1 sim;

  (*Should produce a true statement=*)
  inputs.a := Bits.of_string "1";              (*1*)
  inputs.b := Bits.of_string "0";              (*0*)
  inputs.c := Bits.of_string "0";              (*0*)
  inputs.d := Bits.of_string "0";              (*0*)
  inputs.e := Bits.of_string "0";              (*0*)
  Cyclesim.cycle ~n:1 sim;

  (*Should produce a false statement=*)
  inputs.a := Bits.of_string "1";              (*1*)
  inputs.b := Bits.of_string "0";              (*0*)
  inputs.c := Bits.of_string "1";              (*1*)
  inputs.d := Bits.of_string "0";              (*0*)
  inputs.e := Bits.of_string "0";              (*0*)
  Cyclesim.cycle ~n:1 sim;


  (*Should produce a true statement=*)
  inputs.a := Bits.of_string "1";              (*1*)
  inputs.b := Bits.of_string "1";              (*1*)
  inputs.c := Bits.of_string "1";              (*1*)
  inputs.d := Bits.of_string "1";              (*1*)
  inputs.e := Bits.of_string "1";              (*1*)
  Cyclesim.cycle ~n:1 sim;
  (* inputs.enable := Bits.vdd;
  Cyclesim.cycle ~n:3 sim; *)
  waves
;;

let%expect_test "test counter" =
  Waveform.print (test_counter ());
  [%expect
    {|
    ┌Signals────────┐┌Waves──────────────────────────────────────────────┐
    │               ││────────────────┬───────                           │
    │a              ││ F0             │0F                                │
    │               ││────────────────┴───────                           │
    │               ││────────────────────────                           │
    │b              ││ 28                                                │
    │               ││────────────────────────                           │
    │               ││────────────────┬───────                           │
    │y              ││ 20             │08                                │
    │               ││────────────────┴───────                           │
    └───────────────┘└───────────────────────────────────────────────────┘
    |}]
;;
