open! Core
open Hardcaml

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

val create : Interface.Create_fn(I)(O).t

(* Construct top level board design. *)
val board : unit -> Hardcaml_hobby_boards.Board.t