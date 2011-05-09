OCDtv
=====

What is it?
-----------
As unglorious as it is, it's basically a file mover.

I've had an old version of this written in python laying around forever, keeping my tv files organized. The code wasn't horrible, but the configuration was far too laborious. You had to tell it how each of the shows' folders were layed out. This version does not have that 'feature', instead it looks for what the folders should be named based on the file name.

I run it as a cron job once a day on my media server to keep fresh files in the top level directory, moving them into subdirectories after a few days.

Configuration
-------------
See 'config.yml'. Mostly just point it at the base directory of your media, and decide how long you want to keep files. Default is 3 days.
