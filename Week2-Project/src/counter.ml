open! Core
open Hardcaml
open Signal
(*
Name: Jose Martinez-Ponce
Date: 7/19/2025
Purpose: Achieve --> C' + AB + DE' = Q
Will assign 1 bits to each letter and have 1 bit be the output bit

*)

module I = struct (*Input: a b c d e*)
  type 'a t =
    { a : 'a [@bits 1]
    ; b : 'a [@bits 1]
    ; c : 'a [@bits 1]
    ; d : 'a [@bits 1]
    ; e : 'a [@bits 1]
    }
  [@@deriving hardcaml]
end

module O = struct (*Output: y*)
  type 'a t = { y : 'a [@bits 1] } [@@deriving hardcaml]
end

(*Logic: AB + C' + DE'*)
let create (i : _ I.t) : _ O.t = { y = ((i.a &: i.b) |: (i.c ^:.1) |: (i.d &: (i.e ^:.1)))}
;;

let board () =
  let open Hardcaml_hobby_boards in
  let board = Board.create () in
  let switches = Nexys_a7_100t.Switches.create board in
  
  let result = (
    create { 
      a = switches.:[15,15]; 
      b = switches.:[14,14]; 
      c = switches.:[13,13]; 
      d = switches.:[12,12]; 
      e = switches.:[11,11];
      })
    in
  assert (width result.y = 1);
  let output = concat_msb [zero 15; result.y] in
  Nexys_a7_100t.Leds.complete board output;
  board
;;
