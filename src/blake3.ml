external rust_hash : string -> bytes -> unit = "blake3_hash" [@@noalloc]

let hash size s =
  let bytes = Bytes.create size in
  rust_hash s bytes;
  Bytes.to_string bytes
