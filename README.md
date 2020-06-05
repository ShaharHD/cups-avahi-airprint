# shaharhd/cups-avahi-airprint

Fork from [Oekn5w/cups-avahi-airprint](https://github.com/Oekn5w/cups-avahi-airprint)

This Ubuntu (32bit) based Docker image runs a CUPS instance that is meant as an AirPrint relay for printers that are already on the network but not AirPrint capable.

- Added support for Xerox 6125N
- Main reason this docker image is based on 32bit to allow support for old 32bit cups drivers

Reference:

- [https://rickvanderzwet.nl/trac/personal/wiki/XeroxPhaser6125N](https://rickvanderzwet.nl/trac/personal/wiki/XeroxPhaser6125N)

## Configuration

### Volumes

- `/config`: where the persistent printer configs will be stored
- `/services`: where the Avahi service files will be generated

### Variables

- `CUPSADMIN`: the CUPS admin user you want created
- `CUPSPASSWORD`: the password for the CUPS admin user

### Ports/Network

- Must be run on host network. This is required to support multicasting which is needed for Airprint.

### Example run command

```shell
docker run --name cups --restart unless-stopped  --net host\
  -v <your services dir>:/services \
  -v <your config dir>:/config \
  -e CUPSADMIN="<username>" \
  -e CUPSPASSWORD="<password>" \
  shaharhd/cups-avahi-airprint:latest
```

### Build localy

```shell
docker build -t alpine-cups-airprint .
```

## Add and set up printer

- CUPS will be configurable at `http://[host ip]:631` using the CUPSADMIN/CUPSPASSWORD.
- Make sure you select `Share This Printer` when configuring the printer in CUPS.
- ***After configuring your printer, you need to close the web browser for at least 60 seconds. CUPS will not write the config files until it detects the connection is closed for as long as a minute.***
