let bytes_of_array a =
  let len = Array.length a in
  String.init len (fun i -> char_of_int @@ Array.get a i)

let array_of_bytes s =
  let len = String.length s in
  Array.init len (fun i -> int_of_char @@ String.get s i)

external hash_rust: int array -> int array = "blake3_hash"

let hash s =
  array_of_bytes s
  |> hash_rust
  |> bytes_of_array
