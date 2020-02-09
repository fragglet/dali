@echo off

rem ######################################################################
rem
rem Configuration options
rem

rem To use a static IP address, change this to n and edit mtcp.cfg with
rem the IP address settings to use for your machine.
set use_dhcp=y

rem The DOSbox server to connect to.
set server=ipx.soulsphere.org
set server_port=10000

rem Once your setup is confirmed to work correctly, set this to n to disable
rem the Internet connection check.
set check_connected=y

rem ######################################################################
rem
rem Packet driver
rem 
rem To communicate over the network you need a packet driver for your DOS
rem machine. The driver to use depends on the type of network card that
rem you have in your machine. Note that we're talking about a real DOS
rem setup here - this won't work on Windows 9x. If you're using Windows
rem 9x you'll want to get something working using the Windows networking
rem stack instead.
rem 
rem Setting up the packet driver is usually a matter of running it,
rem sometimes with some mandatory command line arguments, but it entirely
rem depends on the driver and it's hard to give any specific instructions.
rem
rem It's assumed the packet driver will be at vector 0x60. If you use a
rem different interrupt vector you'll need to edit mtcp.cfg to match.
rem 
rem Here are some resources for DOS packet drivers:
rem 
rem * Look for the Crynwr packet driver collection, usually distributed as
rem   `pktd11a.zip`, `pktd11b.zip`, `pktd11c.zip`. This collection includes
rem   a large number of high-quality drivers for common network driver types.
rem 
rem * Georg Potthast's website contains a number of packet drivers for later
rem   cards not found in the Crynwr collection:
rem 
rem   http://www.georgpotthast.de/sioux/packet.htm
rem 
rem * Michael Brutman's website has a useful page about DOS packet drivers:
rem 
rem   https://www.brutman.com/Dos_Networking/

rem The following is just an example you might use if you had an NE2000 card:
rem ne2000 0x60 3 0x300

rem ######################################################################
rem
rem TCP/IP configuration
rem
rem By default we use DHCP to acquire an IP address and default route from
rem the network. To use a static configuration instead, change use_dhcp to
rem n instead.

set MTCPCFG=mtcp.cfg
if "%use_dhcp%"=="n" goto nodhcp
dhcp
if errorlevel 1 goto badnetwork
:nodhcp

rem ######################################################################
rem
rem Check Internet connection
rem
rem We ping the Google honest DNS service and check we get a reply.
if "%check_connected%"=="n" goto connect
ping -count 1 8.8.8.8
if errorlevel 1 goto badnetwork
echo.
echo Your Internet connection is working.
echo.

rem ######################################################################
rem
rem Connect to server
rem
:connect
dali %server% %server_port%
goto end

:badnetwork
echo Error with your network connection. Check that your packet driver is
echo loaded and configured correctly, all cables are connected, and, if
echo using statically assigned IP configuration, the settings in mtcp.cfg
echo are correct.

:end

