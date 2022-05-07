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