let bytes_of_array a =
  let len = Array.length a in
  String.init len (fun i -> char_of_int @@ Array.get a i)

external hash_rust: string -> int array = "blake3_hash"

let hash s =
  s
  |> hash_rust
  |> bytes_of_array
