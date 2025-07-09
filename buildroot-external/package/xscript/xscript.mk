################################################################################
#
# xscript – Geekworm C1/X‑series helper scripts
#
################################################################################

XSCRIPT_VERSION = adcfdd7ac58dd222ccd5e9e4680e0e1872262006
XSCRIPT_SITE = $(call github,geekworm-com,xscript,$(XSCRIPT_VERSION))

# The project is published under the MIT license, but no LICENSE file is present
# in the repository at time of writing.
XSCRIPT_LICENSE = MIT

XSCRIPT_DEPENDENCIES += libgpiod
ifeq ($(filter y,$(BR2_PACKAGE_XSCRIPT_FAN_SERVICE) $(BR2_PACKAGE_XSCRIPT_PWR_SERVICE)),y)
XSCRIPT_DEPENDENCIES += systemd
endif

define XSCRIPT_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/x-c1-fan.sh \
		$(TARGET_DIR)/usr/local/bin/x-c1-fan.sh

	$(INSTALL) -D -m 0755 $(@D)/xPWR.sh \
		$(TARGET_DIR)/usr/local/bin/xPWR.sh
endef

define XSCRIPT_INSTALL_INIT_SYSTEMD
	# Conditionally install the fan helper & unit
	if [ "$(BR2_PACKAGE_XSCRIPT_FAN_SERVICE)" = "y" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/x-c1-fan.service \
			$(TARGET_DIR)/usr/lib/systemd/system/x-c1-fan.service; \
	fi

	# Conditionally install the power helper & unit
	if [ "$(BR2_PACKAGE_XSCRIPT_PWR_SERVICE)" = "y" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/x-c1-pwr.service \
			$(TARGET_DIR)/usr/lib/systemd/system/x-c1-pwr.service; \
	fi
endef

################################################################################
# Register with Buildroot generic-package infrastructure
################################################################################

$(eval $(generic-package))
