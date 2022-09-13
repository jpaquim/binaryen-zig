const std = @import("std");

const binaryen = @cImport({
    @cInclude("binaryen-c.h");
});

pub fn main() anyerror!void {
    const module = binaryen.BinaryenModuleCreate();

    defer binaryen.BinaryenModuleDispose(module);

    var ii = [_]binaryen.BinaryenType{binaryen.BinaryenTypeInt32(), binaryen.BinaryenTypeInt32()};
    const params = binaryen.BinaryenTypeCreate(@ptrCast([*c]usize, &ii), 2);
    const results = binaryen.BinaryenTypeInt32();

    const x = binaryen.BinaryenLocalGet(module, 0, binaryen.BinaryenTypeInt32());
    const y = binaryen.BinaryenLocalGet(module, 1, binaryen.BinaryenTypeInt32());

    const add = binaryen.BinaryenBinary(module, binaryen.BinaryenAddInt32(), x, y);

    const adder = binaryen.BinaryenAddFunction(module, "adder", params, results, null, 0, add);
    _ = adder;

    binaryen.BinaryenModulePrint(module);
}
