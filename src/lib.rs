#[ocaml::func]
pub fn blake3_hash(input: &[u8], output: &mut [u8]) -> () {
    let mut hasher = blake3::Hasher::new();
    hasher.update(input);
    let mut output_reader = hasher.finalize_xof();
    output_reader.fill(output);
}
