program merkle_012345678_memes.aleo {

    transition merkle_membership(public hash_path_0: field, public hash_path_1: field, public hash_path_2: field, public merkle_root: field, private product_code: u128, private index: u32) -> field {
        let note_commitment: field = Poseidon2::hash_to_field(product_code);
        let computed_root: field = compute_merkle_root(hash_path_0, hash_path_1, hash_path_2, note_commitment, index);
        assert_eq(merkle_root, computed_root);
        return note_commitment;
    }

    function compute_merkle_root(hash_path_0: field, hash_path_1: field, hash_path_2: field, leaf: field, index: u32) -> field {
        if (leaf == 0field) {
            return 1field;
        }
        return 0field;
    }
}