const TexturePack = @import("main.zig").TexturePack;
const t = 0x00000000;
const W = 0xffffffff;
const B = 0x11000000;

const _actorsprites = [_][32*32]const u32 {
    {
        t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,t,t,t,W,W,W,W,W,W,W,W,W,W,t,t,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,t,W,W,W,W,W,W,W,W,W,W,W,W,W,t,t,W,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,W,W,W,t,t,t,t,t,t,t,t,t,W,W,W,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,W,W,W,t,t,t,t,t,t,t,t,t,t,t,t,W,W,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,W,W,W,t,t,t,W,W,t,t,t,t,W,W,t,t,W,W,t,t,t,t,t,t,t,t,t,
        t,t,t,t,W,W,W,t,t,t,W,t,W,t,t,t,t,W,W,W,t,t,W,W,t,t,t,t,t,t,t,t,
        t,t,t,t,W,W,t,t,t,t,W,t,t,W,t,t,W,W,t,t,W,W,W,W,t,t,t,t,W,t,t,t,
        t,t,t,t,W,W,t,t,t,W,t,t,t,W,W,t,W,t,t,t,t,W,t,W,t,t,t,t,t,t,t,t,
        t,t,t,t,W,W,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,W,W,t,t,t,t,t,t,t,t,
        t,t,t,t,W,W,W,t,t,t,t,t,W,W,t,t,t,t,W,W,t,t,W,W,t,t,t,t,t,t,t,t,
        t,t,t,t,W,W,W,t,t,t,t,t,t,W,W,W,W,W,W,t,t,W,W,W,t,t,t,t,t,t,t,t,
        t,t,t,t,t,W,W,W,W,t,t,t,t,t,t,t,t,t,t,t,W,W,W,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,t,t,W,W,W,W,W,W,W,W,W,W,W,t,t,t,t,t,t,W,t,t,t,t,t,
        t,t,t,t,t,t,t,t,t,t,W,W,t,t,t,t,t,W,W,t,t,t,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,t,t,t,W,W,t,t,t,t,t,W,W,t,t,t,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,t,t,t,W,W,t,t,t,t,t,W,W,t,t,t,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,t,t,t,W,W,t,t,W,W,W,W,W,t,t,t,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,t,t,t,W,W,W,W,W,W,W,W,W,t,t,t,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,t,t,t,W,W,W,W,t,t,t,W,W,t,t,t,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,t,t,t,W,W,t,t,t,t,t,W,W,t,t,t,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,t,t,t,W,W,t,t,t,t,t,W,W,t,t,t,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,t,t,t,W,W,W,W,t,t,t,W,W,W,W,t,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,t,t,t,W,W,W,W,t,t,t,W,W,W,W,t,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t
    },
    {
        t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,t,t,t,W,W,W,W,W,W,W,W,W,W,t,t,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,t,W,W,W,W,W,W,W,W,W,W,W,W,W,t,t,W,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,W,W,W,t,t,t,t,t,t,t,t,t,W,W,W,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,W,W,W,t,t,t,t,t,t,t,t,t,t,t,t,W,W,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,W,W,W,t,t,t,W,W,t,t,t,t,W,W,t,t,W,W,t,t,t,t,t,t,t,t,t,
        t,t,t,t,W,W,W,t,t,t,W,t,W,t,t,t,t,W,W,W,t,t,W,W,t,t,t,t,t,t,t,t,
        t,t,t,t,W,W,t,t,t,t,W,t,t,W,t,t,W,W,t,t,W,W,W,W,t,t,t,t,W,t,t,t,
        t,t,t,t,W,W,t,t,t,W,t,t,t,W,W,t,W,t,t,t,t,W,t,W,t,t,t,t,t,t,t,t,
        t,t,t,t,W,W,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,W,W,t,t,t,t,t,t,t,t,
        t,t,t,t,W,W,W,t,t,t,t,t,W,W,t,t,t,t,W,W,t,t,W,W,t,t,t,t,t,t,t,t,
        t,t,t,t,W,W,W,t,t,t,t,t,t,W,W,W,W,W,W,t,t,W,W,W,t,t,t,t,t,t,t,t,
        t,t,t,t,t,W,W,W,W,t,t,t,t,t,t,t,t,t,t,t,W,W,W,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,t,t,W,W,W,W,W,W,W,W,W,W,W,t,t,t,t,t,t,W,t,t,t,t,t,
        t,t,t,t,t,t,t,t,t,t,W,W,t,t,t,t,t,W,W,t,t,t,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,t,t,t,W,W,t,t,t,t,t,W,W,t,t,t,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,t,t,W,W,t,t,t,t,t,t,W,W,t,t,t,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,t,t,W,W,t,t,t,W,W,W,W,W,t,t,t,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,t,t,W,W,W,W,W,W,W,W,W,W,W,t,t,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,t,W,W,W,W,W,W,t,t,t,t,W,W,t,t,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,W,W,W,W,t,t,t,t,t,t,t,t,t,W,W,t,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,W,W,t,t,t,t,t,t,t,t,t,t,t,W,W,t,W,W,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,W,W,W,W,t,t,t,t,t,t,t,t,t,W,W,W,W,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,W,W,W,W,t,t,t,t,t,t,t,t,t,W,W,W,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,
        t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t
    }
};

pub fn ActorSprites() !TexturePack {
    var ActSpr = TexturePack.init();
    for _actorsprites |raw| {
        _ = try TexturePack.appendRaw(raw, 32, 32);
    }

    return ActSpr;
}
