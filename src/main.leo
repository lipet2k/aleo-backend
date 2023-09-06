// The 'backend' program.
import merkle_012345678_memes.leo;
import rsa_012345678_memes.leo;

program backend_012345678_memes.aleo {

    mapping nullifier_tree: u32 => bool;

    mapping listings: field => GiftCard;

    mapping offers: u128 => Offer;

    struct Offer {
        buyer: address,
        price: u128,
        modulus: u128,
        approved: bool,
        card: GiftCard
    }

    struct GiftCard {
        seller: address,
        price: u128,
        card_type: u128,
        bought: bool,
        verify: bool
    }

    record token {
        owner: address,
        amount: u128
    }
    
    transition create_listing(public hash_path_0: field, public hash_path_1: field, public hash_path_2: field, public index: u32, public verify: bool, private product_code: u128, public price: u128, public card_type: u128) {
        // Create a listing.

        // 0 flag
        let root: field  = 0field;
        if (verify == true) {
            root = merkle_012345678_memes.leo/merkle_membership(hash_path_0, hash_path_1, hash_path_2, root, product_code, index);
        }

        let new_listing: GiftCard = GiftCard {
            seller: self.caller,
            price: price,
            card_type: card_type,
            bought: false,
            verify: verify
        };

        return then finalize(root, new_listing);
    }

    finalize create_listing(public root: field, public new_listing: GiftCard) {
        if (root != 0field) {
            Mapping::set(listings, root, new_listing);
        }
        else {
            let id: field = ChaCha::rand_field();
            Mapping::set(listings, id, new_listing);
        }
    }

    transition buy(public modulus: u128, public price: u128, public card_id: field) -> token {

        let buyer: address = self.caller;

        let new_token: token = token {
            owner: self.caller,
            amount: price
        };

        return new_token then finalize(buyer, modulus, price, card_id);
    }

    finalize buy(public caller_address: address, public modulus: u128, public price: u128, public card_id: field) {

        let listing: GiftCard = Mapping::get(listings, card_id);
        let offer: Offer = Offer {
            buyer: caller_address,
            price: price,
            modulus: modulus,
            approved: false,
            card: listing
        };
        let id: u128 = ChaCha::rand_u128();
        Mapping::set(offers, id, offer);
    }

    transition approve_sale(public hash_path_0: field, public hash_path_1: field, public hash_path_2: field, public index: u32, private product_code: u128, public offer_id: u128, public encrypted: u128, public modulus: u128) {
        let merkle_root: field = 0field;
        let root: field = merkle_012345678_memes.leo/merkle_membership(hash_path_0, hash_path_1, hash_path_2, merkle_root, product_code, index);
        let rsa_encrypted: u128 = rsa_012345678_memes.leo/compute_modular_exponentiation(product_code, modulus);
        return then finalize(offer_id, encrypted, index, rsa_encrypted, modulus);
    }

    finalize approve_sale(public offer_id: u128, public encrypted: u128, public index: u32, public rsa_encrypted: u128, public modulus: u128) {
        let offer: Offer = Mapping::get(offers, offer_id);
        assert(modulus == offer.modulus);
        let nullifier: bool = Mapping::get(nullifier_tree, index);
        assert_eq(rsa_encrypted, encrypted);
        assert(nullifier);
    }

}
