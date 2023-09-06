program rsa_012345678_memes.aleo {

    transition compute_modular_exponentiation(private product_code: u128, public modulus: u128) -> u128 {

        if (modulus == 1u128) {
            return 0u128;
        }
        let result: u128 = 1u128;

        for e: u128 in 0u128..17u128 {
            result = (result * product_code) % modulus;
        }

        return result;
    }
}