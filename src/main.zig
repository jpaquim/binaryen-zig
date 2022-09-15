const std = @import("std");

const binaryen = @import("./binaryen.zig");

pub fn main() anyerror!void {
    const module = binaryen.Module.init();
    defer module.deinit();

    var ii = [_]binaryen.Type{ binaryen.typeInt32(), binaryen.typeInt32() };
    const params = binaryen.typeCreate(ii[0..]);
    const results = binaryen.typeInt32();

    const x = module.makeLocalGet(0, binaryen.typeInt32());
    const y = module.makeLocalGet(1, binaryen.typeInt32());

    const add = module.makeBinary(binaryen.addInt32(), x, y);

    const adder = module.addFunction("adder", params, results, null, add);
    _ = adder;

    module.print();
}
