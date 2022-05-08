
inline fn toError(err: c_int) anyerror{
    return @intToError(@bitCast(u16, @truncate(i16, -err)));
}
