# HSES_Dissector
Wireshark dissector lua script for High Speed Ethernet Server protocol
-------------------------

Copy these files to the appropriate directory:

**Windows**: `C:\Program Files\Wireshark\plugins\<version>`

**Linux**: `/usr/share/wireshark/plugins`

Inside wireshark application, use filter "hses".

-------------------------
**Known limitations**:

1. The data payload for the "plural data" commands will not be properly dissected. It will however disect the header portion.
1. The file read/write commands will not be properly dissected.
