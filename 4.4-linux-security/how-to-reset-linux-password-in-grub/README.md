# password recovery


* Reboot your system and access the GRUB menu:

* press e
![img](img/1.png)

* Find the line that starts with linux (it will start with linux or linux16 and include the path to the kernel).

* Append init=/bin/bash to the end of this line. This tells the kernel to run /bin/bash instead of the default init system.

![img](img/2.png)

* Press Ctrl + X or F10 to boot with the modified parameters.

![img](img/3.png)


* remount the root filesystem as read-write
![img](img/4.png)

* now run passwd

```

passwd

```

* After changing the password, you can remount the root filesystem as read-only with:

![img](img/5.png)

* reboot the system
```
reboot -f

```