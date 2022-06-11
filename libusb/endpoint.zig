pub const enums = @import("enums.zig");

pub const Endpoint = extern struct {
    pub const Direction = enum(u1) {
        IN = 1,
        OUT = 0,
    };

    pub const Address = packed struct {
        number: u4,
        reserved: u3,
        direction: Endpoint.Direction,
    };
    
    pub const Descriptor = extern struct {
        bLength: u8,
        bDescriptorType: enums.Descriptor.Type,
        bEndpointAddress: Address,
        bmAttributes: u8,
        wMaxPacketSize: u16,
        bInterval: u8,
        bRefresh: u8,
        bSynchAddress: u8,
        extra: [*]const u8,
        extra_length: c_int,
    };
    pub const SS_CompanionDescriptor = extern struct {
        bLength: u8,
        bDescriptorType: Descriptor.Type,
        bMaxBurst: u8,
        bmAttributes: u8,
        wBytesPerInterval: u16,
    };
};
