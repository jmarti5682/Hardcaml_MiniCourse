# Week 4: Work on your own
For this week I worked on creating a 3-stage pipeline using DFFs (D Flip Flop). At each stage the DFF would record and save the value from the combinational logic block.

## Overview: 

We have a 3-stage pipeline that goes start off with two 4-bit inputs for two DFFs. Where the first input is controlled by switches `3 to 6` and `7 to 10`. From there those two inputs go through various stages to have the final result stored in the last DFF. It basically goes through an `AND`, `NAND`, and then a `XOR` gate. 

## Modifications: 

  - **../src/counter.ml**
    - ```
      ; d       : 'a [@bits 4]
      ```
      ```
      module O = struct
        type 'a t = { q : 'a [@bits 4]} [@@deriving hardcaml]
      end
      ```
      ```
      let result1 =
        (create
           { I.clock
           ; reset  = switches.:[0, 0]
           ; clear  = switches.:[1, 1]
           ; enable = switches.:[2, 2]
           ; d      = switches.:[6, 3] (*First Data Input*) (*4 Bit*) (*DDF1 = First Value*)
           })
          .q
      in
      let result2 = 
        (create
          { I.clock
          ; reset  = switches.:[0, 0]
          ; clear  = switches.:[1, 1]
          ; enable = switches.:[2, 2]
          ; d      = switches.:[10, 7]   (*Second Data Input*) (*4 Bit*) (*DFF2 = Second Value*)
          })
          .q
      in
      ```
      
      ```
      let result3 = result1 &: result2 in     (*Stage 1: AND GATE*)
      ```
      
      ```
      let result6 = ~:(result5 &: result4) in (*Stage 2: NAND GATE*)
      ```
      ```
      let result9 = result8 ^: result7; in    (*Stage 3: XOR GATE*)
      ```
      
      ```
      let result11 = concat_msb [ 
        result10;
        result8;
        result5;
        result4;
        ] in
      ```
