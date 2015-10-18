open Error

type typ = TYPE_none
         | TYPE_int
         | TYPE_char
	 | TYPE_bool
         | TYPE_array of
             typ *
             int
	 | TYPE_list of
	     typ
	 | TYPE_func     (* This needs a fix *)

let rec sizeOfType t =
   match t with
   | TYPE_int            -> 2
   | TYPE_char           -> 1
   | TYPE_bool           -> 1
   | TYPE_array (et, sz) -> 2 (* sz * sizeOfType et *)
   | TYPE_list   _       -> 2
   | _                   -> 0

let rec equalType t1 t2 =
   match t1, t2 with
   | TYPE_array (et1, sz1), TYPE_array (et2, sz2) -> equalType et1 et2
   | TYPE_list et1, TYPE_list et2                 -> equalType et1 et2
   | _                                            -> t1 = t2

let extractType = function
  | TYPE_list  t      -> t
  | TYPE_array (t, _) -> t
  | x                 -> x

let isPointerType t = match t with
  | TYPE_int | TYPE_bool | TYPE_char -> false
  | TYPE_array _ | TYPE_list _       -> true
  | _ -> ( internal "isPointerType function is called with invalid type!"; raise Terminate )

		       
(* Function that decides if v of 'byte type' needs extension to 'word type'.
 * This function is used in consv and head *)
let needSizeExtend t =
  match t with 
  | TYPE_char | TYPE_bool -> true
  | TYPE_none -> ( internal "needSizeExtend called with TYPE_none!"; raise Terminate )
  | _ -> false
    
