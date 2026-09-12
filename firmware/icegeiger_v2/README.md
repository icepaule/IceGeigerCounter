# IceGeiger V2 firmware

Target: delivered **HITT-Tracker V1.2** (real PCB: SX1262 + UC6580) using the public Heltec Wireless-Tracker-V1.1-family pinout where it matches the hardware.

Important changes from the first V2 draft:

- Geiger INT moved from GPIO47 to **GPIO17** because GPIO47 is documented as Boot_Mode on the Heltec family.
- GNSS remains on RX=33 / TX=34 with GPIO3 HIGH.
- microSD remains on GPIO4/5/6/7.
- battery measurement is read from GPIO1 using the documented 4.9 divider factor and is included in MQTT/SD/LoRa payloads.

Copy `secrets.example.h` to local `secrets.h`, fill credentials locally and never commit the file.
