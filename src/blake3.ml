external rust_hash : string -> bytes -> unit = "blake3_hash" [@@noalloc]
external rust_hash_mc : string -> bytes -> unit = "blake3_hash_multicore" [@@noalloc]

let hash size s =
  let bytes = Bytes.create size in
  rust_hash s bytes;
  Bytes.to_string bytes

let hash_multicore size s =
  let bytes = Bytes.create size in
  rust_hash_mc s bytes;
  Bytes.to_string bytes
