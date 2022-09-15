pub const c = @cImport({
    @cInclude("binaryen-c.h");
});

pub const Index = c.BinaryenIndex;
pub const Op = c.BinaryenOp;
pub const Type = c.BinaryenType;

pub fn addInt32() Op {
    return c.BinaryenAddInt32();
}

pub fn typeInt32() Type {
    return c.BinaryenTypeInt32();
}

pub fn typeCreate(value_types: []Type) Type {
    return c.BinaryenTypeCreate(value_types.ptr, @intCast(u32, value_types.len));
}

pub const Module = opaque {
    pub fn fromC(module: c.BinaryenModuleRef) *Module {
        return @ptrCast(*Module, module);
    }

    pub fn toC(self: *Module) c.BinaryenModuleRef {
        return @ptrCast(c.BinaryenModuleRef, self);
    }

    pub fn init() *Module {
        return fromC(c.BinaryenModuleCreate());
    }

    pub fn deinit(self: *Module) void {
        c.BinaryenModuleDispose(self.toC());
    }

    pub fn addFunction(self: *Module, name: []const u8, params: Type, results: Type, var_types: ?[]Type, body: *Expression) *Function {
        return Function.fromC(c.BinaryenAddFunction(
            self.toC(),
            name.ptr,
            params,
            results,
            if (var_types) |v| v.ptr else null,
            if (var_types) |v| @intCast(u32, v.len) else 0,
            body.toC(),
        ));
    }

    pub fn print(self: *Module) void {
        c.BinaryenModulePrint(self.toC());
    }

    pub fn makeLocalGet(self: *Module, index: Index, type_: Type) *Expression {
        return Expression.fromC(c.BinaryenLocalGet(self.toC(), index, type_));
    }

    pub fn makeBinary(self: *Module, op: Op, left: *Expression, right: *Expression) *Expression {
        return Expression.fromC(c.BinaryenBinary(self.toC(), op, left.toC(), right.toC()));
    }
};

pub const Expression = opaque {
    pub fn fromC(expression: c.BinaryenExpressionRef) *Expression {
        return @ptrCast(*Expression, expression);
    }

    pub fn toC(self: *Expression) c.BinaryenExpressionRef {
        return @ptrCast(c.BinaryenExpressionRef, self);
    }
};

pub const Function = opaque {
    pub fn fromC(function: c.BinaryenFunctionRef) *Function {
        return @ptrCast(*Function, function);
    }

    pub fn toC(self: *Function) c.BinaryenFunctionRef {
        return @ptrCast(c.BinaryenExpressionRef, self);
    }
};
