#[ocaml::func]
pub unsafe fn blake3_hash(input: &[u8]) -> String {
    return String::from_utf8_unchecked (blake3::hash(input).as_bytes().to_vec());
}
