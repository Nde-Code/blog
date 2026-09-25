---
title: "Secure Wireshark Installation on Ubuntu"
date: 2026-07-11
draft: false
tags: ["Wireshark", "Ubuntu", "Linux"]
categories: ["Linux", "Wireshark", "Networking"]
author: "Nathan Debilloëz"
description: "A complete, secure, and reproducible guide to installing Wireshark on Ubuntu without sudo."
---

# Introduction:

[Wireshark](https://www.wireshark.org/) is one of the leading tools for capturing and analyzing network traffic. Thanks to its extensive feature set and versatility, it has become a reference tool in many fields, including system administration, cybersecurity, network troubleshooting, and education. Its popularity is largely due to several key strengths:

- **Simple to get started:** its intuitive interface makes it easy to perform your first packet captures quickly.

- **Free and *open source*:** the project is completely free and *open source*. Its source code is available on [GitLab](https://gitlab.com/wireshark/wireshark) and mirrored on [GitHub](https://github.com/wireshark/wireshark). This transparency makes security audits easier and contributes to the software's continuous improvement.

- **Extremely comprehensive and optimized:** Wireshark supports hundreds of network protocols, from the most common to highly specialized ones. It provides detailed analysis down to the hexadecimal or binary level and offers many advanced features, including powerful filters, detailed statistics, stream reconstruction, anomaly detection, and more. It therefore meets the needs of everyone from beginners to experienced professionals.

This guide explains how to install Wireshark on Ubuntu in a clean, up-to-date, and secure manner, while allowing packet capture **without `sudo`** by using the `wireshark` group and the Linux *capabilities* assigned to the `dumpcap` binary.

> This guide was written after installing Wireshark on an Ubuntu system (24.04.4 LTS), one of the most widely used Linux distributions. However, the same principles generally apply to most Debian-based distributions.

# Installation Procedure:

Avoid blindly copying and pasting commands: understanding what they do will make it easier to diagnose potential issues.

For this guide, I also assume that your system is up to date — in other words, that `sudo apt update && sudo apt upgrade -y` has already been run — and that you are reasonably comfortable using Linux and the terminal.

## 1. Add the Wireshark PPA:

For this installation, we will use the *PPA* maintained by the Wireshark development team.

This *PPA* provides newer stable releases, which are often more up to date than the versions available in the standard Ubuntu repositories.

To add it to your system, run the following commands one at a time. They require administrator privileges:

```bash
sudo add-apt-repository ppa:wireshark-dev/stable
sudo apt update
```

I won't go into further detail about how a *PPA* works in this guide. I may cover the topic in more depth in a dedicated article. For now, all you need to know is that a *PPA* is an additional software repository that can, among other things, provide newer versions of certain applications than those available in Ubuntu's official repositories.

## 2. Install Wireshark:

Installing Wireshark is straightforward with `apt`:

```bash
sudo apt install wireshark
```

During the installation, Ubuntu displays an important question:

- Allow non-superusers to capture packets?

It is recommended to answer: `Yes`

> If you answer `No`, you can still change this setting later by reconfiguring the `wireshark-common` package.

This option enables a secure and modern configuration: only `dumpcap` is granted the Linux *capabilities* required for packet capture (`CAP_NET_RAW` and `CAP_NET_ADMIN`), while the graphical interface runs without any special privileges.

## 3. Add Yourself to the `wireshark` Group:

To capture packets **without using `sudo`**, you need to add your user (`$USER`) to the `wireshark` system group. This group is specifically intended to grant the permissions required for packet capture without giving Wireshark administrator privileges.

On Linux, a *group* is a collection of users to which specific permissions can be assigned. The `wireshark` group allows network capture without granting full administrator privileges.

To do this, run the following command:

```bash
sudo usermod -aG wireshark $USER
```

Once the command has been executed, the changes will only take effect after logging out and back into your user session. This step is essential for the group membership change to be properly applied.

## 4. Verify the Permissions:

After adding your user to the `wireshark` group, it is important to verify that the configuration has been applied as expected.

We will therefore check the *capabilities* assigned to the `dumpcap` capture engine, the Wireshark component responsible for network capture and the one that receives the necessary privileges.

To do this, run the following command:

```bash
getcap /usr/bin/dumpcap
```

This command displays the *capabilities* currently assigned to `dumpcap`. You should find the network permissions required for packet capture among them.

With this configuration, Wireshark can perform packet captures through its graphical interface without requiring administrator privileges.

If the command returns no output, it means that the *capabilities* have not been assigned to `dumpcap`. In that case, you need to reconfigure the `wireshark-common` package.

> You can also verify that your user belongs to the `wireshark` group by running: `groups | grep "wireshark"`. If the terminal displays `wireshark` (often highlighted in color depending on your theme), it means that the group membership has been configured correctly.

## 5. Launch Wireshark Without `sudo`:

We have now reached the end of the guide. You can launch Wireshark directly from your terminal without administrator privileges:

```bash
wireshark
```

If the application starts correctly and you can capture packets, your installation is working properly. Wireshark is then using the intended mechanism: only the `dumpcap` capture engine has the necessary network permissions, while the graphical interface runs with your regular user privileges.

To display the currently installed version of Wireshark, run:

```bash
wireshark --version
```

You can also verify that `dumpcap` can access the available network interfaces:

```bash
dumpcap -D
```

This command lists the capture interfaces detected by `dumpcap`. If they are displayed correctly, this confirms that the capture engine has the permissions required to access them. You can then pin Wireshark to the Ubuntu *Dock* or launch it directly from the application search bar.

If not, it is possible that one of the configuration steps was not applied correctly. In that case, check the following:

- your membership in the `wireshark` group;
- the *capabilities* assigned to `dumpcap`;
- the presence and configuration of the Wireshark *PPA*;
- whether all required packages have been installed correctly.

# Conclusion:

You now have a clean, secure Wireshark installation that follows Linux best practices. Using the `wireshark` group and the *capabilities* assigned to `dumpcap` allows you to capture packets **without relying on `sudo`**, while maintaining a high level of security.

# Sources:

- https://www.wireshark.org/docs/wsug_html_chunked/

- https://launchpad.net/~wireshark-dev/+archive/ubuntu/stable

- https://askubuntu.com/questions/700712/how-to-install-wireshark

- https://www.youtube.com/watch?v=vd9dsMtWJmI
