let hash_size = 32

let with_time f =
  let t1 = Ptime_clock.now () in
  let res = f () in
  let t2 = Ptime_clock.now () in
  res, (Ptime.Span.to_float_s @@ Ptime.diff t2 t1)

let load_file filename =
  let ch = open_in_bin filename in
  let size = in_channel_length ch in
  let body = really_input_string ch size in
  close_in ch;
  body

let hex_string bs =
  let list_of_bytes bs =
    let len = String.length bs in
    List.init len (fun i -> String.get bs i)
  in
  list_of_bytes bs
  |> List.map int_of_char
  |> List.map (Printf.sprintf "%02x")
  |> String.concat ""

let small_test () =
  let h = Blake3.hash hash_size "Hello\n" in
  let expected =
    (*
       $ echo Hello | b3sum -
       38d5445421bfd60d4d48ff2a7acb3ed412e43e68e66cdb2bb86f604ec6e6caa0  -
    *)
    "38d5445421bfd60d4d48ff2a7acb3ed412e43e68e66cdb2bb86f604ec6e6caa0"
  in
  assert (expected = hex_string h)

let blake2 hash_size s =
  let open Hacl_star in
  let key = Bytes.create 0 in
  let inbuf = Bytes.unsafe_of_string s in
  let outbuf = Bytes.create hash_size in
  Hacl.Blake2b_32.hash key inbuf outbuf;
  Bytes.unsafe_to_string outbuf


let test_using_file expected_hash filename =
  let ((), time) = with_time @@ fun () ->
    let bytes = load_file filename in
    let actual = hex_string @@ Blake3.hash hash_size bytes in
    if expected_hash <> actual then begin
      Printf.eprintf "---\nexpected: %s\n actual:   %s\n" expected_hash actual;
      assert false
    end
  in
  let (_, time2) = with_time @@ fun () ->
    let bytes = load_file filename in
    blake2 hash_size bytes
  in
  Printf.printf "Testing with the file '%s' done: time: %f, (hacl_blake2: %f)\n"
    filename time time2

let measure () =
  let module RS = Random.State in
  let small_hash = 28 in
  let gen_string st len =
    String.init len (fun _i -> char_of_int @@ RS.int st 256)
  in
  let st = RS.make_self_init () in
  let time_blake3, time_blake2 = ref 0., ref 0. in
  for _i = 1 to 1000000 do
    let input = gen_string st 60 in
    let (_out1, time1) = with_time @@ fun () -> Blake3.hash small_hash input in
    let (_out2, time2) = with_time @@ fun () -> blake2 small_hash input in
    time_blake3 := time1 +. !time_blake3;
    time_blake2 := time2 +. !time_blake2;
  done;
  Printf.printf "small data: Blake3 %f, Blake2 %f\n" !time_blake3 !time_blake2


let () =
  small_test ();
  test_using_file "488de202f73bd976de4e7048f4e1f39a776d86d582b7348ff53bf432b987fca8" "1M.dummy";
  test_using_file "7ebdce605f77d5e713a8eeb0e46ace177a27af851c6508730d52255c01b8af0d" "1G.dummy";
  measure ();
  ()
