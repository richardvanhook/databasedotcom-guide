databasedotcom gem guide
============

How to build the Guide
----------------------

Before you can translate the guide into various formats you need to install the dependencies.

    gem install bundler
    bundle install

In the root directory, launch the following Thor task:

    thor guide:build

This will install an HTML version of the guide in the output folder

To build a LaTeX or PDF version you have to use this task:

    thor guide:build latex
    # or
    thor guide:build pdf

