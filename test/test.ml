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
  let h = Blake3.hash "Hello" in
  assert ("fbc2b0516ee8744d293b980779178a3508850fdcfe965985782c39601b65794f" = hex_string h)
