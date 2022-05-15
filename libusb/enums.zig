const ClassCode = enum(c_int) {
    PER_INTERFACE = 0,
    AUDIO = 1,
    COMM = 2,
    HID = 3,
    PHYSICAL = 5,
    PRINTER = 7,
    PTP = 6,
    IMAGE = 6,
    MASS_STORAGE = 8,
    HUB = 9,
    DATA = 10,
    SMART_CARD = 11,
    CONTENT_SECURITY = 13,
    VIDEO = 14,
    PERSONAL_HEALTHCARE = 15,
    DIAGNOSTIC_DEVICE = 220,
    WIRELESS = 224,
    APPLICATION = 254,
    VENDOR_SPEC = 255,
};

const TransferType = enum(c_int) {
    CONTROL = 0,
    ISOCHRONOUS = 1,
    BULK = 2,
    INTERRUPT = 3,
    BULK_STREAM = 4,
};

const StandardRequest = enum(c_int) {
    GET_STATUS = 0,
    CLEAR_FEATURE = 1,
    SET_FEATURE = 3,
    SET_ADDRESS = 5,
    GET_DESCRIPTOR = 6,
    SET_DESCRIPTOR = 7,
    GET_CONFIGURATION = 8,
    SET_CONFIGURATION = 9,
    GET_INTERFACE = 10,
    SET_INTERFACE = 11,
    SYNCH_FRAME = 12,
    SET_SEL = 48,
    SET_ISOCH_DELAY = 49,
};

const RequestType = enum(u8) {
    STANDARD = 0,
    CLASS = 32,
    VENDOR = 64,
    RESERVED = 96,
};

const RequestRecipient = enum(c_int) {
    DEVICE = 0,
    INTERFACE = 1,
    ENDPOINT = 2,
    OTHER = 3,
};

const IsoSyncType = enum(c_int) {
    NONE = 0,
    ASYNC = 1,
    ADAPTIVE = 2,
    SYNC = 3,
};

const IsoUsageType = enum(c_int) {
    DATA = 0,
    FEEDBACK = 1,
    IMPLICIT = 2,
};


const Descriptor = extern union {
    const Type = extern enum(u8) {
        DEVICE = 1,
        CONFIG = 2,
        STRING = 3,
        INTERFACE = 4,
        ENDPOINT = 5,
        BOS = 15,
        DEVICE_CAPABILITY = 16,
        HID = 33,
        REPORT = 34,
        PHYSICAL = 35,
        HUB = 41,
        SUPERSPEED_HUB = 42,
        SS_ENDPOINT_COMPANION = 48,
    };
}
