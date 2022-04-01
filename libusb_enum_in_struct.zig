
pub fn libusb_cpu_to_le16(x: u16) callconv(.C) u16 {
    const union_unnamed_2 = extern union {
        b8: [2]u8,
        b16: u16,
    };
    _ = union_unnamed_2;
    var _tmp: union_unnamed_2 = undefined;
    _tmp.b8[1] = @truncate(u8, x >> 8);
    _tmp.b8[0] = @truncate(u8, x & 0xFF);
    return _tmp.b16;
}
const ClassCode = extern enum(c_int) {
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




const TransferType = extern enum(c_int) {
    CONTROL = 0,
    ISOCHRONOUS = 1,
    BULK = 2,
    INTERRUPT = 3,
    BULK_STREAM = 4,
};

const StandardRequest = extern enum(c_int) {
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

const RequestType = extern enum(u8) {
    STANDARD = 0,
    CLASS = 32,
    VENDOR = 64,
    RESERVED = 96,
};

const RequestRecipient = extern enum(c_int) {
    DEVICE = 0,
    INTERFACE = 1,
    ENDPOINT = 2,
    OTHER = 3,
};

const IsoSyncType = extern enum(c_int) {
    NONE = 0,
    ASYNC = 1,
    ADAPTIVE = 2,
    SYNC = 3,
};

const IsoUsageType = extern enum(c_int) {
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

    Endpoint: [*c] Endpoint.Descriptorr,
    Device: [*c] Device.Descriptor,
    Interface: [*c] Interface.Descriptor,

};

const Endpoint = extern struct {
    const Direction = extern enum(u8) {
        IN = 128,
        OUT = 0,
    };
    const Descriptor = extern struct {

        bLength: u8,
        bDescriptorType: Descriptor.Type,
        bEndpointAddress: u8,
        bmAttributes: u8,
        wMaxPacketSize: u16,
        bInterval: u8,
        bRefresh: u8,
        bSynchAddress: u8,
        extra: [*c]const u8,
        extra_length: c_int,
    };
    const SS_CompanionDescriptor = extern struct {
        bLength: u8,
        bDescriptorType: Descriptor.Type,
        bMaxBurst: u8,
        bmAttributes: u8,
        wBytesPerInterval: u16,
    };
};

const Interface = extern struct {
    altsetting: [*c]const Interface.Descriptor,
    num_altsetting: c_int,

    pub const Descriptor = extern struct {
        bLength: u8,
        bDescriptorType: Descriptor.Type,
        bInterfaceNumber: u8,
        bAlternateSetting: u8,
        bNumEndpoints: u8,
        bInterfaceClass: ClassCode,
        bInterfaceSubClass: ClassCode,
        bInterfaceProtocol: u8,
        iInterface: u8,
        endpoint: [*c]const Endpoint.Descriptor,
        extra: [*c]const u8,
        extra_length: c_int,
    };
};

pub const Config = extern struct {
    const Descriptor = extern struct {
        bLength: u8,
        bDescriptorType: Descriptor.Type,
        wTotalLength: u16,
        bNumInterfaces: u8,
        bConfigurationValue: u8,
        iConfiguration: u8,
        bmAttributes: u8,
        MaxPower: u8,
        interface: [*c]const Interface,
        extra: [*c]const u8,
        extra_length: c_int,
    };
};


pub const BOS = extern struct {
    const Type = extern enum(c_uint) {
        WIRELESS_USB_DEVICE_CAPABILITY = 1,
        USB_2_0_EXTENSION = 2,
        SS_USB_DEVICE_CAPABILITY = 3,
        CONTAINER_ID = 4,
    };

    pub const DeviceCapability = extern struct {
        const Descriptor = extern struct {
            bLength: u8 align(1),
            bDescriptorType: Descriptor.Type,
            bDevCapabilityType: u8,
            dev_capability_data: [*c]u8,
        };
    };

    const Descriptor = extern struct {
        bLength: u8 align(8),
        bDescriptorType: Descriptor.Type,
        wTotalLength: u16,
        bNumDeviceCaps: u8,
        dev_capabilitty: [0]BOS.DeviceCapability.Descriptor,
    };
};

pub const USB_2_0_Extension = extern struct {
    const Descriptor = extern struct {
        bLength: u8,
        bDescriptorType: Descriptor.Type,
        bDevCapabilityType: u8,
        bmAttributes: u32,
    };
    const Attributes = extern enum(u8) {
        BM_LPM_SUPPORT  = 2;
    };
};

pub const SS_DeviceCapability = extern struct {
    const Descriptor = extern struct {
        bLength: u8,
        bDescriptorType: Descriptor.Type,
        bDevCapabilityType: u8,
        bmAttributes: u8,
        wSpeedSupported: u16,
        bFunctionalitySupport: u8,
        bU1DevExitLat: u8,
        bU2DevExitLat: u16,
    };
    const Attributes = extern enum(c_uint) {
        BM_LTM_SUPPORT = 2,
    };
};

pub const ContainerID = extern struct {
    const Descriptor = extern struct {
        bLength: u8,
        bDescriptorType: Descriptor.Type,
        bDevCapabilityType: u8,
        bReserved: u8,
        ContainerID: [16]u8,
    };
};

pub const ControlSetup = extern struct {
    bmRequestType: RequestType,
    bRequest: u8,
    wValue: u16,
    wIndex: u16,
    wLength: u16,
};

const Context = opaque {

    pub fn init(*Context) !*Context {
        var optional_ctx: ?*Context = null;
        var res = libusb_init (&optional_ctx);
        if (optional_ctx) |ctx|
            return if (res < 0) @intToError(res) else ctx
        else 
            return error.NULL_CONTEXT;
   }

    pub fn setDebug(ctx: *Context, level: Log.Level) void {
        libusb_set_debug( ctx, @enumToInt(level) );
    }

    pub fn setLogCb(ctx: *Context, cb: Log.CallBack.Fn, mode: Log.CallBack.Mode) void {
        libusb_set_log_cb(ctx, cb, @enumToInt(mode));
    }

// extern fn libusb_get_device_list(ctx: *Context, list: [*c][*c]?Device) isize
    pub fn getDeviceList(ctx: *Context) ![]*Device {
        var optional_arr: ?[*]*Device = null;
        var res = libusb_get_device_list(ctx, &optional_arr);
        if (optional_arr) |arr|
            return if (res >= 0) arr[0..res] else @intToError( @bitCast(u16, @truncate(i16, res)) )
        else
            return error.NULL_DEVICELIST;
    }
    
//     extern fn libusb_get_port_path(ctx: *Context, dev: ?Device, path: [*c]u8, path_length: u8) c_int
    //const getPortPath(ctx: *Context, dev: ?Device, path: [*c]u8, path_length: u8)  = libusb_get_port_path;
    pub fn wrapSysDevice(ctx: *Context, sys_dev: isize) !void {
        var hdl: [*c]?DeviceHandle = undefined;
        var res = libusb_wrap_sys_device(ctx, sys_dev, hdl);
        return if (res < 0) @intToError(res) else res;
    }
    
    pub fn openDeviceWithVidPid(ctx: *Context, vendor_id: u16, product_id: u16) !DeviceHandle {
        var dev_handle = libusb_open_device_with_vid_pid(ctx, vendor_id, product_id);
        return if (dev_handle) dev_handle else error.OpenError;
    }

    const exit = libusb_exit;
// extern fn libusb_try_lock_events(ctx: *Context) c_int
    const tryLockEvents = libusb_try_lock_events;
//     extern fn libusb_lock_events(ctx: *Context) void
    const lockEvents = libusb_lock_events;
//     extern fn libusb_unlock_events(ctx: *Context) void
    const unlockEvents = libusb_unlock_events;
//     extern fn libusb_event_handling_ok(ctx: *Context) c_int
    const eventHandlingOk = libusb_event_handling_ok;
//     extern fn libusb_event_handler_active(ctx: *Context) c_int
    const eventHandlerActive = libusb_event_handler_active;
//     extern fn libusb_interrupt_event_handler(ctx: *Context) void
    const interruptEventHandler = libusb_interrupt_event_handler;
//     extern fn libusb_lock_event_waiters(ctx: *Context) void
    const lockEventWaiters = libusb_lock_event_waiters;
//     extern fn libusb_unlock_event_waiters(ctx: *Context) void
    const unlockEventWaiters = libusb_unlock_event_waiters;
//     extern fn libusb_wait_for_event(ctx: *Context, tv: [*c]struct_timeval) c_int
    const waitForEvent = libusb_wait_for_event;
//     extern fn libusb_handle_events_timeout(ctx: *Context, tv: [*c]struct_timeval) c_int
    const handleEventsTimeout = libusb_handle_events_timeout;
//     extern fn libusb_handle_events_timeout_completed(ctx: *Context, tv: [*c]struct_timeval, completed: [*c]c_int) c_int
    const handleEventsTimeoutCompleted = libusb_handle_events_timeout_completed;
//     extern fn libusb_handle_events(ctx: *Context) c_int
    const handleEvents = libusb_handle_events;
//     extern fn libusb_handle_events_completed(ctx: *Context, completed: [*c]c_int) c_int
    const handleEventsCompleted = libusb_handle_events_completed;
//     extern fn libusb_handle_events_locked(ctx: *Context, tv: [*c]struct_timeval) c_int
    const handleEventsLocked = libusb_handle_events_locked;
//     extern fn libusb_pollfds_handle_timeouts(ctx: *Context) c_int
    const pollfdsHandleTimeouts = libusb_pollfds_handle_timeouts;
//     extern fn libusb_get_next_timeout(ctx: *Context, tv: [*c]struct_timeval) c_int
    const getNextTimeout = libusb_get_next_timeout;
//     extern fn libusb_get_pollfds(ctx: *Context) [*c][*c]const struct_libusb_pollfd
    const getPollfds = libusb_get_pollfds;
//     extern fn libusb_set_pollfd_notifiers(ctx: *Context, added_cb: libusb_pollfd_added_cb, removed_cb: libusb_pollfd_removed_cb, user_data: ?*anyopaque) void
    const setPollfdNotifiers = libusb_set_pollfd_notifiers;
//     extern fn libusb_hotplug_register_callback(ctx: *Context, events: libusb_hotplug_event, flags: libusb_hotplug_flag, vendor_id: c_int, product_id: c_int, dev_class: c_int, cb_fn: libusb_hotplug_callback_fn, user_data: ?*anyopaque, callback_handle: [*c]libusb_hotplug_callback_handle) c_int
    const hotplugRegisterCallback = libusb_hotplug_register_callback;
//     extern fn libusb_hotplug_deregister_callback(ctx: *Context, callback_handle: libusb_hotplug_callback_handle) void
    const hotplugDeregisterCallback = libusb_hotplug_deregister_callback;
//     extern fn libusb_set_option(ctx: *Context, option: enum_Option, ...) c_int
    const setOption = libusb_set_option;
};


const struct_Device= opaque {};
const Device = *opaque {
    const Descriptor = extern struct {
        bLength: u8,
        bDescriptorType: Descriptor.Type,
        bcdUSB: u16,
        bDeviceClass: u8,
        bDeviceSubClass: u8,
        bDeviceProtocol: u8,
        bMaxPacketSize0: u8,
        idVendor: u16,
        idProduct: u16,
        bcdDevice: u16,
        iManufacturer: u8,
        iProduct: u8,
        iSerialNumber: u8,
        bNumConfigurations: u8,
    };

    const refDevice = extern fn libusb_ref_device(dev: Device) Device;
    const unrefDevice = extern fn libusb_unref_device(dev: Device) void;
    const getDeviceDescriptor = extern fn libusb_get_device_descriptor(dev: Device, desc: [*c]Device.Descriptor) c_int;
    const getActiveConfigDescriptor = extern fn libusb_get_active_config_descriptor(dev: Device, config: [*c][*c]Config.Descriptor) c_int;
    const getConfigDescriptor = extern fn libusb_get_config_descriptor(dev: Device, config_index: u8, config: [*c][*c]Config.Descriptor) c_int;
    const getConfigDescriptorByValue = extern fn libusb_get_config_descriptor_by_value(dev: Device, bConfigurationValue: u8, config: [*c][*c]Config.Descriptor) c_int;
    const getBusNumber = extern fn libusb_get_bus_number(dev: Device) u8;
    const getPortNumber = extern fn libusb_get_port_number(dev: Device) u8;
    const getPortNumbers = extern fn libusb_get_port_numbers(dev: Device, port_numbers: [*c]u8, port_numbers_len: c_int) c_int;
    const getParent = extern fn libusb_get_parent(dev: Device) Device;
    const getDeviceAddress = extern fn libusb_get_device_address(dev: Device) u8;
    const getDeviceSpeed = extern fn libusb_get_device_speed(dev: Device) c_int;
    const getMaxPacketSize = extern fn libusb_get_max_packet_size(dev: Device, endpoint: u8) c_int;
    const getMaxIsoPacketSize = extern fn libusb_get_max_iso_packet_size(dev: Device, endpoint: u8) c_int;
    const open = extern fn libusb_open(dev: Device, dev_handle: [*c]?DeviceHandle) c_int;
};


pub const DeviceHandle = opaque {};
const DeviceHandle = *opaque {

    const getConfiguration = extern fn libusb_get_configuration(dev: DeviceHandle, config: [*c]c_int) c_int;
    const getBosDescriptor = extern fn libusb_get_bos_descriptor(dev_handle: DeviceHandle, bos: [*c][*c]BOS.Descriptor) c_int;
    const close = extern fn libusb_close(dev_handle: DeviceHandle) void;
    const getDevice = extern fn libusb_get_device(dev_handle: DeviceHandle) ?Device;
    const setConfiguration = extern fn libusb_set_configuration(dev_handle: DeviceHandle, configuration: c_int) c_int;
    const claimInterface = extern fn libusb_claim_interface(dev_handle: DeviceHandle, interface_number: c_int) c_int;
    const releaseInterface = extern fn libusb_release_interface(dev_handle: DeviceHandle, interface_number: c_int) c_int;
    const setInterfaceAltSetting = extern fn libusb_set_interface_alt_setting(dev_handle: DeviceHandle, interface_number: c_int, alternate_setting: c_int) c_int;
    const clearHalt = extern fn libusb_clear_halt(dev_handle: DeviceHandle, endpoint: u8) c_int;
    const resetDevice = extern fn libusb_reset_device(dev_handle: DeviceHandle) c_int;
    const allocStreams = extern fn libusb_alloc_streams(dev_handle: DeviceHandle, num_streams: u32, endpoints: [*c]u8, num_endpoints: c_int) c_int;
    const freeStreams = extern fn libusb_free_streams(dev_handle: DeviceHandle, endpoints: [*c]u8, num_endpoints: c_int) c_int;
    const devMemAlloc = extern fn libusb_dev_mem_alloc(dev_handle: DeviceHandle, length: usize) [*c]u8;
    const devMemFree = extern fn libusb_dev_mem_free(dev_handle: DeviceHandle, buffer: [*c]u8, length: usize) c_int;
    const kernelDriverActive = extern fn libusb_kernel_driver_active(dev_handle: DeviceHandle, interface_number: c_int) c_int;
    const detachKernelDriver = extern fn libusb_detach_kernel_driver(dev_handle: DeviceHandle, interface_number: c_int) c_int;
    const attachKernelDriver = extern fn libusb_attach_kernel_driver(dev_handle: DeviceHandle, interface_number: c_int) c_int;
    const setAutoDetachKernelDriver = extern fn libusb_set_auto_detach_kernel_driver(dev_handle: DeviceHandle, enable: c_int) c_int;
    const controlTransfer = extern fn libusb_control_transfer(dev_handle: DeviceHandle, request_type: RequestType, bRequest: u8, wValue: u16, wIndex: u16, data: [*c]u8, wLength: u16, timeout: c_uint) c_int;
    const bulkTransfer = extern fn libusb_bulk_transfer(dev_handle: DeviceHandle, endpoint: u8, data: [*c]u8, length: c_int, actual_length: [*c]c_int, timeout: c_uint) c_int;
    const interruptTransfer = extern fn libusb_interrupt_transfer(dev_handle: DeviceHandle, endpoint: u8, data: [*c]u8, length: c_int, actual_length: [*c]c_int, timeout: c_uint) c_int;
    const getStringDescriptorAscii = extern fn libusb_get_string_descriptor_ascii(dev_handle: ?DeviceHandle, desc_index: u8, data: [*c]u8, length: c_int) c_int;

    const getDescriptor = libusb_get_descriptor;
    fn libusb_get_descriptor(arg_dev_handle: ?DeviceHandle, arg_desc_type: u8, arg_desc_index: u8, arg_data: [*c]u8, arg_length: c_int) callconv(.C) c_int {
        var dev_handle = arg_dev_handle;
        var desc_type = arg_desc_type;
        var desc_index = arg_desc_index;
        var data = arg_data;
        var length = arg_length;
        return libusb_control_transfer(dev_handle, Endpoint.Direction.IN, StandardRequest.GET_DESCRIPTOR, (@as(c_ushort, desc_type) <<  8) | @as(c_ushort, desc_index), @as(c_ushort, 0), data, @truncate(u16, length),  1000);
    }

    const getStringDescriptor = libusb_get_string_descriptor;
    fn libusb_get_string_descriptor(arg_dev_handle: ?DeviceHandle, arg_desc_index: u8, arg_langid: u16, arg_data: [*c]u8, arg_length: c_int) callconv(.C) c_int {
        var dev_handle = arg_dev_handle;
        var desc_index = arg_desc_index;
        var langid = arg_langid;
        var data = arg_data;
        var length = arg_length;
        return libusb_control_transfer(dev_handle, Endpoint.Direction.IN, @enumToInt(StandardRequest.GET_DESCRIPTOR), @as(u16, @enumToInt(Descriptor.Type.STRINGi) <<  8) |  @as(u16, desc_index), langid, data, @bitCast(u16, @truncate(c_short, length)),  1000);
    }
};




pub const struct_libusb_version = extern struct {
    major: u16,
    minor: u16,
    micro: u16,
    nano: u16,
    rc: [*c]const u8,
    describe: [*c]const u8,
};
pub const *Context= struct_Context;
pub const Device= struct_Device;
pub const DeviceHandle = DeviceHandle;

pub const Speed = extern enum(c_uint) {
    UNKNOWN = 0,
    LOW = 1,
    FULL = 2,
    HIGH = 3,
    SUPER = 4,
    SUPER_PLUS = 5,
};

pub const SupportedSpeed = extern enum(c_ushort) {
    LOW_SPEED_OPERATION = 1,
    FULL_SPEED_OPERATION = 2,
    HIGH_SPEED_OPERATION = 4,
    SUPER_SPEED_OPERATION = 8,
};

const ushort_max: u16 = 0xFFFF;
pub const SUCCESS: c_int = 0;
pub const IO = @intToError(ushort_max-1);
pub const INVALID_PARAM = @intToError(ushort_max-2);
pub const ACCESS = @intToError(ushort_max-3);
pub const NO_DEVICE = @intToError(ushort_max-4);
pub const NOT_FOUND = @intToError(ushort_max-5);
pub const BUSY = @intToError(ushort_max-6);
pub const TIMEOUT = @intToError(ushort_max-7);
pub const OVERFLOW = @intToError(ushort_max-8);
pub const PIPE = @intToError(ushort_max-9);
pub const INTERRUPTED = @intToError(ushort_max-10);
pub const NO_MEM = @intToError(ushort_max-11);
pub const NOT_SUPPORTED = @intToError(ushort_max-12);
pub const OTHER = @intToError(ushort_max-99);
pub const ERROR = (IO || INVALID_PARAM || ACCESS || NO_DEVICE || NOT_FOUND || BUSY || TIMEOUT || OVERFLOW || PIPE || INTERRUPTED || NO_MEM || NOT_SUPPORTED || OTHER );

pub const TransferStatus = extern enum(c_uint) {
    COMPLETED = 0,
    ERROR = 1,
    TIMED_OUT = 2,
    CANCELLED = 3,
    STALL = 4,
    NO_DEVICE = 5,
    OVERFLOW = 6,
};

pub const TransferFlags = extern enum(c_uint) {
    SHORT_NOT_OK = 1,
    FREE_BUFFER = 2,
    FREE_TRANSFER = 4,
    ADD_ZERO_PACKET = 8,
};

pub const IsoPacket = extern struct {
    Descriptor = extern struct {
        length: c_uint,
        actual_length: c_uint,
        status: TransferStatus,
    };
};

pub const Transfer = extern struct {

    const CB_Fn = ?fn ([*c]Transfer) callconv(.C) void;

    dev_handle: ?DeviceHandle align(8),
    flags: u8,
    endpoint: u8,
    @"type": u8,
    timeout: c_uint,
    status: TransferStatus,
    length: c_int,
    actual_length: c_int,
    callback: CB_Fn,
    user_data: ?*anyopaque,
    buffer: [*c]u8,
    num_iso_packets: c_int,
    iso_packet_desc: [*c]IsoPacket,

};

pub const Capability = extern enum(c_uint) {
    HAS_CAPABILITY = 0,
    HAS_HOTPLUG = 1,
    HAS_HID_ACCESS = 256,
    SUPPORTS_DETACH_KERNEL_DRIVER = 257,
};

pub const Log = struct {
    pub const Level = extern enum(c_int) {
        NONE = 0,
        ERROR = 1,
        WARNING = 2,
        INFO = 3,
        DEBUG = 4,
    };

    pub const CallBack = struct {
        pub const Mode = extern enum(c_int) {
            GLOBAL = 1,
            CONTEXT = 2,
        };

        pub const Fn = extern ?fn (?*Context, Log.Level, [*c]const u8) callconv(.C) void;
    };
};

pub const libusb_log_cb = ?fn (?*Context, Log.Level, [*c]const u8) callconv(.C) void;
pub extern fn libusb_init(ctx: [*c]?*Context) c_int;
pub extern fn libusb_exit(ctx: ?*Context) void;
pub extern fn libusb_set_debug(ctx: ?*Context, level: c_int) void;
pub extern fn libusb_set_log_cb(ctx: ?*Context, cb: libusb_log_cb, mode: c_int) void;
pub extern fn libusb_get_version() [*c]const struct_libusb_version;
pub extern fn libusb_has_capability(capability: u32) c_int;
pub extern fn libusb_error_name(errcode: c_int) [*c]const u8;
pub extern fn libusb_setlocale(locale: [*c]const u8) c_int;
pub extern fn libusb_strerror(errcode: enum_Error) [*c]const u8;
pub extern fn libusb_get_device_list(ctx: ?*Context, list: [*c][*c]?Device) isize;
pub extern fn libusb_free_device_list(list: [*c]?Device, unref_devices: c_int) void;
pub extern fn libusb_ref_device(dev: ?Device) ?Device;
pub extern fn libusb_unref_device(dev: ?Device) void;
pub extern fn libusb_get_configuration(dev: ?DeviceHandle, config: [*c]c_int) c_int;
pub extern fn libusb_get_device_descriptor(dev: ?Device, desc: [*c]struct_Device.Descriptor) c_int;
pub extern fn libusb_get_active_config_descriptor(dev: ?Device, config: [*c][*c]Config.Descriptor) c_int;
pub extern fn libusb_get_config_descriptor(dev: ?Device, config_index: u8, config: [*c][*c]Config.Descriptor) c_int;
pub extern fn libusb_get_config_descriptor_by_value(dev: ?Device, bConfigurationValue: u8, config: [*c][*c]Config.Descriptor) c_int;
pub extern fn libusb_free_config_descriptor(config: [*c]Config.Descriptor) void;
pub extern fn libusb_get_ss_endpoint_companion_descriptor(ctx: ?*struct_Context, endpoint: [*c]const Endpoint.Descriptor, ep_comp: [*c][*c]Endpoin.SS_CompanionDescriptor) c_int;
pub extern fn libusb_free_ss_endpoint_companion_descriptor(ep_comp: [*c]Endpoin.SS_CompanionDescriptor) void;
pub extern fn libusb_get_bos_descriptor(dev_handle: ?DeviceHandle, bos: [*c][*c]BOS.Descriptor) c_int;
pub extern fn libusb_free_bos_descriptor(bos: [*c]BOS.Descriptor) void;
pub extern fn libusb_get_usb_2_0_extension_descriptor(ctx: ?*struct_Context, dev_cap: [*c]BOS.DeviceCapability.Descriptor, usb_2_0_extension: [*c][*c]USB_2_0_Extension.Descriptor) c_int;
pub extern fn libusb_free_usb_2_0_extension_descriptor(usb_2_0_extension: [*c]USB_2_0_Extension.Descriptor) void;
pub extern fn libusb_get_ss_usb_device_capability_descriptor(ctx: ?*struct_Context, dev_cap: [*c]BOS.DeviceCapability.Descriptor, ss_usb_device_cap: [*c][*c]SS_DeviceCapability.Descriptor) c_int;
pub extern fn libusb_free_ss_usb_device_capability_descriptor(ss_usb_device_cap: [*c]SS_DeviceCapability.Descriptor) void;
pub extern fn libusb_get_container_id_descriptor(ctx: ?*struct_Context, dev_cap: [*c]BOS.DeviceCapability.Descriptor, container_id: [*c][*c]ContainerID.Descriptor) c_int;
pub extern fn libusb_free_container_id_descriptor(container_id: [*c]ContainerID.Descriptor) void;
pub extern fn libusb_get_bus_number(dev: ?Device) u8;
pub extern fn libusb_get_port_number(dev: ?Device) u8;
pub extern fn libusb_get_port_numbers(dev: ?Device, port_numbers: [*c]u8, port_numbers_len: c_int) c_int;
pub extern fn libusb_get_port_path(ctx: ?*Context, dev: ?Device, path: [*c]u8, path_length: u8) c_int;
pub extern fn libusb_get_parent(dev: ?Device) ?Device;
pub extern fn libusb_get_device_address(dev: ?Device) u8;
pub extern fn libusb_get_device_speed(dev: ?Device) c_int;
pub extern fn libusb_get_max_packet_size(dev: ?Device, endpoint: u8) c_int;
pub extern fn libusb_get_max_iso_packet_size(dev: ?Device, endpoint: u8) c_int;
pub extern fn libusb_wrap_sys_device(ctx: ?*Context, sys_dev: isize, dev_handle: [*c]?DeviceHandle) c_int;
pub extern fn libusb_open(dev: ?Device, dev_handle: [*c]?DeviceHandle) c_int;
pub extern fn libusb_close(dev_handle: ?DeviceHandle) void;
pub extern fn libusb_get_device(dev_handle: ?DeviceHandle) ?Device;
pub extern fn libusb_set_configuration(dev_handle: ?DeviceHandle, configuration: c_int) c_int;
pub extern fn libusb_claim_interface(dev_handle: ?DeviceHandle, interface_number: c_int) c_int;
pub extern fn libusb_release_interface(dev_handle: ?DeviceHandle, interface_number: c_int) c_int;
pub extern fn libusb_open_device_with_vid_pid(ctx: ?*Context, vendor_id: u16, product_id: u16) ?DeviceHandle;
pub extern fn libusb_set_interface_alt_setting(dev_handle: ?DeviceHandle, interface_number: c_int, alternate_setting: c_int) c_int;
pub extern fn libusb_clear_halt(dev_handle: ?DeviceHandle, endpoint: u8) c_int;
pub extern fn libusb_reset_device(dev_handle: ?DeviceHandle) c_int;
pub extern fn libusb_alloc_streams(dev_handle: ?DeviceHandle, num_streams: u32, endpoints: [*c]u8, num_endpoints: c_int) c_int;
pub extern fn libusb_free_streams(dev_handle: ?DeviceHandle, endpoints: [*c]u8, num_endpoints: c_int) c_int;
pub extern fn libusb_dev_mem_alloc(dev_handle: ?DeviceHandle, length: usize) [*c]u8;
pub extern fn libusb_dev_mem_free(dev_handle: ?DeviceHandle, buffer: [*c]u8, length: usize) c_int;
pub extern fn libusb_kernel_driver_active(dev_handle: ?DeviceHandle, interface_number: c_int) c_int;
pub extern fn libusb_detach_kernel_driver(dev_handle: ?DeviceHandle, interface_number: c_int) c_int;
pub extern fn libusb_attach_kernel_driver(dev_handle: ?DeviceHandle, interface_number: c_int) c_int;
pub extern fn libusb_set_auto_detach_kernel_driver(dev_handle: ?DeviceHandle, enable: c_int) c_int;
pub fn libusb_control_transfer_get_data(arg_transfer: [*c]Transfer) callconv(.C) [*c]u8 {
    var transfer = arg_transfer;
    return transfer.*.buffer + @sizeOf(struct_libusb_control_setup);
}
pub fn libusb_control_transfer_get_setup(arg_transfer: [*c]Transfer) callconv(.C) [*c]struct_libusb_control_setup {
    var transfer = arg_transfer;
    return @ptrCast([*c]struct_libusb_control_setup, @alignCast(@import("std").meta.alignment(struct_libusb_control_setup), @ptrCast(?*anyopaque, transfer.*.buffer)));
}
pub fn libusb_fill_control_setup(arg_buffer: [*c]u8, arg_bmRequestType: u8, arg_bRequest: u8, arg_wValue: u16, arg_wIndex: u16, arg_wLength: u16) callconv(.C) void {
    var buffer = arg_buffer;
    var bmRequestType = arg_bmRequestType;
    var bRequest = arg_bRequest;
    var wValue = arg_wValue;
    var wIndex = arg_wIndex;
    var wLength = arg_wLength;
    var setup: [*c]struct_libusb_control_setup = @ptrCast([*c]struct_libusb_control_setup, @alignCast(@import("std").meta.alignment(struct_libusb_control_setup), @ptrCast(?*anyopaque, buffer)));
    setup.*.bmRequestType = bmRequestType;
    setup.*.bRequest = bRequest;
    setup.*.wValue = libusb_cpu_to_le16(wValue);
    setup.*.wIndex = libusb_cpu_to_le16(wIndex);
    setup.*.wLength = libusb_cpu_to_le16(wLength);
}
pub extern fn libusb_alloc_transfer(iso_packets: c_int) [*c]Transfer;
pub extern fn libusb_submit_transfer(transfer: [*c]Transfer) c_int;
pub extern fn libusb_cancel_transfer(transfer: [*c]Transfer) c_int;
pub extern fn libusb_free_transfer(transfer: [*c]Transfer) void;
pub extern fn libusb_transfer_set_stream_id(transfer: [*c]Transfer, stream_id: u32) void;
pub extern fn libusb_transfer_get_stream_id(transfer: [*c]Transfer) u32;
pub fn libusb_fill_control_transfer(arg_transfer: [*c]Transfer, arg_dev_handle: ?DeviceHandle, arg_buffer: [*c]u8, arg_callback: libusb_transfer_cb_fn, arg_user_data: ?*anyopaque, arg_timeout: c_uint) callconv(.C) void {
    var transfer = arg_transfer;
    var dev_handle = arg_dev_handle;
    var buffer = arg_buffer;
    var callback = arg_callback;
    var user_data = arg_user_data;
    var timeout = arg_timeout;
    var setup: [*c]struct_libusb_control_setup = @ptrCast([*c]struct_libusb_control_setup, @alignCast(@import("std").meta.alignment(struct_libusb_control_setup), @ptrCast(?*anyopaque, buffer)));
    transfer.*.dev_handle = dev_handle;
    transfer.*.endpoint = 0;
    transfer.*.type = @bitCast(u8, @truncate(i8, TRANSFER_TYPE_CONTROL));
    transfer.*.timeout = timeout;
    transfer.*.buffer = buffer;
    if (setup != null) {
        transfer.*.length = @bitCast(c_int, @truncate(c_uint, @sizeOf(struct_libusb_control_setup) +% @bitCast(c_ulong, @as(c_ulong, libusb_cpu_to_le16(setup.*.wLength)))));
    }
    transfer.*.user_data = user_data;
    transfer.*.callback = callback;
}
pub fn libusb_fill_bulk_transfer(arg_transfer: [*c]Transfer, arg_dev_handle: ?DeviceHandle, arg_endpoint: u8, arg_buffer: [*c]u8, arg_length: c_int, arg_callback: libusb_transfer_cb_fn, arg_user_data: ?*anyopaque, arg_timeout: c_uint) callconv(.C) void {
    var transfer = arg_transfer;
    var dev_handle = arg_dev_handle;
    var endpoint = arg_endpoint;
    var buffer = arg_buffer;
    var length = arg_length;
    var callback = arg_callback;
    var user_data = arg_user_data;
    var timeout = arg_timeout;
    transfer.*.dev_handle = dev_handle;
    transfer.*.endpoint = endpoint;
    transfer.*.type = @bitCast(u8, @truncate(i8, TRANSFER_TYPE_BULK));
    transfer.*.timeout = timeout;
    transfer.*.buffer = buffer;
    transfer.*.length = length;
    transfer.*.user_data = user_data;
    transfer.*.callback = callback;
}
pub fn libusb_fill_bulk_stream_transfer(arg_transfer: [*c]Transfer, arg_dev_handle: ?DeviceHandle, arg_endpoint: u8, arg_stream_id: u32, arg_buffer: [*c]u8, arg_length: c_int, arg_callback: libusb_transfer_cb_fn, arg_user_data: ?*anyopaque, arg_timeout: c_uint) callconv(.C) void {
    var transfer = arg_transfer;
    var dev_handle = arg_dev_handle;
    var endpoint = arg_endpoint;
    var stream_id = arg_stream_id;
    var buffer = arg_buffer;
    var length = arg_length;
    var callback = arg_callback;
    var user_data = arg_user_data;
    var timeout = arg_timeout;
    libusb_fill_bulk_transfer(transfer, dev_handle, endpoint, buffer, length, callback, user_data, timeout);
    transfer.*.type = @bitCast(u8, @truncate(i8, TRANSFER_TYPE_BULK_STREAM));
    libusb_transfer_set_stream_id(transfer, stream_id);
}
pub fn libusb_fill_interrupt_transfer(arg_transfer: [*c]Transfer, arg_dev_handle: ?DeviceHandle, arg_endpoint: u8, arg_buffer: [*c]u8, arg_length: c_int, arg_callback: libusb_transfer_cb_fn, arg_user_data: ?*anyopaque, arg_timeout: c_uint) callconv(.C) void {
    var transfer = arg_transfer;
    var dev_handle = arg_dev_handle;
    var endpoint = arg_endpoint;
    var buffer = arg_buffer;
    var length = arg_length;
    var callback = arg_callback;
    var user_data = arg_user_data;
    var timeout = arg_timeout;
    transfer.*.dev_handle = dev_handle;
    transfer.*.endpoint = endpoint;
    transfer.*.type = @bitCast(u8, @truncate(i8, TRANSFER_TYPE_INTERRUPT));
    transfer.*.timeout = timeout;
    transfer.*.buffer = buffer;
    transfer.*.length = length;
    transfer.*.user_data = user_data;
    transfer.*.callback = callback;
}
pub fn libusb_fill_iso_transfer(arg_transfer: [*c]Transfer, arg_dev_handle: ?DeviceHandle, arg_endpoint: u8, arg_buffer: [*c]u8, arg_length: c_int, arg_num_iso_packets: c_int, arg_callback: libusb_transfer_cb_fn, arg_user_data: ?*anyopaque, arg_timeout: c_uint) callconv(.C) void {
    var transfer = arg_transfer;
    var dev_handle = arg_dev_handle;
    var endpoint = arg_endpoint;
    var buffer = arg_buffer;
    var length = arg_length;
    var num_iso_packets = arg_num_iso_packets;
    var callback = arg_callback;
    var user_data = arg_user_data;
    var timeout = arg_timeout;
    transfer.*.dev_handle = dev_handle;
    transfer.*.endpoint = endpoint;
    transfer.*.type = @bitCast(u8, @truncate(i8, TRANSFER_TYPE_ISOCHRONOUS));
    transfer.*.timeout = timeout;
    transfer.*.buffer = buffer;
    transfer.*.length = length;
    transfer.*.num_iso_packets = num_iso_packets;
    transfer.*.user_data = user_data;
    transfer.*.callback = callback;
}
pub fn libusb_set_iso_packet_lengths(arg_transfer: [*c]Transfer, arg_length: c_uint) callconv(.C) void {
    var transfer = arg_transfer;
    var length = arg_length;
    var i: c_int = undefined;
    {
        i = 0;
        while (i < transfer.*.num_iso_packets) : (i += 1) {
            transfer.*.iso_packet_desc()[@intCast(c_uint, i)].length = length;
        }
    }
}
pub fn libusb_get_iso_packet_buffer(arg_transfer: [*c]Transfer, arg_packet: c_uint) callconv(.C) [*c]u8 {
    var transfer = arg_transfer;
    var packet = arg_packet;
    var i: c_int = undefined;
    var offset: usize = 0;
    var _packet: c_int = undefined;
    if (packet > @bitCast(c_uint, @as(c_int, 2147483647))) return null;
    _packet = @bitCast(c_int, packet);
    if (_packet >= transfer.*.num_iso_packets) return null;
    {
        i = 0;
        while (i < _packet) : (i += 1) {
            offset +%= @bitCast(c_ulong, @as(c_ulong, transfer.*.iso_packet_desc()[@intCast(c_uint, i)].length));
        }
    }
    return transfer.*.buffer + offset;
}
pub fn libusb_get_iso_packet_buffer_simple(arg_transfer: [*c]Transfer, arg_packet: c_uint) callconv(.C) [*c]u8 {
    var transfer = arg_transfer;
    var packet = arg_packet;
    var _packet: c_int = undefined;
    if (packet > @bitCast(c_uint, @as(c_int, 2147483647))) return null;
    _packet = @bitCast(c_int, packet);
    if (_packet >= transfer.*.num_iso_packets) return null;
    return transfer.*.buffer + @bitCast(usize, @intCast(isize, @bitCast(c_int, transfer.*.iso_packet_desc()[@intCast(c_uint, @as(c_int, 0))].length) * _packet));
}
pub extern fn libusb_control_transfer(dev_handle: ?DeviceHandle, request_type: u8, bRequest: u8, wValue: u16, wIndex: u16, data: [*c]u8, wLength: u16, timeout: c_uint) c_int;
pub extern fn libusb_bulk_transfer(dev_handle: ?DeviceHandle, endpoint: u8, data: [*c]u8, length: c_int, actual_length: [*c]c_int, timeout: c_uint) c_int;
pub extern fn libusb_interrupt_transfer(dev_handle: ?DeviceHandle, endpoint: u8, data: [*c]u8, length: c_int, actual_length: [*c]c_int, timeout: c_uint) c_int;
pub fn libusb_get_descriptor(arg_dev_handle: ?DeviceHandle, arg_desc_type: u8, arg_desc_index: u8, arg_data: [*c]u8, arg_length: c_int) callconv(.C) c_int {
    var dev_handle = arg_dev_handle;
    var desc_type = arg_desc_type;
    var desc_index = arg_desc_index;
    var data = arg_data;
    var length = arg_length;
    return libusb_control_transfer(dev_handle, @bitCast(u8, @truncate(i8, ENDPOINT_IN)), @bitCast(u8, @truncate(i8, REQUEST_GET_DESCRIPTOR)), @bitCast(u16, @truncate(c_short, (@bitCast(c_int, @as(c_uint, desc_type)) << @intCast(@import("std").math.Log2Int(c_int), 8)) | @bitCast(c_int, @as(c_uint, desc_index)))), @bitCast(u16, @truncate(c_short, @as(c_int, 0))), data, @bitCast(u16, @truncate(c_short, length)), @bitCast(c_uint, @as(c_int, 1000)));
}
pub fn libusb_get_string_descriptor(arg_dev_handle: ?DeviceHandle, arg_desc_index: u8, arg_langid: u16, arg_data: [*c]u8, arg_length: c_int) callconv(.C) c_int {
    var dev_handle = arg_dev_handle;
    var desc_index = arg_desc_index;
    var langid = arg_langid;
    var data = arg_data;
    var length = arg_length;
    return libusb_control_transfer(dev_handle, @bitCast(u8, @truncate(i8, ENDPOINT_IN)), @bitCast(u8, @truncate(i8, REQUEST_GET_DESCRIPTOR)), @bitCast(u16, @truncate(c_short, (DT_STRING << @intCast(@import("std").math.Log2Int(c_int), 8)) | @bitCast(c_int, @as(c_uint, desc_index)))), langid, data, @bitCast(u16, @truncate(c_short, length)), @bitCast(c_uint, @as(c_int, 1000)));
}
pub extern fn libusb_get_string_descriptor_ascii(dev_handle: ?DeviceHandle, desc_index: u8, data: [*c]u8, length: c_int) c_int;
pub extern fn libusb_try_lock_events(ctx: ?*Context) c_int;
pub extern fn libusb_lock_events(ctx: ?*Context) void;
pub extern fn libusb_unlock_events(ctx: ?*Context) void;
pub extern fn libusb_event_handling_ok(ctx: ?*Context) c_int;
pub extern fn libusb_event_handler_active(ctx: ?*Context) c_int;
pub extern fn libusb_interrupt_event_handler(ctx: ?*Context) void;
pub extern fn libusb_lock_event_waiters(ctx: ?*Context) void;
pub extern fn libusb_unlock_event_waiters(ctx: ?*Context) void;
pub extern fn libusb_wait_for_event(ctx: ?*Context, tv: [*c]struct_timeval) c_int;
pub extern fn libusb_handle_events_timeout(ctx: ?*Context, tv: [*c]struct_timeval) c_int;
pub extern fn libusb_handle_events_timeout_completed(ctx: ?*Context, tv: [*c]struct_timeval, completed: [*c]c_int) c_int;
pub extern fn libusb_handle_events(ctx: ?*Context) c_int;
pub extern fn libusb_handle_events_completed(ctx: ?*Context, completed: [*c]c_int) c_int;
pub extern fn libusb_handle_events_locked(ctx: ?*Context, tv: [*c]struct_timeval) c_int;
pub extern fn libusb_pollfds_handle_timeouts(ctx: ?*Context) c_int;
pub extern fn libusb_get_next_timeout(ctx: ?*Context, tv: [*c]struct_timeval) c_int;
pub const struct_libusb_pollfd = extern struct {
    fd: c_int,
    events: c_short,
};
pub const libusb_pollfd_added_cb = ?fn (c_int, c_short, ?*anyopaque) callconv(.C) void;
pub const libusb_pollfd_removed_cb = ?fn (c_int, ?*anyopaque) callconv(.C) void;
pub extern fn libusb_get_pollfds(ctx: ?*Context) [*c][*c]const struct_libusb_pollfd;
pub extern fn libusb_free_pollfds(pollfds: [*c][*c]const struct_libusb_pollfd) void;
pub extern fn libusb_set_pollfd_notifiers(ctx: ?*Context, added_cb: libusb_pollfd_added_cb, removed_cb: libusb_pollfd_removed_cb, user_data: ?*anyopaque) void;
pub const libusb_hotplug_callback_handle = c_int;
pub const HOTPLUG_NO_FLAGS: c_int = 0;
pub const HOTPLUG_ENUMERATE: c_int = 1;
pub const libusb_hotplug_flag = c_uint;
pub const HOTPLUG_EVENT_DEVICE_ARRIVED: c_int = 1;
pub const HOTPLUG_EVENT_DEVICE_LEFT: c_int = 2;
pub const libusb_hotplug_event = c_uint;
pub const libusb_hotplug_callback_fn = ?fn (?*Context, ?Device, libusb_hotplug_event, ?*anyopaque) callconv(.C) c_int;
pub extern fn libusb_hotplug_register_callback(ctx: ?*Context, events: libusb_hotplug_event, flags: libusb_hotplug_flag, vendor_id: c_int, product_id: c_int, dev_class: c_int, cb_fn: libusb_hotplug_callback_fn, user_data: ?*anyopaque, callback_handle: [*c]libusb_hotplug_callback_handle) c_int;
pub extern fn libusb_hotplug_deregister_callback(ctx: ?*Context, callback_handle: libusb_hotplug_callback_handle) void;
pub const OPTION_LOG_LEVEL: c_int = 0;
pub const OPTION_USE_USBDK: c_int = 1;
pub const enum_Option = c_uint;
pub extern fn libusb_set_option(ctx: ?*Context, option: enum_Option, ...) c_int;
pub const __INTMAX_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `L`"); // (no file):67:9
pub const __UINTMAX_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `UL`"); // (no file):73:9
pub const __INT64_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `L`"); // (no file):164:9
pub const __UINT32_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `U`"); // (no file):186:9
pub const __UINT64_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `UL`"); // (no file):194:9
pub const __seg_gs = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // (no file):316:9
pub const __seg_fs = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // (no file):317:9
pub const __GLIBC_USE = @compileError("unable to translate macro: undefined identifier `__GLIBC_USE_`"); // /usr/include/features.h:186:9
pub const __glibc_has_attribute = @compileError("unable to translate macro: undefined identifier `__has_attribute`"); // /usr/include/sys/cdefs.h:45:10
pub const __glibc_has_builtin = @compileError("unable to translate macro: undefined identifier `__has_builtin`"); // /usr/include/sys/cdefs.h:50:10
pub const __glibc_has_extension = @compileError("unable to translate macro: undefined identifier `__has_extension`"); // /usr/include/sys/cdefs.h:55:10
pub const __THROW = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // /usr/include/sys/cdefs.h:79:11
pub const __THROWNL = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // /usr/include/sys/cdefs.h:80:11
pub const __NTH = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // /usr/include/sys/cdefs.h:81:11
pub const __NTHNL = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // /usr/include/sys/cdefs.h:82:11
pub const __CONCAT = @compileError("unable to translate C expr: unexpected token .HashHash"); // /usr/include/sys/cdefs.h:124:9
pub const __STRING = @compileError("unable to translate C expr: unexpected token .Hash"); // /usr/include/sys/cdefs.h:125:9
pub const __glibc_unsigned_or_positive = @compileError("unable to translate macro: undefined identifier `__typeof`"); // /usr/include/sys/cdefs.h:160:9
pub const __glibc_safe_or_unknown_len = @compileError("unable to translate macro: undefined identifier `__builtin_constant_p`"); // /usr/include/sys/cdefs.h:167:9
pub const __glibc_unsafe_len = @compileError("unable to translate macro: undefined identifier `__builtin_constant_p`"); // /usr/include/sys/cdefs.h:176:9
pub const __glibc_fortify = @compileError("unable to translate C expr: expected ')'"); // /usr/include/sys/cdefs.h:185:9
pub const __glibc_fortify_n = @compileError("unable to translate C expr: expected ')'"); // /usr/include/sys/cdefs.h:195:9
pub const __warnattr = @compileError("unable to translate C expr: unexpected token .Eof"); // /usr/include/sys/cdefs.h:207:10
pub const __errordecl = @compileError("unable to translate C expr: unexpected token .Keyword_extern"); // /usr/include/sys/cdefs.h:208:10
pub const __flexarr = @compileError("unable to translate C expr: unexpected token .LBracket"); // /usr/include/sys/cdefs.h:216:10
pub const __REDIRECT = @compileError("unable to translate macro: undefined identifier `__asm__`"); // /usr/include/sys/cdefs.h:247:10
pub const __REDIRECT_NTH = @compileError("unable to translate macro: undefined identifier `__asm__`"); // /usr/include/sys/cdefs.h:254:11
pub const __REDIRECT_NTHNL = @compileError("unable to translate macro: undefined identifier `__asm__`"); // /usr/include/sys/cdefs.h:256:11
pub const __ASMNAME2 = @compileError("unable to translate C expr: unexpected token .Identifier"); // /usr/include/sys/cdefs.h:260:10
pub const __attribute_malloc__ = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // /usr/include/sys/cdefs.h:281:10
pub const __attribute_alloc_size__ = @compileError("unable to translate C expr: unexpected token .Eof"); // /usr/include/sys/cdefs.h:292:10
pub const __attribute_alloc_align__ = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // /usr/include/sys/cdefs.h:298:10
pub const __attribute_pure__ = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // /usr/include/sys/cdefs.h:308:10
pub const __attribute_const__ = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // /usr/include/sys/cdefs.h:315:10
pub const __attribute_maybe_unused__ = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // /usr/include/sys/cdefs.h:321:10
pub const __attribute_used__ = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // /usr/include/sys/cdefs.h:330:10
pub const __attribute_noinline__ = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // /usr/include/sys/cdefs.h:331:10
pub const __attribute_deprecated__ = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // /usr/include/sys/cdefs.h:339:10
pub const __attribute_deprecated_msg__ = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // /usr/include/sys/cdefs.h:349:10
pub const __attribute_format_arg__ = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // /usr/include/sys/cdefs.h:362:10
pub const __attribute_format_strfmon__ = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // /usr/include/sys/cdefs.h:372:10
pub const __attribute_nonnull__ = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // /usr/include/sys/cdefs.h:384:11
pub const __returns_nonnull = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // /usr/include/sys/cdefs.h:397:10
pub const __attribute_warn_unused_result__ = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // /usr/include/sys/cdefs.h:406:10
pub const __always_inline = @compileError("unable to translate macro: undefined identifier `__inline`"); // /usr/include/sys/cdefs.h:424:10
pub const __attribute_artificial__ = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // /usr/include/sys/cdefs.h:433:10
pub const __extern_inline = @compileError("unable to translate macro: undefined identifier `__inline`"); // /usr/include/sys/cdefs.h:451:11
pub const __extern_always_inline = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // /usr/include/sys/cdefs.h:452:11
pub const __restrict_arr = @compileError("unable to translate macro: undefined identifier `__restrict`"); // /usr/include/sys/cdefs.h:495:10
pub const __attribute_copy__ = @compileError("unable to translate C expr: unexpected token .Eof"); // /usr/include/sys/cdefs.h:544:10
pub const __LDBL_REDIR2_DECL = @compileError("unable to translate C expr: unexpected token .Eof"); // /usr/include/sys/cdefs.h:620:10
pub const __LDBL_REDIR_DECL = @compileError("unable to translate C expr: unexpected token .Eof"); // /usr/include/sys/cdefs.h:621:10
pub const __glibc_macro_warning1 = @compileError("unable to translate macro: undefined identifier `_Pragma`"); // /usr/include/sys/cdefs.h:635:10
pub const __glibc_macro_warning = @compileError("unable to translate macro: undefined identifier `GCC`"); // /usr/include/sys/cdefs.h:636:10
pub const __fortified_attr_access = @compileError("unable to translate C expr: unexpected token .Eof"); // /usr/include/sys/cdefs.h:681:11
pub const __attr_access = @compileError("unable to translate C expr: unexpected token .Eof"); // /usr/include/sys/cdefs.h:682:11
pub const __attr_access_none = @compileError("unable to translate C expr: unexpected token .Eof"); // /usr/include/sys/cdefs.h:683:11
pub const __attr_dealloc = @compileError("unable to translate C expr: unexpected token .Eof"); // /usr/include/sys/cdefs.h:693:10
pub const __attribute_returns_twice__ = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // /usr/include/sys/cdefs.h:700:10
pub const __STD_TYPE = @compileError("unable to translate C expr: unexpected token .Keyword_typedef"); // /usr/include/bits/types.h:137:10
pub const __FSID_T_TYPE = @compileError("unable to translate macro: undefined identifier `__val`"); // /usr/include/bits/typesizes.h:73:9
pub const __INT64_C = @compileError("unable to translate macro: undefined identifier `L`"); // /usr/include/stdint.h:106:11
pub const __UINT64_C = @compileError("unable to translate macro: undefined identifier `UL`"); // /usr/include/stdint.h:107:11
pub const INT64_C = @compileError("unable to translate macro: undefined identifier `L`"); // /usr/include/stdint.h:252:11
pub const UINT32_C = @compileError("unable to translate macro: undefined identifier `U`"); // /usr/include/stdint.h:260:10
pub const UINT64_C = @compileError("unable to translate macro: undefined identifier `UL`"); // /usr/include/stdint.h:262:11
pub const INTMAX_C = @compileError("unable to translate macro: undefined identifier `L`"); // /usr/include/stdint.h:269:11
pub const UINTMAX_C = @compileError("unable to translate macro: undefined identifier `UL`"); // /usr/include/stdint.h:270:11
pub const __FD_ZERO = @compileError("unable to translate macro: undefined identifier `__i`"); // /usr/include/bits/select.h:25:9
pub const __FD_SET = @compileError("unable to translate C expr: expected ')' instead got: PipeEqual"); // /usr/include/bits/select.h:32:9
pub const __FD_CLR = @compileError("unable to translate C expr: expected ')' instead got: AmpersandEqual"); // /usr/include/bits/select.h:34:9
pub const __PTHREAD_MUTEX_INITIALIZER = @compileError("unable to translate C expr: unexpected token .LBrace"); // /usr/include/bits/struct_mutex.h:56:10
pub const __PTHREAD_RWLOCK_ELISION_EXTRA = @compileError("unable to translate C expr: unexpected token .LBrace"); // /usr/include/bits/struct_rwlock.h:40:11
pub const __ONCE_FLAG_INIT = @compileError("unable to translate C expr: unexpected token .LBrace"); // /usr/include/bits/thread-shared-types.h:113:9
pub const timerclear = @compileError("unable to translate C expr: expected ')' instead got: Equal"); // /usr/include/sys/time.h:232:10
pub const timercmp = @compileError("unable to translate C expr: expected ')' instead got: Identifier"); // /usr/include/sys/time.h:233:10
pub const timeradd = @compileError("unable to translate C expr: unexpected token .Keyword_do"); // /usr/include/sys/time.h:237:10
pub const timersub = @compileError("unable to translate C expr: unexpected token .Keyword_do"); // /usr/include/sys/time.h:247:10
pub const DEPRECATED_FOR = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // libusb.h:89:9
pub const __llvm__ = @as(c_int, 1);
pub const __clang__ = @as(c_int, 1);
pub const __clang_major__ = @as(c_int, 13);
pub const __clang_minor__ = @as(c_int, 0);
pub const __clang_patchlevel__ = @as(c_int, 1);
pub const __clang_version__ = "13.0.1 ";
pub const __GNUC__ = @as(c_int, 4);
pub const __GNUC_MINOR__ = @as(c_int, 2);
pub const __GNUC_PATCHLEVEL__ = @as(c_int, 1);
pub const __GXX_ABI_VERSION = @as(c_int, 1002);
pub const __ATOMIC_RELAXED = @as(c_int, 0);
pub const __ATOMIC_CONSUME = @as(c_int, 1);
pub const __ATOMIC_ACQUIRE = @as(c_int, 2);
pub const __ATOMIC_RELEASE = @as(c_int, 3);
pub const __ATOMIC_ACQ_REL = @as(c_int, 4);
pub const __ATOMIC_SEQ_CST = @as(c_int, 5);
pub const __OPENCL_MEMORY_SCOPE_WORK_ITEM = @as(c_int, 0);
pub const __OPENCL_MEMORY_SCOPE_WORK_GROUP = @as(c_int, 1);
pub const __OPENCL_MEMORY_SCOPE_DEVICE = @as(c_int, 2);
pub const __OPENCL_MEMORY_SCOPE_ALL_SVM_DEVICES = @as(c_int, 3);
pub const __OPENCL_MEMORY_SCOPE_SUB_GROUP = @as(c_int, 4);
pub const __PRAGMA_REDEFINE_EXTNAME = @as(c_int, 1);
pub const __VERSION__ = "Clang 13.0.1";
pub const __OBJC_BOOL_IS_BOOL = @as(c_int, 0);
pub const __CONSTANT_CFSTRINGS__ = @as(c_int, 1);
pub const __clang_literal_encoding__ = "UTF-8";
pub const __clang_wide_literal_encoding__ = "UTF-32";
pub const __OPTIMIZE__ = @as(c_int, 1);
pub const __ORDER_LITTLE_ENDIAN__ = @as(c_int, 1234);
pub const __ORDER_BIG_ENDIAN__ = @as(c_int, 4321);
pub const __ORDER_PDP_ENDIAN__ = @as(c_int, 3412);
pub const __BYTE_ORDER__ = __ORDER_LITTLE_ENDIAN__;
pub const __LITTLE_ENDIAN__ = @as(c_int, 1);
pub const _LP64 = @as(c_int, 1);
pub const __LP64__ = @as(c_int, 1);
pub const __CHAR_BIT__ = @as(c_int, 8);
pub const __SCHAR_MAX__ = @as(c_int, 127);
pub const __SHRT_MAX__ = @as(c_int, 32767);
pub const __INT_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __LONG_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __LONG_LONG_MAX__ = @as(c_longlong, 9223372036854775807);
pub const __WCHAR_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __WINT_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __INTMAX_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __SIZE_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __UINTMAX_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __PTRDIFF_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INTPTR_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __UINTPTR_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __SIZEOF_DOUBLE__ = @as(c_int, 8);
pub const __SIZEOF_FLOAT__ = @as(c_int, 4);
pub const __SIZEOF_INT__ = @as(c_int, 4);
pub const __SIZEOF_LONG__ = @as(c_int, 8);
pub const __SIZEOF_LONG_DOUBLE__ = @as(c_int, 16);
pub const __SIZEOF_LONG_LONG__ = @as(c_int, 8);
pub const __SIZEOF_POINTER__ = @as(c_int, 8);
pub const __SIZEOF_SHORT__ = @as(c_int, 2);
pub const __SIZEOF_PTRDIFF_T__ = @as(c_int, 8);
pub const __SIZEOF_SIZE_T__ = @as(c_int, 8);
pub const __SIZEOF_WCHAR_T__ = @as(c_int, 4);
pub const __SIZEOF_WINT_T__ = @as(c_int, 4);
pub const __SIZEOF_INT128__ = @as(c_int, 16);
pub const __INTMAX_TYPE__ = c_long;
pub const __INTMAX_FMTd__ = "ld";
pub const __INTMAX_FMTi__ = "li";
pub const __UINTMAX_TYPE__ = c_ulong;
pub const __UINTMAX_FMTo__ = "lo";
pub const __UINTMAX_FMTu__ = "lu";
pub const __UINTMAX_FMTx__ = "lx";
pub const __UINTMAX_FMTX__ = "lX";
pub const __INTMAX_WIDTH__ = @as(c_int, 64);
pub const __PTRDIFF_TYPE__ = c_long;
pub const __PTRDIFF_FMTd__ = "ld";
pub const __PTRDIFF_FMTi__ = "li";
pub const __PTRDIFF_WIDTH__ = @as(c_int, 64);
pub const __INTPTR_TYPE__ = c_long;
pub const __INTPTR_FMTd__ = "ld";
pub const __INTPTR_FMTi__ = "li";
pub const __INTPTR_WIDTH__ = @as(c_int, 64);
pub const __SIZE_TYPE__ = c_ulong;
pub const __SIZE_FMTo__ = "lo";
pub const __SIZE_FMTu__ = "lu";
pub const __SIZE_FMTx__ = "lx";
pub const __SIZE_FMTX__ = "lX";
pub const __SIZE_WIDTH__ = @as(c_int, 64);
pub const __WCHAR_TYPE__ = c_int;
pub const __WCHAR_WIDTH__ = @as(c_int, 32);
pub const __WINT_TYPE__ = c_uint;
pub const __WINT_WIDTH__ = @as(c_int, 32);
pub const __SIG_ATOMIC_WIDTH__ = @as(c_int, 32);
pub const __SIG_ATOMIC_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __CHAR16_TYPE__ = c_ushort;
pub const __CHAR32_TYPE__ = c_uint;
pub const __UINTMAX_WIDTH__ = @as(c_int, 64);
pub const __UINTPTR_TYPE__ = c_ulong;
pub const __UINTPTR_FMTo__ = "lo";
pub const __UINTPTR_FMTu__ = "lu";
pub const __UINTPTR_FMTx__ = "lx";
pub const __UINTPTR_FMTX__ = "lX";
pub const __UINTPTR_WIDTH__ = @as(c_int, 64);
pub const __FLT_DENORM_MIN__ = @as(f32, 1.40129846e-45);
pub const __FLT_HAS_DENORM__ = @as(c_int, 1);
pub const __FLT_DIG__ = @as(c_int, 6);
pub const __FLT_DECIMAL_DIG__ = @as(c_int, 9);
pub const __FLT_EPSILON__ = @as(f32, 1.19209290e-7);
pub const __FLT_HAS_INFINITY__ = @as(c_int, 1);
pub const __FLT_HAS_QUIET_NAN__ = @as(c_int, 1);
pub const __FLT_MANT_DIG__ = @as(c_int, 24);
pub const __FLT_MAX_10_EXP__ = @as(c_int, 38);
pub const __FLT_MAX_EXP__ = @as(c_int, 128);
pub const __FLT_MAX__ = @as(f32, 3.40282347e+38);
pub const __FLT_MIN_10_EXP__ = -@as(c_int, 37);
pub const __FLT_MIN_EXP__ = -@as(c_int, 125);
pub const __FLT_MIN__ = @as(f32, 1.17549435e-38);
pub const __DBL_DENORM_MIN__ = 4.9406564584124654e-324;
pub const __DBL_HAS_DENORM__ = @as(c_int, 1);
pub const __DBL_DIG__ = @as(c_int, 15);
pub const __DBL_DECIMAL_DIG__ = @as(c_int, 17);
pub const __DBL_EPSILON__ = 2.2204460492503131e-16;
pub const __DBL_HAS_INFINITY__ = @as(c_int, 1);
pub const __DBL_HAS_QUIET_NAN__ = @as(c_int, 1);
pub const __DBL_MANT_DIG__ = @as(c_int, 53);
pub const __DBL_MAX_10_EXP__ = @as(c_int, 308);
pub const __DBL_MAX_EXP__ = @as(c_int, 1024);
pub const __DBL_MAX__ = 1.7976931348623157e+308;
pub const __DBL_MIN_10_EXP__ = -@as(c_int, 307);
pub const __DBL_MIN_EXP__ = -@as(c_int, 1021);
pub const __DBL_MIN__ = 2.2250738585072014e-308;
pub const __LDBL_DENORM_MIN__ = @as(c_longdouble, 3.64519953188247460253e-4951);
pub const __LDBL_HAS_DENORM__ = @as(c_int, 1);
pub const __LDBL_DIG__ = @as(c_int, 18);
pub const __LDBL_DECIMAL_DIG__ = @as(c_int, 21);
pub const __LDBL_EPSILON__ = @as(c_longdouble, 1.08420217248550443401e-19);
pub const __LDBL_HAS_INFINITY__ = @as(c_int, 1);
pub const __LDBL_HAS_QUIET_NAN__ = @as(c_int, 1);
pub const __LDBL_MANT_DIG__ = @as(c_int, 64);
pub const __LDBL_MAX_10_EXP__ = @as(c_int, 4932);
pub const __LDBL_MAX_EXP__ = @as(c_int, 16384);
pub const __LDBL_MAX__ = @as(c_longdouble, 1.18973149535723176502e+4932);
pub const __LDBL_MIN_10_EXP__ = -@as(c_int, 4931);
pub const __LDBL_MIN_EXP__ = -@as(c_int, 16381);
pub const __LDBL_MIN__ = @as(c_longdouble, 3.36210314311209350626e-4932);
pub const __POINTER_WIDTH__ = @as(c_int, 64);
pub const __BIGGEST_ALIGNMENT__ = @as(c_int, 16);
pub const __WINT_UNSIGNED__ = @as(c_int, 1);
pub const __INT8_TYPE__ = i8;
pub const __INT8_FMTd__ = "hhd";
pub const __INT8_FMTi__ = "hhi";
pub const __INT8_C_SUFFIX__ = "";
pub const __INT16_TYPE__ = c_short;
pub const __INT16_FMTd__ = "hd";
pub const __INT16_FMTi__ = "hi";
pub const __INT16_C_SUFFIX__ = "";
pub const __INT32_TYPE__ = c_int;
pub const __INT32_FMTd__ = "d";
pub const __INT32_FMTi__ = "i";
pub const __INT32_C_SUFFIX__ = "";
pub const __INT64_TYPE__ = c_long;
pub const __INT64_FMTd__ = "ld";
pub const __INT64_FMTi__ = "li";
pub const __UINT8_TYPE__ = u8;
pub const __UINT8_FMTo__ = "hho";
pub const __UINT8_FMTu__ = "hhu";
pub const __UINT8_FMTx__ = "hhx";
pub const __UINT8_FMTX__ = "hhX";
pub const __UINT8_C_SUFFIX__ = "";
pub const __UINT8_MAX__ = @as(c_int, 255);
pub const __INT8_MAX__ = @as(c_int, 127);
pub const __UINT16_TYPE__ = c_ushort;
pub const __UINT16_FMTo__ = "ho";
pub const __UINT16_FMTu__ = "hu";
pub const __UINT16_FMTx__ = "hx";
pub const __UINT16_FMTX__ = "hX";
pub const __UINT16_C_SUFFIX__ = "";
pub const __UINT16_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const __INT16_MAX__ = @as(c_int, 32767);
pub const __UINT32_TYPE__ = c_uint;
pub const __UINT32_FMTo__ = "o";
pub const __UINT32_FMTu__ = "u";
pub const __UINT32_FMTx__ = "x";
pub const __UINT32_FMTX__ = "X";
pub const __UINT32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __INT32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __UINT64_TYPE__ = c_ulong;
pub const __UINT64_FMTo__ = "lo";
pub const __UINT64_FMTu__ = "lu";
pub const __UINT64_FMTx__ = "lx";
pub const __UINT64_FMTX__ = "lX";
pub const __UINT64_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __INT64_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INT_LEAST8_TYPE__ = i8;
pub const __INT_LEAST8_MAX__ = @as(c_int, 127);
pub const __INT_LEAST8_FMTd__ = "hhd";
pub const __INT_LEAST8_FMTi__ = "hhi";
pub const __UINT_LEAST8_TYPE__ = u8;
pub const __UINT_LEAST8_MAX__ = @as(c_int, 255);
pub const __UINT_LEAST8_FMTo__ = "hho";
pub const __UINT_LEAST8_FMTu__ = "hhu";
pub const __UINT_LEAST8_FMTx__ = "hhx";
pub const __UINT_LEAST8_FMTX__ = "hhX";
pub const __INT_LEAST16_TYPE__ = c_short;
pub const __INT_LEAST16_MAX__ = @as(c_int, 32767);
pub const __INT_LEAST16_FMTd__ = "hd";
pub const __INT_LEAST16_FMTi__ = "hi";
pub const __UINT_LEAST16_TYPE__ = c_ushort;
pub const __UINT_LEAST16_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const __UINT_LEAST16_FMTo__ = "ho";
pub const __UINT_LEAST16_FMTu__ = "hu";
pub const __UINT_LEAST16_FMTx__ = "hx";
pub const __UINT_LEAST16_FMTX__ = "hX";
pub const __INT_LEAST32_TYPE__ = c_int;
pub const __INT_LEAST32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __INT_LEAST32_FMTd__ = "d";
pub const __INT_LEAST32_FMTi__ = "i";
pub const __UINT_LEAST32_TYPE__ = c_uint;
pub const __UINT_LEAST32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __UINT_LEAST32_FMTo__ = "o";
pub const __UINT_LEAST32_FMTu__ = "u";
pub const __UINT_LEAST32_FMTx__ = "x";
pub const __UINT_LEAST32_FMTX__ = "X";
pub const __INT_LEAST64_TYPE__ = c_long;
pub const __INT_LEAST64_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INT_LEAST64_FMTd__ = "ld";
pub const __INT_LEAST64_FMTi__ = "li";
pub const __UINT_LEAST64_TYPE__ = c_ulong;
pub const __UINT_LEAST64_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __UINT_LEAST64_FMTo__ = "lo";
pub const __UINT_LEAST64_FMTu__ = "lu";
pub const __UINT_LEAST64_FMTx__ = "lx";
pub const __UINT_LEAST64_FMTX__ = "lX";
pub const __INT_FAST8_TYPE__ = i8;
pub const __INT_FAST8_MAX__ = @as(c_int, 127);
pub const __INT_FAST8_FMTd__ = "hhd";
pub const __INT_FAST8_FMTi__ = "hhi";
pub const __UINT_FAST8_TYPE__ = u8;
pub const __UINT_FAST8_MAX__ = @as(c_int, 255);
pub const __UINT_FAST8_FMTo__ = "hho";
pub const __UINT_FAST8_FMTu__ = "hhu";
pub const __UINT_FAST8_FMTx__ = "hhx";
pub const __UINT_FAST8_FMTX__ = "hhX";
pub const __INT_FAST16_TYPE__ = c_short;
pub const __INT_FAST16_MAX__ = @as(c_int, 32767);
pub const __INT_FAST16_FMTd__ = "hd";
pub const __INT_FAST16_FMTi__ = "hi";
pub const __UINT_FAST16_TYPE__ = c_ushort;
pub const __UINT_FAST16_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const __UINT_FAST16_FMTo__ = "ho";
pub const __UINT_FAST16_FMTu__ = "hu";
pub const __UINT_FAST16_FMTx__ = "hx";
pub const __UINT_FAST16_FMTX__ = "hX";
pub const __INT_FAST32_TYPE__ = c_int;
pub const __INT_FAST32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __INT_FAST32_FMTd__ = "d";
pub const __INT_FAST32_FMTi__ = "i";
pub const __UINT_FAST32_TYPE__ = c_uint;
pub const __UINT_FAST32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __UINT_FAST32_FMTo__ = "o";
pub const __UINT_FAST32_FMTu__ = "u";
pub const __UINT_FAST32_FMTx__ = "x";
pub const __UINT_FAST32_FMTX__ = "X";
pub const __INT_FAST64_TYPE__ = c_long;
pub const __INT_FAST64_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INT_FAST64_FMTd__ = "ld";
pub const __INT_FAST64_FMTi__ = "li";
pub const __UINT_FAST64_TYPE__ = c_ulong;
pub const __UINT_FAST64_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __UINT_FAST64_FMTo__ = "lo";
pub const __UINT_FAST64_FMTu__ = "lu";
pub const __UINT_FAST64_FMTx__ = "lx";
pub const __UINT_FAST64_FMTX__ = "lX";
pub const __USER_LABEL_PREFIX__ = "";
pub const __FINITE_MATH_ONLY__ = @as(c_int, 0);
pub const __GNUC_STDC_INLINE__ = @as(c_int, 1);
pub const __GCC_ATOMIC_TEST_AND_SET_TRUEVAL = @as(c_int, 1);
pub const __CLANG_ATOMIC_BOOL_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_CHAR_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_CHAR16_T_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_CHAR32_T_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_WCHAR_T_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_SHORT_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_INT_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_LONG_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_LLONG_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_POINTER_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_BOOL_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_CHAR_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_CHAR16_T_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_CHAR32_T_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_WCHAR_T_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_SHORT_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_INT_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_LONG_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_LLONG_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_POINTER_LOCK_FREE = @as(c_int, 2);
pub const __PIC__ = @as(c_int, 2);
pub const __pic__ = @as(c_int, 2);
pub const __PIE__ = @as(c_int, 2);
pub const __pie__ = @as(c_int, 2);
pub const __FLT_EVAL_METHOD__ = @as(c_int, 0);
pub const __FLT_RADIX__ = @as(c_int, 2);
pub const __DECIMAL_DIG__ = __LDBL_DECIMAL_DIG__;
pub const __GCC_ASM_FLAG_OUTPUTS__ = @as(c_int, 1);
pub const __code_model_small__ = @as(c_int, 1);
pub const __amd64__ = @as(c_int, 1);
pub const __amd64 = @as(c_int, 1);
pub const __x86_64 = @as(c_int, 1);
pub const __x86_64__ = @as(c_int, 1);
pub const __SEG_GS = @as(c_int, 1);
pub const __SEG_FS = @as(c_int, 1);
pub const __znver1 = @as(c_int, 1);
pub const __znver1__ = @as(c_int, 1);
pub const __tune_znver1__ = @as(c_int, 1);
pub const __REGISTER_PREFIX__ = "";
pub const __NO_MATH_INLINES = @as(c_int, 1);
pub const __AES__ = @as(c_int, 1);
pub const __PCLMUL__ = @as(c_int, 1);
pub const __LAHF_SAHF__ = @as(c_int, 1);
pub const __LZCNT__ = @as(c_int, 1);
pub const __RDRND__ = @as(c_int, 1);
pub const __FSGSBASE__ = @as(c_int, 1);
pub const __BMI__ = @as(c_int, 1);
pub const __BMI2__ = @as(c_int, 1);
pub const __POPCNT__ = @as(c_int, 1);
pub const __PRFCHW__ = @as(c_int, 1);
pub const __RDSEED__ = @as(c_int, 1);
pub const __ADX__ = @as(c_int, 1);
pub const __MWAITX__ = @as(c_int, 1);
pub const __MOVBE__ = @as(c_int, 1);
pub const __SSE4A__ = @as(c_int, 1);
pub const __FMA__ = @as(c_int, 1);
pub const __F16C__ = @as(c_int, 1);
pub const __SHA__ = @as(c_int, 1);
pub const __FXSR__ = @as(c_int, 1);
pub const __XSAVE__ = @as(c_int, 1);
pub const __XSAVEOPT__ = @as(c_int, 1);
pub const __XSAVEC__ = @as(c_int, 1);
pub const __XSAVES__ = @as(c_int, 1);
pub const __CLFLUSHOPT__ = @as(c_int, 1);
pub const __CLZERO__ = @as(c_int, 1);
pub const __AVX2__ = @as(c_int, 1);
pub const __AVX__ = @as(c_int, 1);
pub const __SSE4_2__ = @as(c_int, 1);
pub const __SSE4_1__ = @as(c_int, 1);
pub const __SSSE3__ = @as(c_int, 1);
pub const __SSE3__ = @as(c_int, 1);
pub const __SSE2__ = @as(c_int, 1);
pub const __SSE2_MATH__ = @as(c_int, 1);
pub const __SSE__ = @as(c_int, 1);
pub const __SSE_MATH__ = @as(c_int, 1);
pub const __MMX__ = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_1 = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_2 = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_4 = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_8 = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_16 = @as(c_int, 1);
pub const __SIZEOF_FLOAT128__ = @as(c_int, 16);
pub const unix = @as(c_int, 1);
pub const __unix = @as(c_int, 1);
pub const __unix__ = @as(c_int, 1);
pub const linux = @as(c_int, 1);
pub const __linux = @as(c_int, 1);
pub const __linux__ = @as(c_int, 1);
pub const __ELF__ = @as(c_int, 1);
pub const __gnu_linux__ = @as(c_int, 1);
pub const __FLOAT128__ = @as(c_int, 1);
pub const __STDC__ = @as(c_int, 1);
pub const __STDC_HOSTED__ = @as(c_int, 1);
pub const __STDC_VERSION__ = @as(c_long, 201710);
pub const __STDC_UTF_16__ = @as(c_int, 1);
pub const __STDC_UTF_32__ = @as(c_int, 1);
pub const _DEBUG = @as(c_int, 1);
pub const __GCC_HAVE_DWARF2_CFI_ASM = @as(c_int, 1);
pub const H = "";
pub const _STDINT_H = @as(c_int, 1);
pub const __GLIBC_INTERNAL_STARTING_HEADER_IMPLEMENTATION = "";
pub const _FEATURES_H = @as(c_int, 1);
pub const __KERNEL_STRICT_NAMES = "";
pub inline fn __GNUC_PREREQ(maj: anytype, min: anytype) @TypeOf(((__GNUC__ << @as(c_int, 16)) + __GNUC_MINOR__) >= ((maj << @as(c_int, 16)) + min)) {
    return ((__GNUC__ << @as(c_int, 16)) + __GNUC_MINOR__) >= ((maj << @as(c_int, 16)) + min);
}
pub inline fn __glibc_clang_prereq(maj: anytype, min: anytype) @TypeOf(((__clang_major__ << @as(c_int, 16)) + __clang_minor__) >= ((maj << @as(c_int, 16)) + min)) {
    return ((__clang_major__ << @as(c_int, 16)) + __clang_minor__) >= ((maj << @as(c_int, 16)) + min);
}
pub const _DEFAULT_SOURCE = @as(c_int, 1);
pub const __GLIBC_USE_ISOC2X = @as(c_int, 0);
pub const __USE_ISOC11 = @as(c_int, 1);
pub const __USE_ISOC99 = @as(c_int, 1);
pub const __USE_ISOC95 = @as(c_int, 1);
pub const __USE_POSIX_IMPLICITLY = @as(c_int, 1);
pub const _POSIX_SOURCE = @as(c_int, 1);
pub const _POSIX_C_SOURCE = @as(c_long, 200809);
pub const __USE_POSIX = @as(c_int, 1);
pub const __USE_POSIX2 = @as(c_int, 1);
pub const __USE_POSIX199309 = @as(c_int, 1);
pub const __USE_POSIX199506 = @as(c_int, 1);
pub const __USE_XOPEN2K = @as(c_int, 1);
pub const __USE_XOPEN2K8 = @as(c_int, 1);
pub const _ATFILE_SOURCE = @as(c_int, 1);
pub const __WORDSIZE = @as(c_int, 64);
pub const __WORDSIZE_TIME64_COMPAT32 = @as(c_int, 1);
pub const __SYSCALL_WORDSIZE = @as(c_int, 64);
pub const __TIMESIZE = __WORDSIZE;
pub const __USE_MISC = @as(c_int, 1);
pub const __USE_ATFILE = @as(c_int, 1);
pub const __USE_FORTIFY_LEVEL = @as(c_int, 0);
pub const __GLIBC_USE_DEPRECATED_GETS = @as(c_int, 0);
pub const __GLIBC_USE_DEPRECATED_SCANF = @as(c_int, 0);
pub const _STDC_PREDEF_H = @as(c_int, 1);
pub const __STDC_IEC_559__ = @as(c_int, 1);
pub const __STDC_IEC_60559_BFP__ = @as(c_long, 201404);
pub const __STDC_IEC_559_COMPLEX__ = @as(c_int, 1);
pub const __STDC_IEC_60559_COMPLEX__ = @as(c_long, 201404);
pub const __STDC_ISO_10646__ = @as(c_long, 201706);
pub const __GNU_LIBRARY__ = @as(c_int, 6);
pub const __GLIBC__ = @as(c_int, 2);
pub const __GLIBC_MINOR__ = @as(c_int, 35);
pub inline fn __GLIBC_PREREQ(maj: anytype, min: anytype) @TypeOf(((__GLIBC__ << @as(c_int, 16)) + __GLIBC_MINOR__) >= ((maj << @as(c_int, 16)) + min)) {
    return ((__GLIBC__ << @as(c_int, 16)) + __GLIBC_MINOR__) >= ((maj << @as(c_int, 16)) + min);
}
pub const _SYS_CDEFS_H = @as(c_int, 1);
pub const __LEAF = "";
pub const __LEAF_ATTR = "";
pub inline fn __P(args: anytype) @TypeOf(args) {
    return args;
}
pub inline fn __PMT(args: anytype) @TypeOf(args) {
    return args;
}
pub const __ptr_t = ?*anyopaque;
pub const __BEGIN_DECLS = "";
pub const __END_DECLS = "";
pub inline fn __bos(ptr: anytype) @TypeOf(__builtin_object_size(ptr, __USE_FORTIFY_LEVEL > @as(c_int, 1))) {
    return __builtin_object_size(ptr, __USE_FORTIFY_LEVEL > @as(c_int, 1));
}
pub inline fn __bos0(ptr: anytype) @TypeOf(__builtin_object_size(ptr, @as(c_int, 0))) {
    return __builtin_object_size(ptr, @as(c_int, 0));
}
pub inline fn __glibc_objsize0(__o: anytype) @TypeOf(__bos0(__o)) {
    return __bos0(__o);
}
pub inline fn __glibc_objsize(__o: anytype) @TypeOf(__bos(__o)) {
    return __bos(__o);
}
pub inline fn __glibc_safe_len_cond(__l: anytype, __s: anytype, __osz: anytype) @TypeOf(__l <= (__osz / __s)) {
    return __l <= (__osz / __s);
}
pub const __glibc_c99_flexarr_available = @as(c_int, 1);
pub inline fn __ASMNAME(cname: anytype) @TypeOf(__ASMNAME2(__USER_LABEL_PREFIX__, cname)) {
    return __ASMNAME2(__USER_LABEL_PREFIX__, cname);
}
pub inline fn __nonnull(params: anytype) @TypeOf(__attribute_nonnull__(params)) {
    return __attribute_nonnull__(params);
}
pub const __wur = "";
pub const __fortify_function = __extern_always_inline ++ __attribute_artificial__;
pub inline fn __glibc_unlikely(cond: anytype) @TypeOf(__builtin_expect(cond, @as(c_int, 0))) {
    return __builtin_expect(cond, @as(c_int, 0));
}
pub inline fn __glibc_likely(cond: anytype) @TypeOf(__builtin_expect(cond, @as(c_int, 1))) {
    return __builtin_expect(cond, @as(c_int, 1));
}
pub const __attribute_nonstring__ = "";
pub const __LDOUBLE_REDIRECTS_TO_FLOAT128_ABI = @as(c_int, 0);
pub inline fn __LDBL_REDIR1(name: anytype, proto: anytype, alias: anytype) @TypeOf(name ++ proto) {
    _ = alias;
    return name ++ proto;
}
pub inline fn __LDBL_REDIR(name: anytype, proto: anytype) @TypeOf(name ++ proto) {
    return name ++ proto;
}
pub inline fn __LDBL_REDIR1_NTH(name: anytype, proto: anytype, alias: anytype) @TypeOf(name ++ proto ++ __THROW) {
    _ = alias;
    return name ++ proto ++ __THROW;
}
pub inline fn __LDBL_REDIR_NTH(name: anytype, proto: anytype) @TypeOf(name ++ proto ++ __THROW) {
    return name ++ proto ++ __THROW;
}
pub inline fn __REDIRECT_LDBL(name: anytype, proto: anytype, alias: anytype) @TypeOf(__REDIRECT(name, proto, alias)) {
    return __REDIRECT(name, proto, alias);
}
pub inline fn __REDIRECT_NTH_LDBL(name: anytype, proto: anytype, alias: anytype) @TypeOf(__REDIRECT_NTH(name, proto, alias)) {
    return __REDIRECT_NTH(name, proto, alias);
}
pub const __HAVE_GENERIC_SELECTION = @as(c_int, 1);
pub const __attr_dealloc_free = "";
pub const __USE_EXTERN_INLINES = @as(c_int, 1);
pub const __stub___compat_bdflush = "";
pub const __stub_chflags = "";
pub const __stub_fchflags = "";
pub const __stub_gtty = "";
pub const __stub_revoke = "";
pub const __stub_setlogin = "";
pub const __stub_sigreturn = "";
pub const __stub_stty = "";
pub const __GLIBC_USE_LIB_EXT2 = @as(c_int, 0);
pub const __GLIBC_USE_IEC_60559_BFP_EXT = @as(c_int, 0);
pub const __GLIBC_USE_IEC_60559_BFP_EXT_C2X = @as(c_int, 0);
pub const __GLIBC_USE_IEC_60559_EXT = @as(c_int, 0);
pub const __GLIBC_USE_IEC_60559_FUNCS_EXT = @as(c_int, 0);
pub const __GLIBC_USE_IEC_60559_FUNCS_EXT_C2X = @as(c_int, 0);
pub const __GLIBC_USE_IEC_60559_TYPES_EXT = @as(c_int, 0);
pub const _BITS_TYPES_H = @as(c_int, 1);
pub const __S16_TYPE = c_short;
pub const __U16_TYPE = c_ushort;
pub const __S32_TYPE = c_int;
pub const __U32_TYPE = c_uint;
pub const __SLONGWORD_TYPE = c_long;
pub const __ULONGWORD_TYPE = c_ulong;
pub const __SQUAD_TYPE = c_long;
pub const __UQUAD_TYPE = c_ulong;
pub const __SWORD_TYPE = c_long;
pub const __UWORD_TYPE = c_ulong;
pub const __SLONG32_TYPE = c_int;
pub const __ULONG32_TYPE = c_uint;
pub const __S64_TYPE = c_long;
pub const __U64_TYPE = c_ulong;
pub const _BITS_TYPESIZES_H = @as(c_int, 1);
pub const __SYSCALL_SLONG_TYPE = __SLONGWORD_TYPE;
pub const __SYSCALL_ULONG_TYPE = __ULONGWORD_TYPE;
pub const __DEV_T_TYPE = __UQUAD_TYPE;
pub const __UID_T_TYPE = __U32_TYPE;
pub const __GID_T_TYPE = __U32_TYPE;
pub const __INO_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __INO64_T_TYPE = __UQUAD_TYPE;
pub const __MODE_T_TYPE = __U32_TYPE;
pub const __NLINK_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __FSWORD_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __OFF_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __OFF64_T_TYPE = __SQUAD_TYPE;
pub const __PID_T_TYPE = __S32_TYPE;
pub const __RLIM_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __RLIM64_T_TYPE = __UQUAD_TYPE;
pub const __BLKCNT_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __BLKCNT64_T_TYPE = __SQUAD_TYPE;
pub const __FSBLKCNT_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __FSBLKCNT64_T_TYPE = __UQUAD_TYPE;
pub const __FSFILCNT_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __FSFILCNT64_T_TYPE = __UQUAD_TYPE;
pub const __ID_T_TYPE = __U32_TYPE;
pub const __CLOCK_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __TIME_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __USECONDS_T_TYPE = __U32_TYPE;
pub const __SUSECONDS_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __SUSECONDS64_T_TYPE = __SQUAD_TYPE;
pub const __DADDR_T_TYPE = __S32_TYPE;
pub const __KEY_T_TYPE = __S32_TYPE;
pub const __CLOCKID_T_TYPE = __S32_TYPE;
pub const __TIMER_T_TYPE = ?*anyopaque;
pub const __BLKSIZE_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __SSIZE_T_TYPE = __SWORD_TYPE;
pub const __CPU_MASK_TYPE = __SYSCALL_ULONG_TYPE;
pub const __OFF_T_MATCHES_OFF64_T = @as(c_int, 1);
pub const __INO_T_MATCHES_INO64_T = @as(c_int, 1);
pub const __RLIM_T_MATCHES_RLIM64_T = @as(c_int, 1);
pub const __STATFS_MATCHES_STATFS64 = @as(c_int, 1);
pub const __KERNEL_OLD_TIMEVAL_MATCHES_TIMEVAL64 = @as(c_int, 1);
pub const __FD_SETSIZE = @as(c_int, 1024);
pub const _BITS_TIME64_H = @as(c_int, 1);
pub const __TIME64_T_TYPE = __TIME_T_TYPE;
pub const _BITS_WCHAR_H = @as(c_int, 1);
pub const __WCHAR_MAX = __WCHAR_MAX__;
pub const __WCHAR_MIN = -__WCHAR_MAX - @as(c_int, 1);
pub const _BITS_STDINT_INTN_H = @as(c_int, 1);
pub const _BITS_STDINT_UINTN_H = @as(c_int, 1);
pub const __intptr_t_defined = "";
pub const INT8_MIN = -@as(c_int, 128);
pub const INT16_MIN = -@as(c_int, 32767) - @as(c_int, 1);
pub const INT32_MIN = -@import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal) - @as(c_int, 1);
pub const INT64_MIN = -__INT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 9223372036854775807, .decimal)) - @as(c_int, 1);
pub const INT8_MAX = @as(c_int, 127);
pub const INT16_MAX = @as(c_int, 32767);
pub const INT32_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const INT64_MAX = __INT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 9223372036854775807, .decimal));
pub const UINT8_MAX = @as(c_int, 255);
pub const UINT16_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const UINT32_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const UINT64_MAX = __UINT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 18446744073709551615, .decimal));
pub const INT_LEAST8_MIN = -@as(c_int, 128);
pub const INT_LEAST16_MIN = -@as(c_int, 32767) - @as(c_int, 1);
pub const INT_LEAST32_MIN = -@import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal) - @as(c_int, 1);
pub const INT_LEAST64_MIN = -__INT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 9223372036854775807, .decimal)) - @as(c_int, 1);
pub const INT_LEAST8_MAX = @as(c_int, 127);
pub const INT_LEAST16_MAX = @as(c_int, 32767);
pub const INT_LEAST32_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const INT_LEAST64_MAX = __INT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 9223372036854775807, .decimal));
pub const UINT_LEAST8_MAX = @as(c_int, 255);
pub const UINT_LEAST16_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const UINT_LEAST32_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const UINT_LEAST64_MAX = __UINT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 18446744073709551615, .decimal));
pub const INT_FAST8_MIN = -@as(c_int, 128);
pub const INT_FAST16_MIN = -@import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal) - @as(c_int, 1);
pub const INT_FAST32_MIN = -@import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal) - @as(c_int, 1);
pub const INT_FAST64_MIN = -__INT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 9223372036854775807, .decimal)) - @as(c_int, 1);
pub const INT_FAST8_MAX = @as(c_int, 127);
pub const INT_FAST16_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const INT_FAST32_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const INT_FAST64_MAX = __INT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 9223372036854775807, .decimal));
pub const UINT_FAST8_MAX = @as(c_int, 255);
pub const UINT_FAST16_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const UINT_FAST32_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const UINT_FAST64_MAX = __UINT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 18446744073709551615, .decimal));
pub const INTPTR_MIN = -@import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal) - @as(c_int, 1);
pub const INTPTR_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const UINTPTR_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const INTMAX_MIN = -__INT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 9223372036854775807, .decimal)) - @as(c_int, 1);
pub const INTMAX_MAX = __INT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 9223372036854775807, .decimal));
pub const UINTMAX_MAX = __UINT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 18446744073709551615, .decimal));
pub const PTRDIFF_MIN = -@import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal) - @as(c_int, 1);
pub const PTRDIFF_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const SIG_ATOMIC_MIN = -@import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal) - @as(c_int, 1);
pub const SIG_ATOMIC_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const SIZE_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const WCHAR_MIN = __WCHAR_MIN;
pub const WCHAR_MAX = __WCHAR_MAX;
pub const WINT_MIN = @as(c_uint, 0);
pub const WINT_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub inline fn INT8_C(c: anytype) @TypeOf(c) {
    return c;
}
pub inline fn INT16_C(c: anytype) @TypeOf(c) {
    return c;
}
pub inline fn INT32_C(c: anytype) @TypeOf(c) {
    return c;
}
pub inline fn UINT8_C(c: anytype) @TypeOf(c) {
    return c;
}
pub inline fn UINT16_C(c: anytype) @TypeOf(c) {
    return c;
}
pub const _SYS_TYPES_H = @as(c_int, 1);
pub const __u_char_defined = "";
pub const __ino_t_defined = "";
pub const __dev_t_defined = "";
pub const __gid_t_defined = "";
pub const __mode_t_defined = "";
pub const __nlink_t_defined = "";
pub const __uid_t_defined = "";
pub const __off_t_defined = "";
pub const __pid_t_defined = "";
pub const __id_t_defined = "";
pub const __ssize_t_defined = "";
pub const __daddr_t_defined = "";
pub const __key_t_defined = "";
pub const __clock_t_defined = @as(c_int, 1);
pub const __clockid_t_defined = @as(c_int, 1);
pub const __time_t_defined = @as(c_int, 1);
pub const __timer_t_defined = @as(c_int, 1);
pub const __need_size_t = "";
pub const _SIZE_T = "";
pub const __BIT_TYPES_DEFINED__ = @as(c_int, 1);
pub const _ENDIAN_H = @as(c_int, 1);
pub const _BITS_ENDIAN_H = @as(c_int, 1);
pub const __LITTLE_ENDIAN = @as(c_int, 1234);
pub const __BIG_ENDIAN = @as(c_int, 4321);
pub const __PDP_ENDIAN = @as(c_int, 3412);
pub const _BITS_ENDIANNESS_H = @as(c_int, 1);
pub const __BYTE_ORDER = __LITTLE_ENDIAN;
pub const __FLOAT_WORD_ORDER = __BYTE_ORDER;
pub inline fn __LONG_LONG_PAIR(HI: anytype, LO: anytype) @TypeOf(HI) {
    return blk: {
        _ = LO;
        break :blk HI;
    };
}
pub const LITTLE_ENDIAN = __LITTLE_ENDIAN;
pub const BIG_ENDIAN = __BIG_ENDIAN;
pub const PDP_ENDIAN = __PDP_ENDIAN;
pub const BYTE_ORDER = __BYTE_ORDER;
pub const _BITS_BYTESWAP_H = @as(c_int, 1);
pub inline fn __bswap_constant_16(x: anytype) __uint16_t {
    return @import("std").zig.c_translation.cast(__uint16_t, ((x >> @as(c_int, 8)) & @as(c_int, 0xff)) | ((x & @as(c_int, 0xff)) << @as(c_int, 8)));
}
pub inline fn __bswap_constant_32(x: anytype) @TypeOf(((((x & @import("std").zig.c_translation.promoteIntLiteral(c_uint, 0xff000000, .hexadecimal)) >> @as(c_int, 24)) | ((x & @import("std").zig.c_translation.promoteIntLiteral(c_uint, 0x00ff0000, .hexadecimal)) >> @as(c_int, 8))) | ((x & @as(c_uint, 0x0000ff00)) << @as(c_int, 8))) | ((x & @as(c_uint, 0x000000ff)) << @as(c_int, 24))) {
    return ((((x & @import("std").zig.c_translation.promoteIntLiteral(c_uint, 0xff000000, .hexadecimal)) >> @as(c_int, 24)) | ((x & @import("std").zig.c_translation.promoteIntLiteral(c_uint, 0x00ff0000, .hexadecimal)) >> @as(c_int, 8))) | ((x & @as(c_uint, 0x0000ff00)) << @as(c_int, 8))) | ((x & @as(c_uint, 0x000000ff)) << @as(c_int, 24));
}
pub inline fn __bswap_constant_64(x: anytype) @TypeOf(((((((((x & @as(c_ulonglong, 0xff00000000000000)) >> @as(c_int, 56)) | ((x & @as(c_ulonglong, 0x00ff000000000000)) >> @as(c_int, 40))) | ((x & @as(c_ulonglong, 0x0000ff0000000000)) >> @as(c_int, 24))) | ((x & @as(c_ulonglong, 0x000000ff00000000)) >> @as(c_int, 8))) | ((x & @as(c_ulonglong, 0x00000000ff000000)) << @as(c_int, 8))) | ((x & @as(c_ulonglong, 0x0000000000ff0000)) << @as(c_int, 24))) | ((x & @as(c_ulonglong, 0x000000000000ff00)) << @as(c_int, 40))) | ((x & @as(c_ulonglong, 0x00000000000000ff)) << @as(c_int, 56))) {
    return ((((((((x & @as(c_ulonglong, 0xff00000000000000)) >> @as(c_int, 56)) | ((x & @as(c_ulonglong, 0x00ff000000000000)) >> @as(c_int, 40))) | ((x & @as(c_ulonglong, 0x0000ff0000000000)) >> @as(c_int, 24))) | ((x & @as(c_ulonglong, 0x000000ff00000000)) >> @as(c_int, 8))) | ((x & @as(c_ulonglong, 0x00000000ff000000)) << @as(c_int, 8))) | ((x & @as(c_ulonglong, 0x0000000000ff0000)) << @as(c_int, 24))) | ((x & @as(c_ulonglong, 0x000000000000ff00)) << @as(c_int, 40))) | ((x & @as(c_ulonglong, 0x00000000000000ff)) << @as(c_int, 56));
}
pub const _BITS_UINTN_IDENTITY_H = @as(c_int, 1);
pub inline fn htobe16(x: anytype) @TypeOf(__bswap_16(x)) {
    return __bswap_16(x);
}
pub inline fn htole16(x: anytype) @TypeOf(__uint16_identity(x)) {
    return __uint16_identity(x);
}
pub inline fn be16toh(x: anytype) @TypeOf(__bswap_16(x)) {
    return __bswap_16(x);
}
pub inline fn le16toh(x: anytype) @TypeOf(__uint16_identity(x)) {
    return __uint16_identity(x);
}
pub inline fn htobe32(x: anytype) @TypeOf(__bswap_32(x)) {
    return __bswap_32(x);
}
pub inline fn htole32(x: anytype) @TypeOf(__uint32_identity(x)) {
    return __uint32_identity(x);
}
pub inline fn be32toh(x: anytype) @TypeOf(__bswap_32(x)) {
    return __bswap_32(x);
}
pub inline fn le32toh(x: anytype) @TypeOf(__uint32_identity(x)) {
    return __uint32_identity(x);
}
pub inline fn htobe64(x: anytype) @TypeOf(__bswap_64(x)) {
    return __bswap_64(x);
}
pub inline fn htole64(x: anytype) @TypeOf(__uint64_identity(x)) {
    return __uint64_identity(x);
}
pub inline fn be64toh(x: anytype) @TypeOf(__bswap_64(x)) {
    return __bswap_64(x);
}
pub inline fn le64toh(x: anytype) @TypeOf(__uint64_identity(x)) {
    return __uint64_identity(x);
}
pub const _SYS_SELECT_H = @as(c_int, 1);
pub inline fn __FD_ISSET(d: anytype, s: anytype) @TypeOf((__FDS_BITS(s)[__FD_ELT(d)] & __FD_MASK(d)) != @as(c_int, 0)) {
    return (__FDS_BITS(s)[__FD_ELT(d)] & __FD_MASK(d)) != @as(c_int, 0);
}
pub const __sigset_t_defined = @as(c_int, 1);
pub const ____sigset_t_defined = "";
pub const _SIGSET_NWORDS = @as(c_int, 1024) / (@as(c_int, 8) * @import("std").zig.c_translation.sizeof(c_ulong));
pub const __timeval_defined = @as(c_int, 1);
pub const _STRUCT_TIMESPEC = @as(c_int, 1);
pub const __suseconds_t_defined = "";
pub const __NFDBITS = @as(c_int, 8) * @import("std").zig.c_translation.cast(c_int, @import("std").zig.c_translation.sizeof(__fd_mask));
pub inline fn __FD_ELT(d: anytype) @TypeOf(d / __NFDBITS) {
    return d / __NFDBITS;
}
pub inline fn __FD_MASK(d: anytype) __fd_mask {
    return @import("std").zig.c_translation.cast(__fd_mask, @as(c_ulong, 1) << (d % __NFDBITS));
}
pub inline fn __FDS_BITS(set: anytype) @TypeOf(set.*.__fds_bits) {
    return set.*.__fds_bits;
}
pub const FD_SETSIZE = __FD_SETSIZE;
pub const NFDBITS = __NFDBITS;
pub inline fn FD_SET(fd: anytype, fdsetp: anytype) @TypeOf(__FD_SET(fd, fdsetp)) {
    return __FD_SET(fd, fdsetp);
}
pub inline fn FD_CLR(fd: anytype, fdsetp: anytype) @TypeOf(__FD_CLR(fd, fdsetp)) {
    return __FD_CLR(fd, fdsetp);
}
pub inline fn FD_ISSET(fd: anytype, fdsetp: anytype) @TypeOf(__FD_ISSET(fd, fdsetp)) {
    return __FD_ISSET(fd, fdsetp);
}
pub inline fn FD_ZERO(fdsetp: anytype) @TypeOf(__FD_ZERO(fdsetp)) {
    return __FD_ZERO(fdsetp);
}
pub const __blksize_t_defined = "";
pub const __blkcnt_t_defined = "";
pub const __fsblkcnt_t_defined = "";
pub const __fsfilcnt_t_defined = "";
pub const _BITS_PTHREADTYPES_COMMON_H = @as(c_int, 1);
pub const _THREAD_SHARED_TYPES_H = @as(c_int, 1);
pub const _BITS_PTHREADTYPES_ARCH_H = @as(c_int, 1);
pub const __SIZEOF_PTHREAD_MUTEX_T = @as(c_int, 40);
pub const __SIZEOF_PTHREAD_ATTR_T = @as(c_int, 56);
pub const __SIZEOF_PTHREAD_RWLOCK_T = @as(c_int, 56);
pub const __SIZEOF_PTHREAD_BARRIER_T = @as(c_int, 32);
pub const __SIZEOF_PTHREAD_MUTEXATTR_T = @as(c_int, 4);
pub const __SIZEOF_PTHREAD_COND_T = @as(c_int, 48);
pub const __SIZEOF_PTHREAD_CONDATTR_T = @as(c_int, 4);
pub const __SIZEOF_PTHREAD_RWLOCKATTR_T = @as(c_int, 8);
pub const __SIZEOF_PTHREAD_BARRIERATTR_T = @as(c_int, 4);
pub const __LOCK_ALIGNMENT = "";
pub const __ONCE_ALIGNMENT = "";
pub const _BITS_ATOMIC_WIDE_COUNTER_H = "";
pub const _THREAD_MUTEX_INTERNAL_H = @as(c_int, 1);
pub const __PTHREAD_MUTEX_HAVE_PREV = @as(c_int, 1);
pub const _RWLOCK_INTERNAL_H = "";
pub inline fn __PTHREAD_RWLOCK_INITIALIZER(__flags: anytype) @TypeOf(__flags) {
    return blk: {
        _ = @as(c_int, 0);
        _ = @as(c_int, 0);
        _ = @as(c_int, 0);
        _ = @as(c_int, 0);
        _ = @as(c_int, 0);
        _ = @as(c_int, 0);
        _ = @as(c_int, 0);
        _ = @as(c_int, 0);
        _ = __PTHREAD_RWLOCK_ELISION_EXTRA;
        _ = @as(c_int, 0);
        break :blk __flags;
    };
}
pub const __have_pthread_attr_t = @as(c_int, 1);
pub const _SYS_TIME_H = @as(c_int, 1);
pub inline fn timerisset(tvp: anytype) @TypeOf((tvp.*.tv_sec != 0) or (tvp.*.tv_usec != 0)) {
    return (tvp.*.tv_sec != 0) or (tvp.*.tv_usec != 0);
}
pub const _TIME_H = @as(c_int, 1);
pub const __need_NULL = "";
pub const NULL = @import("std").zig.c_translation.cast(?*anyopaque, @as(c_int, 0));
pub const _BITS_TIME_H = @as(c_int, 1);
pub const CLOCKS_PER_SEC = @import("std").zig.c_translation.cast(__clock_t, @import("std").zig.c_translation.promoteIntLiteral(c_int, 1000000, .decimal));
pub const CLOCK_REALTIME = @as(c_int, 0);
pub const CLOCK_MONOTONIC = @as(c_int, 1);
pub const CLOCK_PROCESS_CPUTIME_ID = @as(c_int, 2);
pub const CLOCK_THREAD_CPUTIME_ID = @as(c_int, 3);
pub const CLOCK_MONOTONIC_RAW = @as(c_int, 4);
pub const CLOCK_REALTIME_COARSE = @as(c_int, 5);
pub const CLOCK_MONOTONIC_COARSE = @as(c_int, 6);
pub const CLOCK_BOOTTIME = @as(c_int, 7);
pub const CLOCK_REALTIME_ALARM = @as(c_int, 8);
pub const CLOCK_BOOTTIME_ALARM = @as(c_int, 9);
pub const CLOCK_TAI = @as(c_int, 11);
pub const TIMER_ABSTIME = @as(c_int, 1);
pub const __struct_tm_defined = @as(c_int, 1);
pub const __itimerspec_defined = @as(c_int, 1);
pub const _BITS_TYPES_LOCALE_T_H = @as(c_int, 1);
pub const _BITS_TYPES___LOCALE_T_H = @as(c_int, 1);
pub const TIME_UTC = @as(c_int, 1);
pub inline fn __isleap(year: anytype) @TypeOf(((year % @as(c_int, 4)) == @as(c_int, 0)) and (((year % @as(c_int, 100)) != @as(c_int, 0)) or ((year % @as(c_int, 400)) == @as(c_int, 0)))) {
    return ((year % @as(c_int, 4)) == @as(c_int, 0)) and (((year % @as(c_int, 100)) != @as(c_int, 0)) or ((year % @as(c_int, 400)) == @as(c_int, 0)));
}
pub const _LIBC_LIMITS_H_ = @as(c_int, 1);
pub const MB_LEN_MAX = @as(c_int, 16);
pub const __CLANG_LIMITS_H = "";
pub const _GCC_LIMITS_H_ = "";
pub const SCHAR_MAX = __SCHAR_MAX__;
pub const SHRT_MAX = __SHRT_MAX__;
pub const INT_MAX = __INT_MAX__;
pub const LONG_MAX = __LONG_MAX__;
pub const SCHAR_MIN = -__SCHAR_MAX__ - @as(c_int, 1);
pub const SHRT_MIN = -__SHRT_MAX__ - @as(c_int, 1);
pub const INT_MIN = -__INT_MAX__ - @as(c_int, 1);
pub const LONG_MIN = -__LONG_MAX__ - @as(c_long, 1);
pub const UCHAR_MAX = (__SCHAR_MAX__ * @as(c_int, 2)) + @as(c_int, 1);
pub const USHRT_MAX = (__SHRT_MAX__ * @as(c_int, 2)) + @as(c_int, 1);
pub const UINT_MAX = (__INT_MAX__ * @as(c_uint, 2)) + @as(c_uint, 1);
pub const ULONG_MAX = (__LONG_MAX__ * @as(c_ulong, 2)) + @as(c_ulong, 1);
pub const CHAR_BIT = __CHAR_BIT__;
pub const CHAR_MIN = SCHAR_MIN;
pub const CHAR_MAX = __SCHAR_MAX__;
pub const LLONG_MAX = __LONG_LONG_MAX__;
pub const LLONG_MIN = -__LONG_LONG_MAX__ - @as(c_longlong, 1);
pub const ULLONG_MAX = (__LONG_LONG_MAX__ * @as(c_ulonglong, 2)) + @as(c_ulonglong, 1);
pub const _BITS_POSIX1_LIM_H = @as(c_int, 1);
pub const _POSIX_AIO_LISTIO_MAX = @as(c_int, 2);
pub const _POSIX_AIO_MAX = @as(c_int, 1);
pub const _POSIX_ARG_MAX = @as(c_int, 4096);
pub const _POSIX_CHILD_MAX = @as(c_int, 25);
pub const _POSIX_DELAYTIMER_MAX = @as(c_int, 32);
pub const _POSIX_HOST_NAME_MAX = @as(c_int, 255);
pub const _POSIX_LINK_MAX = @as(c_int, 8);
pub const _POSIX_LOGIN_NAME_MAX = @as(c_int, 9);
pub const _POSIX_MAX_CANON = @as(c_int, 255);
pub const _POSIX_MAX_INPUT = @as(c_int, 255);
pub const _POSIX_MQ_OPEN_MAX = @as(c_int, 8);
pub const _POSIX_MQ_PRIO_MAX = @as(c_int, 32);
pub const _POSIX_NAME_MAX = @as(c_int, 14);
pub const _POSIX_NGROUPS_MAX = @as(c_int, 8);
pub const _POSIX_OPEN_MAX = @as(c_int, 20);
pub const _POSIX_PATH_MAX = @as(c_int, 256);
pub const _POSIX_PIPE_BUF = @as(c_int, 512);
pub const _POSIX_RE_DUP_MAX = @as(c_int, 255);
pub const _POSIX_RTSIG_MAX = @as(c_int, 8);
pub const _POSIX_SEM_NSEMS_MAX = @as(c_int, 256);
pub const _POSIX_SEM_VALUE_MAX = @as(c_int, 32767);
pub const _POSIX_SIGQUEUE_MAX = @as(c_int, 32);
pub const _POSIX_SSIZE_MAX = @as(c_int, 32767);
pub const _POSIX_STREAM_MAX = @as(c_int, 8);
pub const _POSIX_SYMLINK_MAX = @as(c_int, 255);
pub const _POSIX_SYMLOOP_MAX = @as(c_int, 8);
pub const _POSIX_TIMER_MAX = @as(c_int, 32);
pub const _POSIX_TTY_NAME_MAX = @as(c_int, 9);
pub const _POSIX_TZNAME_MAX = @as(c_int, 6);
pub const _POSIX_CLOCKRES_MIN = @import("std").zig.c_translation.promoteIntLiteral(c_int, 20000000, .decimal);
pub const __undef_NR_OPEN = "";
pub const __undef_LINK_MAX = "";
pub const __undef_OPEN_MAX = "";
pub const __undef_ARG_MAX = "";
pub const _LINUX_LIMITS_H = "";
pub const NR_OPEN = @as(c_int, 1024);
pub const NGROUPS_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65536, .decimal);
pub const ARG_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 131072, .decimal);
pub const LINK_MAX = @as(c_int, 127);
pub const MAX_CANON = @as(c_int, 255);
pub const MAX_INPUT = @as(c_int, 255);
pub const NAME_MAX = @as(c_int, 255);
pub const PATH_MAX = @as(c_int, 4096);
pub const PIPE_BUF = @as(c_int, 4096);
pub const XATTR_NAME_MAX = @as(c_int, 255);
pub const XATTR_SIZE_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65536, .decimal);
pub const XATTR_LIST_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65536, .decimal);
pub const RTSIG_MAX = @as(c_int, 32);
pub const _POSIX_THREAD_KEYS_MAX = @as(c_int, 128);
pub const PTHREAD_KEYS_MAX = @as(c_int, 1024);
pub const _POSIX_THREAD_DESTRUCTOR_ITERATIONS = @as(c_int, 4);
pub const PTHREAD_DESTRUCTOR_ITERATIONS = _POSIX_THREAD_DESTRUCTOR_ITERATIONS;
pub const _POSIX_THREAD_THREADS_MAX = @as(c_int, 64);
pub const AIO_PRIO_DELTA_MAX = @as(c_int, 20);
pub const PTHREAD_STACK_MIN = @as(c_int, 16384);
pub const DELAYTIMER_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const TTY_NAME_MAX = @as(c_int, 32);
pub const LOGIN_NAME_MAX = @as(c_int, 256);
pub const HOST_NAME_MAX = @as(c_int, 64);
pub const MQ_PRIO_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 32768, .decimal);
pub const SEM_VALUE_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const SSIZE_MAX = LONG_MAX;
pub const _BITS_POSIX2_LIM_H = @as(c_int, 1);
pub const _POSIX2_BC_BASE_MAX = @as(c_int, 99);
pub const _POSIX2_BC_DIM_MAX = @as(c_int, 2048);
pub const _POSIX2_BC_SCALE_MAX = @as(c_int, 99);
pub const _POSIX2_BC_STRING_MAX = @as(c_int, 1000);
pub const _POSIX2_COLL_WEIGHTS_MAX = @as(c_int, 2);
pub const _POSIX2_EXPR_NEST_MAX = @as(c_int, 32);
pub const _POSIX2_LINE_MAX = @as(c_int, 2048);
pub const _POSIX2_RE_DUP_MAX = @as(c_int, 255);
pub const _POSIX2_CHARCLASS_NAME_MAX = @as(c_int, 14);
pub const BC_BASE_MAX = _POSIX2_BC_BASE_MAX;
pub const BC_DIM_MAX = _POSIX2_BC_DIM_MAX;
pub const BC_SCALE_MAX = _POSIX2_BC_SCALE_MAX;
pub const BC_STRING_MAX = _POSIX2_BC_STRING_MAX;
pub const COLL_WEIGHTS_MAX = @as(c_int, 255);
pub const EXPR_NEST_MAX = _POSIX2_EXPR_NEST_MAX;
pub const LINE_MAX = _POSIX2_LINE_MAX;
pub const CHARCLASS_NAME_MAX = @as(c_int, 2048);
pub const RE_DUP_MAX = @as(c_int, 0x7fff);
pub const ZERO_SIZED_ARRAY = "";
pub const CALL = "";
pub const API_VERSION = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x01000107, .hexadecimal);
pub const LIBUSBX_API_VERSION = API_VERSION;
pub const libusb_le16_to_cpu = libusb_cpu_to_le16;
pub const DT_DEVICE_SIZE = @as(c_int, 18);
pub const DT_CONFIG_SIZE = @as(c_int, 9);
pub const DT_INTERFACE_SIZE = @as(c_int, 9);
pub const DT_ENDPOINT_SIZE = @as(c_int, 7);
pub const DT_ENDPOINT_AUDIO_SIZE = @as(c_int, 9);
pub const DT_HUB_NONVAR_SIZE = @as(c_int, 7);
pub const DT_SS_ENDPOINT_COMPANION_SIZE = @as(c_int, 6);
pub const DT_BOS_SIZE = @as(c_int, 5);
pub const DT_DEVICE_CAPABILITY_SIZE = @as(c_int, 3);
pub const BT_USB_2_0_EXTENSION_SIZE = @as(c_int, 7);
pub const BT_SS_USB_DEVICE_CAPABILITY_SIZE = @as(c_int, 10);
pub const BT_CONTAINER_ID_SIZE = @as(c_int, 20);
pub const DT_BOS_MAX_SIZE = ((DT_BOS_SIZE + BT_USB_2_0_EXTENSION_SIZE) + BT_SS_USB_DEVICE_CAPABILITY_SIZE) + BT_CONTAINER_ID_SIZE;
pub const ENDPOINT_ADDRESS_MASK = @as(c_int, 0x0f);
pub const ENDPOINT_DIR_MASK = @as(c_int, 0x80);
pub const TRANSFER_TYPE_MASK = @as(c_int, 0x03);
pub const ISO_SYNC_TYPE_MASK = @as(c_int, 0x0C);
pub const ISO_USAGE_TYPE_MASK = @as(c_int, 0x30);
pub const CONTROL_SETUP_SIZE = @import("std").zig.c_translation.sizeof(struct_libusb_control_setup);
pub const ERROR_COUNT = @as(c_int, 14);
pub const HOTPLUG_MATCH_ANY = -@as(c_int, 1);
pub const timeval = struct_timeval;
pub const timespec = struct_timespec;
pub const __pthread_internal_list = struct___pthread_internal_list;
pub const __pthread_internal_slist = struct___pthread_internal_slist;
pub const __pthread_mutex_s = struct___pthread_mutex_s;
pub const __pthread_rwlock_arch_t = struct___pthread_rwlock_arch_t;
pub const __pthread_cond_s = struct___pthread_cond_s;
pub const __itimer_which = enum___itimer_which;
pub const itimerval = struct_itimerval;
pub const tm = struct_tm;
pub const itimerspec = struct_itimerspec;
pub const sigevent = struct_sigevent;
pub const __locale_data = struct___locale_data;
pub const __locale_struct = struct___locale_struct;
pub const libusb_control_setup = struct_libusb_control_setup;
pub const libusb_version = struct_libusb_version;
pub const Error = enum_Error;
pub const libusb_iso_packet_descriptor = struct_libusb_iso_packet_descriptor;
pub const Log_cb_mode = enum_Log_cb_mode;
pub const libusb_pollfd = struct_libusb_pollfd;
pub const Option = enum_Option;

