program merkle_012345678_memes.aleo;



closure compute_merkle_root:
    input r0 as field;
    input r1 as field;
    input r2 as field;
    input r3 as field;
    input r4 as u32;
    is.eq r3 0field into r5;
    ternary r5 1field 0field into r6;
    output r6 as field;


function merkle_membership:
    input r0 as field.public;
    input r1 as field.public;
    input r2 as field.public;
    input r3 as field.public;
    input r4 as u128.private;
    input r5 as u32.private;
    hash.psd2 r4 into r6 as field;    call compute_merkle_root r0 r1 r2 r6 r5 into r7;
    assert.eq r3 r7;
    output r6 as field.private;
