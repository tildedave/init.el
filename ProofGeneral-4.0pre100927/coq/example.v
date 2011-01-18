(*
    Example proof script for Coq Proof General.

    example.v,v 10.2 2009/12/01 10:59:21 da Exp
*)

Module Example.

Goal forall (A B:Prop),(A /\ B) -> (B /\ A). 
  intros A B.
  intros H.
  elim H.
  split.
  assumption.
  assumption.
Save and_comms.

End Example.
