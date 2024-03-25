# Jetson Easy Flash

**IN PROGRESS**

The goal of this project is to streamline device setup for Jetson application developers. More configuration options will likely be added over time, but it will never recreate all of the functionality that comes with JetPack or SDK Manager.

## Prerequisites

```bash
sudo apt install qemu-user-static
```

## Usage

Note that the `docker run` command is probably missing some options for connecting to the developer kit over USB. It has not been fully tested yet.

```bash
docker build -t jetson-easy-flash:latest . 
docker run --rm --privileged --env-file=config.env jetson-easy-flash:latest 
```

## Licensing

Feel free to use this code in accordance with the provided [license](LICENSE).

