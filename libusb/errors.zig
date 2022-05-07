
pub const arrError = [_]anyerror {
    error.IO,
    error.INVALID_PARAM,
    error.ACCESS,
    error.NO_DEVICE,
    error.NOT_FOUND,
    error.BUSY,
    error.TIMEOUT,
    error.OVERFLOW,
    error.PIPE,
    error.INTERRUPTED,
    error.NO_MEM,
    error.NOT_SUPPORTED,
    error.OTHER,
};
