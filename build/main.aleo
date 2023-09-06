import merkle_012345678_memes.aleo;
import rsa_012345678_memes.aleo;
program backend_012345678_memes.aleo;

struct GiftCard:
    seller as address;
    price as u128;
    card_type as u128;
    bought as boolean;
    verify as boolean;

struct Offer:
    buyer as address;
    price as u128;
    modulus as u128;
    approved as boolean;
    card as GiftCard;

record token:
    owner as address.private;
    amount as u128.private;


mapping nullifier_tree:
	key left as u32.public;
	value right as boolean.public;


mapping listings:
	key left as field.public;
	value right as GiftCard.public;


mapping offers:
	key left as u128.public;
	value right as Offer.public;

function create_listing:
    input r0 as field.public;
    input r1 as field.public;
    input r2 as field.public;
    input r3 as u32.public;
    input r4 as boolean.public;
    input r5 as u128.private;
    input r6 as u128.public;
    input r7 as u128.public;
    is.eq r4 true into r8;
    call merkle_012345678_memes.aleo/merkle_membership r0 r1 r2 0field r5 r3 into r9;
    ternary r8 r9 0field into r10;
    cast self.caller r6 r7 false r4 into r11 as GiftCard;

    finalize r10 r11;

finalize create_listing:
    input r0 as field.public;
    input r1 as GiftCard.public;
    is.neq r0 0field into r2;
    set r1 into listings[r0];
    rand.chacha into r3 as field;
    set r1 into listings[r3];


function buy:
    input r0 as u128.public;
    input r1 as u128.public;
    input r2 as field.public;
    cast self.caller r1 into r3 as token.record;
    output r3 as token.record;

    finalize self.caller r0 r1 r2;

finalize buy:
    input r0 as address.public;
    input r1 as u128.public;
    input r2 as u128.public;
    input r3 as field.public;
    get listings[r3] into r4;
    cast r0 r2 r1 false r4 into r5 as Offer;
    rand.chacha into r6 as u128;
    set r5 into offers[r6];


function approve_sale:
    input r0 as field.public;
    input r1 as field.public;
    input r2 as field.public;
    input r3 as u32.public;
    input r4 as u128.private;
    input r5 as u128.public;
    input r6 as u128.public;
    input r7 as u128.public;
    call merkle_012345678_memes.aleo/merkle_membership r0 r1 r2 0field r4 r3 into r8;
    call rsa_012345678_memes.aleo/compute_modular_exponentiation r4 r7 into r9;

    finalize r5 r6 r3 r9 r7;

finalize approve_sale:
    input r0 as u128.public;
    input r1 as u128.public;
    input r2 as u32.public;
    input r3 as u128.public;
    input r4 as u128.public;
    get offers[r0] into r5;
    is.eq r4 r5.modulus into r6;
    assert.eq r6 true;
    get nullifier_tree[r2] into r7;
    assert.eq r3 r1;
    assert.eq r7 true;
