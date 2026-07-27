## Dedicated

```bash
nvidia-smi --query-gpu=clocks.sm,clocks.mem,pstate,power.draw,utilization.gpu --format=csv -l 1

1575 MHz, 6000 MHz, P0, 35.95 W, 38 %
1365 MHz, 6000 MHz, P0, 35.07 W, 26 %
1275 MHz, 6000 MHz, P0, 34.78 W, 37 %
1215 MHz, 6000 MHz, P0, 32.53 W, 36 %
1245 MHz, 6000 MHz, P0, 33.98 W, 38 %
1275 MHz, 6000 MHz, P0, 34.13 W, 39 %
1275 MHz, 6000 MHz, P0, 35.36 W, 36 %
```

```bash
systemctl status nvidia-persistenced

Unit nvidia-persistenced.service could not be found.
```

```bash
hyprctl clients | grep -i minecraft -A 10

Window 5a566da53200 -> Minecraft* 1.20.1 - Singleplayer:
	mapped: 1
	hidden: 0
	visible: 1
	acceptsInput: 1
	at: 0,0
	size: 1920,1080
	workspace: 2 (2)
	floating: 0
	monitor: 0
	class: Minecraft* 1.20.1
	title: Minecraft* 1.20.1 - Singleplayer
	initialClass: Minecraft* 1.20.1
	initialTitle: Minecraft* 1.20.1
	pid: 14221
	xwayland: 1 # tis xwayland
```

don't have nvidia-settings btw.

## Hybrid

```bash
nvidia-smi --query-gpu=clocks.sm,clocks.mem,pstate,power.draw,utilization.gpu --format=csv -l 1

675 MHz, 5000 MHz, P3, 24.91 W, 32 %
750 MHz, 5000 MHz, P3, 24.86 W, 37 %
795 MHz, 5000 MHz, P3, 25.81 W, 35 %
795 MHz, 5000 MHz, P3, 24.18 W, 36 %
975 MHz, 5000 MHz, P3, 26.66 W, 31 %
```

```bash
systemctl status nvidia-persistenced

Unit nvidia-persistenced.service could not be found.
```

```bash
hyprctl clients | grep -i minecraft -A 10

Window 591bddc46b30 -> Minecraft* 1.20.1 - Singleplayer:
	mapped: 1
	hidden: 0
	visible: 1
	acceptsInput: 1
	at: 0,0
	size: 1920,1080
	workspace: 2 (2)
	floating: 0
	monitor: 0
	class: Minecraft* 1.20.1
	title: Minecraft* 1.20.1 - Singleplayer
	initialClass: Minecraft* 1.20.1
	initialTitle: Minecraft* 1.20.1
	pid: 2577
	xwayland: 1 # still xwayland
```

so what are we looking at here? also valheim in hybrid for scale:

```bash
1815 MHz, 6000 MHz, P0, 77.52 W, 67 %
1785 MHz, 6000 MHz, P0, 76.33 W, 66 %
1800 MHz, 6000 MHz, P0, 74.05 W, 61 %
1815 MHz, 6000 MHz, P0, 78.78 W, 67 %
1860 MHz, 6000 MHz, P0, 72.62 W, 62 %
1845 MHz, 6000 MHz, P0, 73.26 W, 53 %
1875 MHz, 6000 MHz, P0, 60.06 W, 57 %
```
