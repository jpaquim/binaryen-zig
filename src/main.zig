const std = @import("std");

const binaryen = @import("./binaryen.zig");
const Type = binaryen.Type;

pub fn main() anyerror!void {
    const module = binaryen.Module.init();
    defer module.deinit();

    var ii = [_]Type{ Type.int32(), Type.int32() };
    const params = Type.create(ii[0..]);
    const results = Type.int32();

    const x = module.makeLocalGet(0, Type.int32());
    const y = module.makeLocalGet(1, Type.int32());

    const add = module.makeBinary(binaryen.addInt32(), x, y);

    const adder = module.addFunction("adder", params, results, null, add);
    _ = adder;

    module.print();
}
