# Fedora Linux Install Scripts
## By Budhditya Saha (C) 2021


#### Introduction
The collections of scripts are for the ease of installation of Fedora when you install a fresh system. The package list is kept minimal.

The scripts are intentionally kept in a totally modular way, to customize the type of install.

Scripts like Themes and Fonts have defaults pre-defined per my preferences. Please feel free to edit as per taste.

I have added user choices wherever there is a requirement (Neovim and Fonts).

The source files which are downloaded during installation are kept as is. However, choosing option 10 does a total clean up of the sources.

#### Installation

> `git clone https://github.com/Slackd/Fedora_Linux_Scripts.git FedoraInstaller`
> 
> `cd FedoraInstaller/scripts`
> 
> `./main.sh` `# Choose options from 1-10 on which set of packages you want to install.`
> 

#### Macbook Specific Drivers for Custom Kernels (Facetime HD & Broadcom-WiFi)

*Tested on MacBook Pro Late 2015 with the following hardware:*


```
- Broadcom Inc. and subsidiaries 720p FaceTime HD - Camera
- Broadcom Inc. and subsidiaries BCM4360 802.11ac Wireless Network Adapter (rev 03)
```

##### *Please be careful while performing these steps*


1) For FaceTimeHD Camera (Read Instructions >) - https://github.com/patjak/bcwc_pcie/wiki/Installation#get-started-on-fedora

- Or Run the `facetime.sh` script in my cloned scripts folder.

2) For Broadcom WiFi

- Stock Kernel - `sudo dnf install broadcom-wl -y`

- Custom Kernels - https://github.com/antoineco/broadcom-wl

##### TODO
[] Write Custom Kernel Compilation Guide.
[] Add some more packages in media.
[] Check complete compatibility with F34 when released (Works now. Do NOT use the neovim script. Nodesource is not updated with F34 Repos).
