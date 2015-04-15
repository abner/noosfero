README - Expresso Messages (Expresso Messages Plugin)
================================

Expresso Messages is a plugin to allow the user to interact with Expressov3 inbox


INSTALL
=======

Enable Plugin
-------------

Also, you need to enable Expresso Plugin at your Noosfero instalation:

cd <your_noosfero_dir>
./script/noosfero-plugins enable expresso_messages_2

Active Plugin
-------------

As a Noosfero administrator user, go to administrator panel:

- Click on "Enable/disable plugins" option
- Click on "Expresso Messages Plugin" check-box


DEVELOPMENT
===========

Get the Expresso (Noosfero with Expresso Plugin) development repository:

$ git clone https://gitorious.org/+noosfero/noosfero/expresso_messages_2

Running Expresso Plugin tests
--------------------

Configure the expresso_messages_2 server creating the file 'plugins/expresso_messages_2/fixtures/expresso_messages_2.yml'.
A sample file is offered in 'plugins/expresso/fixtures/expresso_messages_2.yml.dist'

$ rake test:noosfero_plugins:expresso_messages_2


Get Involved
============

If you found any bug and/or want to collaborate, please send an e-mail to carloseugenio@gmail.com

LICENSE
=======

Copyright (c) The Author developers.

See Noosfero license.


AUTHORS
=======

 Carlos Eugênio Palma da Purificação (carloseugenio at gmail.com)

ACKNOWLEDGMENTS
===============

The author have been supported by Serpro
