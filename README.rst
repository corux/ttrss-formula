=============
ttrss-formula
=============

.. image:: https://travis-ci.org/corux/ttrss-formula.svg?branch=master
    :target: https://travis-ci.org/corux/ttrss-formula

Installs the Tiny Tiny RSS web application.

Available states
================

.. contents::
    :local:

``ttrss``
---------

Installs the Tiny Tiny RSS web application. Includes ``ttrss.selinux``, if SELinux is enabled.

``ttrss.apache``
----------------

Adds a dependency to the apache formula and configures a ttrss site.

``ttrss.plugins``
-----------------

Installs Tiny Tiny RSS plugins.

``ttrss.selinux``
-----------------

Configures Tiny Tiny RSS to work with SELinux.
