const T = 0x00000000;
const B = 0x11000000;
const W = 0xFFFFFFFF;
const P = 0xFFad03fc;
pub const pixels = [32*32]u32 { // Now he is safe here :)
    P,P,P,P,P,P,P,P,P,P,P,P,P,P,P,P,P,P,P,P,P,P,P,P,P,P,P,P,P,P,P,P,
    P,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,P,
    P,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,P,
    P,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,P,
    P,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,P,
    P,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,P,
    P,T,T,T,T,T,T,T,T,T,W,W,W,W,W,W,W,W,W,W,T,T,T,T,T,T,T,T,T,T,T,P,
    P,T,T,T,T,T,T,T,W,W,W,W,W,W,W,W,W,W,W,W,W,T,T,W,T,T,T,T,T,T,T,P,
    P,T,T,T,T,T,T,W,W,W,T,T,T,T,T,T,T,T,T,W,W,W,T,T,T,T,T,T,T,T,T,P,
    P,T,T,T,T,T,W,W,W,T,T,T,T,T,T,T,T,T,T,T,T,W,W,T,T,T,T,T,T,T,T,P,
    P,T,T,T,T,W,W,W,T,T,T,W,W,T,T,T,T,W,W,T,T,W,W,T,T,T,T,T,T,T,T,P,
    P,T,T,T,W,W,W,T,T,T,W,T,W,T,T,T,T,W,W,W,T,T,W,W,T,T,T,T,T,T,T,P,
    P,T,T,T,W,W,T,T,T,T,W,T,T,W,T,T,W,W,T,T,W,W,W,W,T,T,T,T,W,T,T,P,
    P,T,T,T,W,W,T,T,T,W,T,T,T,W,W,T,W,T,T,T,T,W,T,W,T,T,T,T,T,T,T,P,
    P,T,T,T,W,W,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,W,W,T,T,T,T,T,T,T,P,
    P,T,T,T,W,W,W,T,T,T,T,T,W,W,T,T,T,T,W,W,T,T,W,W,T,T,T,T,T,T,T,P,
    P,T,T,T,W,W,W,T,T,T,T,T,T,W,W,W,W,W,W,T,T,W,W,W,T,T,T,T,T,T,T,P,
    P,T,T,T,T,W,W,W,W,T,T,T,T,T,T,T,T,T,T,T,W,W,W,T,T,T,T,T,T,T,T,P,
    P,T,T,T,T,T,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,T,T,T,T,T,T,T,T,T,P,
    P,T,T,T,T,T,T,T,T,W,W,W,W,W,W,W,W,W,W,W,T,T,T,T,T,T,W,T,T,T,T,P,
    P,T,T,T,T,T,T,T,T,T,W,W,T,T,T,T,T,W,W,T,T,T,T,T,T,T,T,T,T,T,T,P,
    P,T,T,T,T,T,T,T,T,T,W,W,T,T,T,T,T,W,W,T,T,T,T,T,T,T,T,T,T,T,T,P,
    P,T,T,T,T,T,T,T,T,T,W,W,T,T,T,T,T,W,W,W,T,T,T,T,T,T,T,T,T,T,T,P,
    P,T,T,T,T,T,T,T,T,T,W,W,T,T,W,W,W,W,W,W,T,T,T,T,T,T,T,T,T,T,T,P,
    P,T,T,T,T,T,T,T,T,T,W,W,W,W,W,W,W,W,W,W,T,T,T,T,T,T,T,T,T,T,T,P,
    P,T,T,T,T,T,T,T,T,T,W,W,W,W,T,T,T,T,W,W,T,T,T,T,T,T,T,T,T,T,T,P,
    P,T,T,T,T,T,T,T,T,W,W,W,T,T,T,T,T,T,W,W,T,T,T,T,T,T,T,T,T,T,T,P,
    P,T,T,T,T,T,T,T,T,W,W,W,T,T,T,T,T,T,W,W,T,T,T,T,T,T,T,T,T,T,T,P,
    P,T,T,T,T,T,W,W,W,W,W,W,T,T,T,T,T,T,W,W,W,W,W,T,T,T,T,T,T,T,T,P,
    P,T,T,T,T,T,W,W,W,W,W,W,T,T,T,T,T,T,W,W,W,W,W,T,T,T,T,T,T,T,T,P,
    P,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,P,
    P,P,P,P,P,P,P,P,P,P,P,P,P,P,P,P,P,P,P,P,P,P,P,P,P,P,P,P,P,P,P,P
};

