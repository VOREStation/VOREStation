## byond-tracy-github-link
https://github.com/spacestation13/byond-tracy

## byond-tracy
byond-tracy glues together a byond server with the tracy profiler allowing you to analyze and visualize proc calls


## supported byond versions
| windows  | linux    |
| -------- | -------- |
| 516.1685 | 516.1685 |
| 516.1684 | 516.1684 |
| 516.1683 | 516.1683 |
| 516.1682 | 516.1682 |
| 516.1681 | 516.1681 |
| 516.1680 | 516.1680 |
| 516.1679 | 516.1679 |
| 516.1678 | 516.1678 |
| 516.1677 | 516.1677 |
| 516.1676 | 516.1676 |
| 516.1675 | 516.1675 |
| 516.1674 | 516.1674 |
| 516.1673 | 516.1673 |
| 516.1672 | 516.1672 |
| 516.1671 | 516.1671 |
| 516.1670 | 516.1670 |
| 516.1669 | 516.1669 |
| 516.1668 | 516.1668 |
| 516.1667 | 516.1667 |
| 516.1666 | 516.1666 |
| 516.1665 | 516.1665 |
| 516.1664 | 516.1664 |
| 516.1663 | 516.1663 |
| 516.1662 | 516.1662 |
| 516.1661 | 516.1661 |
| 516.1660 | 516.1660 |
| 516.1659 | 516.1659 |
| 516.1658 | 516.1658 |
| 516.1657 | 516.1657 |
| 516.1656 | 516.1656 |
| 516.1655 | 516.1655 |
| 516.1654 | N/A      |
| 516.1653 | 516.1653 |
| 516.1652 | 516.1652 |
| 516.1651 | 516.1651 |
| 516.1650 | 516.1650 |
| 516.1649 | 516.1649 |
| 516.1648 | 516.1648 |
| 515.*    | 515.*    |
| 514.*    | 514.*    |

*except `515.1612` on Linux as there was no release*

## supported tracy versions
`0.8.1` `0.8.2` `0.9.0` `0.9.1` `0.10.0` `0.11.0` `0.11.1` `0.12.0` `0.13.0` `0.13.1`

## usage
simply call `init` from `prof.dll` to begin collecting profile data and connect using [tracy-server](https://github.com/wolfpld/tracy/releases) `Tracy.exe`
```ts
/proc/prof_init()
	var/lib

	switch(world.system_type)
		if(MS_WINDOWS) lib = "prof.dll"
		if(UNIX) lib = "libprof.so"
		else CRASH("unsupported platform")

	var/init = call_ext(lib, "init")()
	if("0" != init) CRASH("[lib] init error: [init]")

/world/New()
	prof_init()
	. = ..()
```

## env vars
set these env vars before launching dreamdaemon to control which node and service to bind
```sh
UTRACY_BIND_ADDRESS
```

```sh
UTRACY_BIND_PORT
```

## building

You can download a precompiled byond-tracy executable from the [latest release](https://github.com/spacestation13/byond-tracy/releases/latest).

The Linux one is unlikely to work on your system. No guarantee or warranty given for the binaries.

no build system included, simply invoke your preferred c11 compiler.
examples:
```sh
cl.exe /nologo /std:c11 /O2 /LD /DNDEBUG prof.c ws2_32.lib /Fe:prof.dll
```

```sh
clang.exe -std=c11 -m32 -shared -Ofast3 -DNDEBUG -fuse-ld=lld-link prof.c -lws2_32 -o prof.dll
```

```sh
gcc -std=c11 -m32 -shared -fPIC -Ofast -s -DNDEBUG prof.c -pthread -o libprof.so
```

## developing

To add offsets (required for every new BYOND version), you find them here: https://spacestation13.github.io/byond-tracy-offset-extractor

It's already in copypaste form for the `offsets/` headers (non-experimental). Be sure to update the README table.

Then just PR it and maybe ping ZeWaka in #tooling-questions to merge it.

## LICENSE

[BSD 2-Clause](./LICENSE), originally forked from https://github.com/mafemergency/byond-tracy
