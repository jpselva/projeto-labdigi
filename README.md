﻿# Note  Genius
How to load it in Quartus:

* Open `.qpf` file in Quartus;
* Navigate to  `tools > tcl scripts`, select `note_genius.tcl` and click `run`.

Now all pin assignments have been loaded and the project can be compiled and synthesized.
If  you modify the pin assignments and want to push them:

* Navigate to `Project > Generate tcl files for project`, make sure "Include default assignments is  selected", and overwrite the original `note_genius.tcl` by clicking `OK`.

