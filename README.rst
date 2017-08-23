=====
slurm
=====

Install the Slurm client, node and/or controller under CentOS 7.0.

.. note::

   We only tested under CentOS 7,0 we expect collaboration for new systems 
   See the full `Salt Formulas installation and usage instructions
   <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``slurm``
---------

Meta-state that includes the basic configuration for a client.

is not for computing nodes, only for install login nodes or clients
``slurm.node``
----------------

Configure and install ComputerNode

``slurm.server``
----------------

Install and configure the Controller.

CentOS family supports setting MySQL 


``slurm.slurmdbd``
------------------

If the accounting option is slurmdbd this state configure the services

