const DeviceHandle = opaque {

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