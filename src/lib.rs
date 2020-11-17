#[ocaml::func]
pub fn blake3_hash(input: &[u8]) -> Vec<u8> {
  return blake3::hash(input).as_bytes().to_vec();
}
