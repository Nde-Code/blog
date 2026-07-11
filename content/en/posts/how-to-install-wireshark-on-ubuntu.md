---
title: "Secure installation of Wireshark on Ubuntu"
date: 2026-07-11
draft: true
tags: ["Wireshark", "Ubuntu", "Linux"]
categories: ["Linux", "Wireshark", "Networking"]
author: "Nathan Debilloëz"
description: "A complete, secure, and reproducible guide to installing Wireshark on Ubuntu without using sudo."
---

# Introduction:

[Wireshark](https://www.wireshark.org/) is the most widely used network capture and analysis tool in the world. It has become essential in system administration, cybersecurity, network diagnostics, and education thanks to several key strengths:

- **Very easy to use:** Wireshark provides a clean, intuitive, and well‑organized graphical interface. Even without prior experience, users can start capturing and analyzing packets within minutes.

- **Free and open‑source:** the project is fully open: its source code is available on GitLab ([https://gitlab.com/wireshark/wireshark](https://gitlab.com/wireshark/wireshark)) and mirrored on GitHub ([https://github.com/wireshark/wireshark](https://github.com/wireshark/wireshark)). This transparency ensures strong security and continuous development.

- **Extremely complete and optimized:** Wireshark supports hundreds of network protocols, from the most common to the most specialized. It allows deep inspection down to the hexadecimal or binary level and offers numerous advanced features: powerful filters, detailed statistics, stream reconstruction, anomaly detection, and more. It meets the needs of all users, from beginners to professionals.

This guide explains how to install Wireshark cleanly, up‑to‑date, and securely on Ubuntu, enabling packet capture **without sudo** by using the `wireshark` group and the Linux *capabilities* assigned to the `dumpcap` binary.

> It was written after performing the installation on an Ubuntu system, one of the Linux distributions where Wireshark works most efficiently, but the same principles apply to most Debian‑based distributions.

# Description of the installation procedure:

Make sure you fully understand everything explained in this guide. Above all, avoid simply copying and pasting without thinking, it’s pointless and won’t help you identify the root cause of an issue if something goes wrong.

## 1. Add the official Wireshark PPA (stable and up‑to‑date):

Before installing Wireshark, it is recommended to add the official repository maintained by the development team.  
This PPA provides stable, recent, and properly packaged versions of Wireshark for Ubuntu.

To add it to your system, run the following commands (they require superuser privileges):
```bash
sudo add-apt-repository ppa:wireshark-dev/stable
sudo apt update
```

Adding this PPA ensures that Wireshark will be installed, and kept up to date, with the latest stable version available, rather than the sometimes older version included in Ubuntu's default repositories.

> I won't go into detail here about what a PPA is. I may cover it more thoroughly in a dedicated article later. For now, simply remember that a PPA is an additional software repository that allows you to obtain more recent versions than those provided by Ubuntu.

## 2. Install Wireshark:

Installing Wireshark is straightforward using `apt`:
```bash
sudo apt install wireshark
```

During the installation, Ubuntu will display an important prompt:

- *Allow non-superusers to capture packets?*

> (which means: *allow non‑administrator users to capture network packets*)

You should select: `Yes`

This option enables a secure and modern configuration in which only the capture engine (`dumpcap`) receives the necessary network permissions.

As a result, Wireshark can be used **without sudo**, while still following recommended security best practices.

## 3. Add your user to the secure `wireshark` group:

To capture packets **without using sudo**, you need to add your user (`$USER`) to the system group `wireshark`.

This group is specifically designed to grant capture permissions in a secure and controlled way.

On Linux, a *group* is a set of users who share specific permissions: the `wireshark` group allows network packet capture without granting full administrator privileges.

To perform this operation, run the following command:
```bash
sudo usermod -aG wireshark $USER
```

Once this command has been executed, the changes will only take effect after you log out and log back in to your user session. This step is essential for the group assignment to be properly applied.

## 4. Verify that the permissions are correct:

After adding your user to the `wireshark` group, it is important to ensure that the applied configuration matches what is expected.

We will now check the *capabilities* of the capture engine `dumpcap`, which is the only component of Wireshark allowed to access network interfaces directly.

To do this, run the following command:
```bash
getcap /usr/bin/dumpcap
```

This command should return:
```text
/usr/bin/dumpcap cap_net_admin,cap_net_raw=eip
```

This result indicates that only `dumpcap` has the required network permissions, and not Wireshark itself.

This is exactly the intended configuration: it ensures secure use of the software while still allowing packet capture **without sudo**.

> You can also verify that you are part of the `wireshark` group by running: `groups | grep "wireshark"`. If the terminal displays `wireshark` (often highlighted depending on your theme), it means the group assignment was applied correctly.

## 5. Launch Wireshark without `sudo`:

We have now reached the end of the guide: you can launch Wireshark directly from your terminal by typing:
```bash
wireshark
```

If the application starts correctly and you are able to capture packets, everything is working as expected: your installation is both functional and secure.

You can also pin Wireshark to the Ubuntu *Dock* or launch it from the search bar.

If Wireshark does not start or cannot capture packets, it is possible that one of the previous steps was not applied correctly.  
In that case, you can calmly go through the guide again from the beginning, or perform a few online searches to identify the root cause (permissions, missing group assignment, incorrect capabilities, ...).

# (Bonus) 6. Fix Wireshark's icon in the *Dock*:

On certain versions of Ubuntu, Wireshark's icon may appear as a generic placeholder when pinned to the *Dock*.  
This behavior occurs because the window class name does not match the `.desktop` file used by GNOME.

To fix this issue, simply edit Wireshark's launcher file:
```bash
sudo gnome-text-editor /usr/share/applications/org.wireshark.Wireshark.desktop
```

In the file that opens, add the following line at the end:
```
StartupWMClass=Wireshark
```

Save the file, then restart Wireshark.

The icon should now display correctly in the Dock.

> To be fully transparent, I did not encounter this issue myself with the version of Ubuntu mentioned at the beginning of the article.

# Sources:

- [https://askubuntu.com/questions/700712/how-to-install-wireshark](https://askubuntu.com/questions/700712/how-to-install-wireshark)

- [https://launchpad.net/~wireshark-dev/+archive/ubuntu/stable](https://launchpad.net/~wireshark-dev/+archive/ubuntu/stable)

- [https://www.youtube.com/watch?v=vd9dsMtWJmI](https://www.youtube.com/watch?v=vd9dsMtWJmI)
