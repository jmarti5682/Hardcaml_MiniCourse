open! Core
open Hardcaml
open Signal

(*Name: Jose Martinez-Ponce*)
(*Date: 7/30/2025*)
(*Purpose: To achieve a three stage pipeline, see schematic in repo labled drawing.jpg*)

module I = struct
  type 'a t =
    { clock   : 'a
    ; reset   : 'a
    ; clear   : 'a
    ; enable  : 'a
    ; d       : 'a [@bits 4]
    }
  [@@deriving hardcaml]
end

module O = struct
  type 'a t = { q : 'a [@bits 4]} [@@deriving hardcaml]
end

let create (i : _ I.t) =
  { O.q =
      reg
        (Reg_spec.create ~clock:i.clock ~reset:i.reset ~clear:i.clear ())
        ~enable:i.enable
        i.d
  }
;;

let board () =
  let open Hardcaml_hobby_boards in
  let board = Board.create () in
  let switches = Nexys_a7_100t.Switches.create board in
  let%tydi { clock_100 = clock; _ } = Nexys_a7_100t.Clock_and_reset.create board in
  let result1 =
    (create
       { I.clock
       ; reset  = switches.:[0, 0]
       ; clear  = switches.:[1, 1]
       ; enable = switches.:[2, 2]
       ; d      = switches.:[6, 3] (*First Data Input*) (*3 Bit*) (*DDF1 = First Value*)
       })
      .q
  in
  let result2 = 
    (create
      { I.clock
      ; reset  = switches.:[0, 0]
      ; clear  = switches.:[1, 1]
      ; enable = switches.:[2, 2]
      ; d      = switches.:[10, 7]   (*Second Data Input*) (*3 Bit*) (*DFF2 = Second Value*)
      })
      .q
  in
  let result3 = result1 &: result2 in (*Stage 1: AND GATE*)
  let result4 =
    (create
       { I.clock
       ; reset  = switches.:[0, 0]
       ; clear  = switches.:[1, 1]
       ; enable = switches.:[2, 2]
       ; d      = result3             (*DFF3 = Result of AND GATE*)
       })
      .q
  in
  let result5 =
    (create
      { I.clock
      ; reset  = switches.:[0, 0]
      ; clear  = switches.:[1, 1]
      ; enable = switches.:[2, 2]
      ; d      = ~:(result2)          (*DFF4 = Invertor for D'*)
      })
      .q
  in
  let result6 = ~:(result5 &: result4) in (*Stage 2: NAND GATE*)
  let result7 =
    (create
      { I.clock
      ; reset  = switches.:[0,0]
      ; clear  = switches.:[1,1]
      ; enable = switches.:[2,2]
      ; d      = result4          (*DDF5 = DFF3*)
      })
      .q
  in
  let result8 =
    (create
      { I.clock
      ; reset  = switches.:[0,0]
      ; clear  = switches.:[1,1]
      ; enable = switches.:[2,2]
      ; d      = result6          (*DFF6 = Result of NAND Gate*)
      })
      .q
  in
  let result9 = result8 ^: result7; in(*Stage 3: XOR GATE*)
  let result10 = 
    (create
      {I.clock
      ; reset  = switches.:[0,0]
      ; clear  = switches.:[1,1]
      ; enable = switches.:[2,2]
      ; d      = result9            (*DFF7 = Final result saved*)
      })
      .q
    in

  let result11 = concat_msb [ 
    result10;
    result8;
    result5;
    result4;
    ] in
  let resized = uresize result11 ~width:16 in
  Nexys_a7_100t.Leds.complete board resized; (*LEDs*)
  board
;;
