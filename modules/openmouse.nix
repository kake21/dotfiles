{ ... }:

{
  # WebHID access for OpenMouse (https://control.openmouse.app) to configure the
  # Logitech G502 X Lightspeed.
  #
  # Chrome can only open a /dev/hidraw* node the user can read and write. The
  # nodes default to root:root 0600, so the browser sees no device at all.
  #
  # The rule matches the whole Logitech vendor id rather than a product id
  # because the mouse enumerates differently depending on how it is connected:
  # over Lightspeed the hidraw node hangs off the receiver (046d:c547) and the
  # mouse's own id (046d:409f) never appears in the udev parent chain, while on
  # the charging cable it enumerates directly under its own wired product id.
  # This grants no access the user did not already have -- vegard is in the
  # `input` group, which can read every /dev/input/event* node anyway.
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="046d", MODE="0660", GROUP="input", TAG+="uaccess"
  '';
}
