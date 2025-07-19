# Week 2: Work on your own
For this week I worked on solving the truth table given to us and implementing it into Hardcaml, where I then flashed it onto the FPGA (NEXYS A7). The soultion is provided in work.pdf, albeit a little messy, but none the less correct.

## Overview: 
I am creating a 5-input Boolean expression based off the truth table below. I went with 1-bit inputs for A, B, C, D, and E using combinational logic. 

  Here is the truth table: 
<div align = "center">
  <img src = "../assets/truth_table_1.JPG" width = "500"/>
</div>

> Soultion: Q = C' + AB + DE'


## Modifications: 

- **../src/counter.ml**
  - ```
    
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

    ```

    I added more inputs and set them to be 1 bit. In addition, our output is also set to 1 bit. Lastly, I immplemented the logic using logical operations. However, I was unable to use the `~:` operation due to type mismatch, so I use an `xor 1` to achieve the same effect.

    ```
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
    ```

  As well, I went ahead and reassigned the switches to correspond to one switch, with A being SW 15, B being SW 14, etc, etc. That assert line is there because I kept running into issues with my total width being 17 (which is bigger than 16), however that error came from me orignally setting my switches to fit two switches. I did that because I did not know I could just use the same switch i.e. `a = switches.:[15,15];` works, but `a = switches.:15;` does not work. From there I padded the output that way we can just observe just one LED (LED 0).

- **../src/counter.mli**
  - ```
    module I : sig
      type 'a t =
        { a : 'a [@bits 1]
        ; b : 'a [@bits 1]
        ; c : 'a [@bits 1]
        ; d : 'a [@bits 1]
        ; e : 'a [@bits 1]
        }
      [@@deriving hardcaml]
    end
    
    module O : sig
      type 'a t = { y : 'a [@bits 1] } [@@deriving hardcaml]
    end
    ```
  In the `counter.mli` I just updated the input module accordingly, as well as the output module. 
    

- **../test/test_counter.ml**
  - ```
    (*Should produce a true statement=*)
    inputs.a := Bits.of_string "1";              (*1*)
    inputs.b := Bits.of_unsigned_int ~width:1 1; (*1*)
    inputs.c := Bits.of_string "0";              (*0*)
    inputs.d := Bits.of_string "0";              (*0*)
    inputs.e := Bits.of_unsigned_int ~width:1 1; (*1*)
    Cyclesim.cycle ~n:1 sim;
    ```

  Inside the `test_counter.ml` file, I modified the test cases to fit the design as well as added more test cases to simulate the different cases from the truth table. All of the tests last for one cycle.

  To see the test cases in the terminal: 
  ```
  dune runtest
  ```

  ```
  dune promote
  ```

  ```
  dune exec bin/counter.exe simulate
  ```

## How to Run

First we have to build the project:

```
dune build
```

Then we can create the files scripts file necessary to create the bitsteam file for the FPGA.

```
dune exec bin/counter.exe nexys-a7
```

From there, depending on your environment (for instance, I am using a linux vm where I transfer the files to my windows machine with vivado installed) we can run these two commands in Windows PowerShell to flash our FPGA. 

```
C:\Xilinx\Vivado\2024.1\bin\vivado -mode batch -source nexys_a7_100t.tcl
```

```
C:\Xilinx\Vivado\2024.1\bin\vivado -mode batch -source flash.tcl
```

