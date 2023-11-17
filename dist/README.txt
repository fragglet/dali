
This is Dali, a DOS program to connect to a DOSbox tunneling server
using a packet driver. It is based on Michael Brutman's mTCP stack.

========================================================================

NOTE: You can only use this program under real DOS; it cannot be used
      under Windows (unless you restart into DOS mode first). For
      connecting to a DOSbox server via Windows 9x, you might want to
      check out ipxbox (by the same author as Dali), and specifically
      its network bridging and PPTP dialin features:

          <https://github.com/fragglet/ipxbox>

========================================================================

To use Dali, the most important thing you will need is a DOS packet
driver that works with your network card. Here are some resources for
DOS packet drivers:

 * Look for the Crynwr packet driver collection, usually distributed as
   `pktd11a.zip`, `pktd11b.zip`, `pktd11c.zip`. This collection includes
   a large number of high-quality drivers for common network driver types.

 * Georg Potthast's website contains a number of packet drivers for later
   cards not found in the Crynwr collection:

     <http://www.georgpotthast.de/sioux/packet.htm>

 * Michael Brutman's website has a useful page about DOS packet drivers:

     <https://www.brutman.com/Dos_Networking/>

To get started, make a copy of connect.bat and open it in your favorite
text editor. You'll want to change the following:

1. At the start of the file you'll see two configuration variables that
   you'll need to set to point at the IP address and port number of the
   DOSbox server you want to connect to.

     rem The DOSbox server to connect to.
     set server=ipx.soulsphere.org
     set server_port=10000

2. The next section is the "Packet driver" section. You'll want to
   add a line here that loads your packet driver. There is a commented-
   out example of the command you'd run to load the driver for the
   common Novell NE2000 card.

     rem The following is just an example...
     rem ne2000 0x60 3 0x300

3. Run your batch file. If things are working correctly you'll see
   something like the following:

     Your Internet connection is working.

     Connected successfully to ipx.soulsphere.org port 10000.
     Assigned address is 02:fe:38:e1:f8:99.
     To disconnect, run dali /u

     C:\DALI>

   If not, check the list of error messages below.

Potential problems
==================

The following are some potential error messages and what you can do to
resolve them:

1. " Init: could not setup packet driver
     Could not initialize TCP/IP stack "

  You have not loaded a packet driver. Check that:

   * You have a packet driver for your network card. There is a
     list of URLs above that can help you find a packet driver for your
     network card.
   * You are using the right packet driver for your card.
   * You've edited your version of connect.bat to run the driver (see
     instructions above).
   * The packet driver is loading correctly with no error message.
   * The "packetint" line in mtcp.cfg matches the interrupt vector
     you've loaded the driver at.

2. " Error: Your DHCP server never responded ... "

  The mTCP stack was unable to get an IP address. Check that:

   * Your packet driver configuration is all correct (see above).
   * The machine is connected to the network and all the appropriate
     Ethernet cables are plugged in.
   * The machine is connected to a network that has a DHCP server that
     can assign addresses (usually, your home Internet router). If not,
     you'll need to statically assign network configuration:
      - Change the use_dhcp variable to 'n' in your batch file.
      - Edit the configuration in mtcp.cfg to set the IPADDR, NETMASK,
        GATEWAY and NAMESERVER variables.

3. " Error resolving server address 'my.server.address' "

   * Check that you have set the "server" variable correctly in
     connect.bat with no typos and that NAMESERVER is set up correctly
     in mtcp.cfg (you can also try using Google Honest DNS: 8.8.8.8
     or 8.8.4.4).
   * If all else fails, try setting the "server" variable to an IP
     address instead of a DNS name.

4. " Error with your network connection. Check that your packet driver is
     loaded and configured correctly, all cables are connected, and, if
     using statically assigned IP configuration, the settings in mtcp.cfg
     are correct. "

  Before connecting to the server, the connect.bat batch file tries to
  contact a known IP address on the Internet to check that your
  connection is working properly. Check the following:

   * That you are connected to the Internet. If you're just using it on
     a local LAN without an Internet connection, you'll need to edit
     connect.bat and change the check_connected variable to "n".
   * That your network is configured correctly. See the advice under
     (1), (2) and (3) above.

5. " Error parsing environment for mTCP initialization. " or
   " Error initializing TCP/IP stack. "

  Something is wrong with the configuration for the mTCP stack. Check
  any changes you've made to the connect.bat and mtcp.cfg files and make
  sure there are no typos or incorrect formatting.

6. " No response from server at 1.2.3.4:10000 "

  Dali is not receiving any reply from the DOSbox server you're trying
  to connect to. Check that:

   * The DOSbox server is running correctly and that you've set
     the right IP address and port to connect to it.
   * There is no firewall set up on the server that is blocking
     connections (try connecting with a normal DOSbox client).
   * Appropriate port forwarding has been set up at the server side, if
     necessary (do an Internet search to learn about this; it is beyond
     the scope of this document).

7. " Error: Environment variable MTCPCFG is not set to contain the path to
     an mTCP configuration file. Instead of running this directly, consider
     running connect.bat which will take care of this and other steps. "

  This shouldn't usually happen if you're using the included batch file.
  If you don't want to use the batch file, refer to the mTCP
  documentation for how to configure the stack.

