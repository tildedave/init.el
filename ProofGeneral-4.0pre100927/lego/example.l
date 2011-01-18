(*
    Example proof script for Lego Proof General.
 
    example.l,v 10.0 2008/07/24 10:00:18 da Exp
*)

Module example Import lib_logic;

Goal {A,B:Prop}(A /\ B) -> (B /\ A);
intros;
Refine H;
intros;
andI;
Immed;
Save and_comms;
