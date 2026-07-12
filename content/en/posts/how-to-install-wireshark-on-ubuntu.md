---
title: "Secure installation of Wireshark on Ubuntu"
date: 2026-07-11
draft: false
tags: ["Wireshark", "Ubuntu", "Linux"]
categories: ["Linux", "Wireshark", "Networking"]
author: "Nathan Debilloëz"
description: "A complete, secure, and reproducible guide to installing Wireshark on Ubuntu without using sudo."
---

# Introduction:

[Wireshark](https://www.wireshark.org/) is the world's most widely used network protocol analyzer. It has become an essential tool for system administrators, cybersecurity professionals, network engineers, and educators thanks to several key advantages:

- **Easy to use:** its intuitive interface allows users to capture and analyze network traffic with minimal learning curve.

- **Free and open source:** Wireshark is fully open source. Its source code is available on GitLab ([https://gitlab.com/wireshark/wireshark](https://gitlab.com/wireshark/wireshark)) and mirrored on GitHub ([https://github.com/wireshark/wireshark](https://github.com/wireshark/wireshark)). This transparency makes security audits easier and enables continuous improvements from the community.

- **Feature-rich and highly optimized:** Wireshark supports hundreds of network protocols, from the most common to highly specialized ones. It provides in-depth packet analysis down to the hexadecimal and binary levels, along with powerful features such as advanced display filters, detailed statistics, stream reassembly, anomaly detection, and much more. Whether you are a beginner or an experienced professional, Wireshark offers the tools required for comprehensive network analysis.

This guide explains how to install Wireshark on Ubuntu using a clean, up-to-date, and secure approach. It also shows how to capture packets **without `sudo`** by configuring the `wireshark` group and assigning the required Linux *capabilities* to the `dumpcap` binary.

> This guide was written after performing the installation on an Ubuntu system (24.04.4 LTS), one of the most widely used Linux distributions. However, the same principles apply to most Debian-based distributions.

# Description of the installation procedure:

Avoid blindly copying and pasting commands. Understanding what each command does will make it much easier to troubleshoot any issues that may arise.

## 1. Add the Wireshark PPA (latest stable release):

If you want to use a newer version than the one provided by Ubuntu, you can add the PPA maintained by the Wireshark development team. This PPA provides the latest stable Wireshark releases before they are integrated into Ubuntu's official repositories.

To add it to your system, run the following commands (they require root privileges):
```bash
sudo add-apt-repository ppa:wireshark-dev/stable
sudo apt update
```

> I won't go into detail about PPAs in this guide. I may cover them more thoroughly in a dedicated article in the future. For now, simply remember that a PPA (Personal Package Archive) is an additional software repository that provides newer package versions than those available in Ubuntu's official repositories.

## 2. Install Wireshark:

Installing Wireshark is straightforward using `apt`:
```bash
sudo apt install wireshark
```

During the installation process, Ubuntu will display an important prompt:

- *Allow non-superusers to capture packets?*

It is recommended to answer: `Yes`

> If you choose `No`, you can still change this option later by reconfiguring the `wireshark-common` package.

This option enables a secure and modern configuration: only `dumpcap` is granted the required Linux *capabilities* (`CAP_NET_RAW` and `CAP_NET_ADMIN`), while the graphical interface runs without any special privileges.

As a result, Wireshark can be used **without `sudo`**, while following security best practices.

## 3. Add yourself to the `wireshark` security group:

To capture packets **without using `sudo`**, you need to add your user account (`$USER`) to the `wireshark` system group.

This group is specifically designed to grant packet capture permissions in a secure way.

On Linux, a *group* is a collection of users that share specific permissions. The `wireshark` group allows users to perform network captures without granting them full administrative privileges.

To add your user to the group, run the following command:
```bash
sudo usermod -aG wireshark $USER
```

Once this command has been executed, the changes will only take effect after logging out and logging back into your user session. This step is required for the group membership update to be properly applied.

## 4. Verify that the permissions are correctly configured:

After adding your user account to the `wireshark` group, it is important to verify that the applied configuration matches the expected setup.

We will therefore check the *capabilities* assigned to the packet capture engine `dumpcap`, the only Wireshark component allowed to directly access network interfaces.

To do this, run the following command:
```bash
getcap /usr/bin/dumpcap
```

The output should display the `cap_net_raw` and `cap_net_admin` *capabilities* assigned to `dumpcap`.

This confirms that only `dumpcap` has the required network permissions, rather than Wireshark itself.

This is the recommended configuration: it ensures secure use of the software while still allowing packet capture **without `sudo`**.

> You can also verify that your user account is a member of the `wireshark` group by running: `groups | grep "wireshark"`. If the terminal displays `wireshark` (often highlighted depending on your terminal theme), it means that the group membership has been successfully applied.

## 5. Launch Wireshark without `sudo`:

We have reached the end of the guide: you can now launch Wireshark directly from your terminal without administrative privileges:
```bash
wireshark
```

If the application starts correctly and you are able to capture packets, your installation is working properly. Wireshark is then using the Linux security model as intended: only the capture engine `dumpcap` has the required network permissions, while the graphical interface runs with your regular user privileges.

Before considering the installation complete, you can perform a few additional checks.

To display the currently installed version of Wireshark, run:
```bash
wireshark --version
```

This command displays the version of Wireshark currently installed on your system.

You can also verify that `dumpcap` can access the available network interfaces:
```bash
dumpcap -D
```

This command lists the capture interfaces detected by `dumpcap`. If they are displayed correctly, it confirms that the capture engine has the required permissions to access them.

You can then pin Wireshark to the Ubuntu *Dock* or launch it directly from the application search menu.

If it does not work as expected, a configuration step may not have been applied correctly. You can then check the following items:

* your membership in the `wireshark` group;
* the *capabilities* assigned to `dumpcap`;
* the presence and configuration of the Wireshark PPA;
* the correct installation of the required packages.

## (Bonus) 6. Fix the Wireshark icon in the *Dock*:

On some Ubuntu installations, the Wireshark icon may appear as a generic icon when it is pinned to the *Dock*.

This issue occurs when GNOME is unable to correctly associate the Wireshark window with its corresponding `.desktop` launcher file. Adding the `StartupWMClass` property restores this association and allows the correct icon to be displayed in the *Dock*.

To apply this fix properly, we will create a local copy of the Wireshark launcher file. This approach is preferable to directly modifying the system file, as it prevents your changes from being overwritten during future Wireshark updates.

First, create the local directory used for custom application launchers:
```bash
mkdir -p ~/.local/share/applications
```

Then copy the official Wireshark `.desktop` file to this directory:
```bash
cp /usr/share/applications/org.wireshark.Wireshark.desktop ~/.local/share/applications/
```

Now open the local copy of the file using GNOME Text Editor:
```bash
gnome-text-editor ~/.local/share/applications/org.wireshark.Wireshark.desktop
```

Add the following line at the end of the file:
```ini
StartupWMClass=Wireshark
```

Save the file, then completely close Wireshark if it is currently running.

If the incorrect icon is already present in the *Dock*, remove it and pin Wireshark again so that GNOME reloads the updated launcher file.

The correct icon should now be displayed.

> To be completely transparent, I did not encounter this issue on the Ubuntu version mentioned at the beginning of this article. This fix is therefore provided as a workaround for systems where GNOME does not correctly associate the application window with its `.desktop` launcher.

# Conclusion

By following this guide, you now have a clean, secure, and Linux‑compliant installation of Wireshark. Using the `wireshark` group together with the capabilities assigned to `dumpcap` enables packet capture without `sudo`, while maintaining a strong security posture.

# Sources:

- [https://www.wireshark.org/docs/wsug_html_chunked/](https://www.wireshark.org/docs/wsug_html_chunked/)

- [https://launchpad.net/~wireshark-dev/+archive/ubuntu/stable](https://launchpad.net/~wireshark-dev/+archive/ubuntu/stable)

- [https://askubuntu.com/questions/700712/how-to-install-wireshark](https://askubuntu.com/questions/700712/how-to-install-wireshark)

- [https://www.youtube.com/watch?v=vd9dsMtWJmI](https://www.youtube.com/watch?v=vd9dsMtWJmI)
