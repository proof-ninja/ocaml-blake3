let hex_string bs =
  let list_of_bytes bs =
    let len = String.length bs in
    List.init len (fun i -> String.get bs i)
  in
  list_of_bytes bs
  |> List.map int_of_char
  |> List.map (Printf.sprintf "%02x")
  |> String.concat ""

let () =
  let h = Blake3.hash "Hello\n" in
  let expected =
    (*
       $ echo Hello | b3sum -
       38d5445421bfd60d4d48ff2a7acb3ed412e43e68e66cdb2bb86f604ec6e6caa0  -
    *)
    "38d5445421bfd60d4d48ff2a7acb3ed412e43e68e66cdb2bb86f604ec6e6caa0"
  in
  assert (expected = hex_string h)
