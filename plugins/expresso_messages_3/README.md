README - Expresso Messages (Expresso Messages Plugin)
================================

Expresso Messages is a plugin to allow the user to interact with Expressov3 inbox


INSTALL
=======

Dependences
-----------

See the Noosfero install file. After install Noosfero, install expressov3 dependences:

$ gem install expressov3

Enable Plugin
-------------

Also, you need to enable LDAP Plugin at you Noosfero:

cd <your_noosfero_dir>
./script/noosfero-plugins enable ldap

Active Plugin
-------------

As a Noosfero administrator user, go to administrator panel:

- Click on "Enable/disable plugins" option
- Click on "LDAP Plugin" check-box


DEVELOPMENT
===========

Get the LDAP (Noosfero with LDAP Plugin) development repository:

$ git clone https://gitorious.org/+noosfero/noosfero/ldap

Running LDAP tests
--------------------

Configure the ldap server creating the file 'plugins/ldap/fixtures/ldap.yml'.
A sample file is offered in 'plugins/ldap/fixtures/ldap.yml.dist'

$ rake test:noosfero_plugins:ldap


Get Involved
============

If you found any bug and/or want to collaborate, please send an e-mail to leandronunes@gmail.com

LICENSE
=======

Copyright (c) The Author developers.

See Noosfero license.


AUTHORS
=======

 Leandro Nunes dos Santos (leandronunes at gmail.com)

ACKNOWLEDGMENTS
===============

The author have been supported by Serpro
