
Install:
----------------------------------------
Place the following files in:
~/Library/Application Support/Adobe/Flash CS5/en_US/Configuration/WindowSWF/

Diversion Tile Editor.swf
base_lib.fla
stage_monitor.jsfl
tileeditor.jsfl


Run
----------------------------------------
To access the panel in Flash CS5:
- load sample_lib.fla
- goto Window : Other Panels : Diversion Tile Editor


Notes:
----------------------------------------
- Creating a new tile while editing another symbol will add it to that symbols timeline (this needs to be fixed)
- New Tile creation needs to be streamlined.  Right now UI elements have multiple use cases which seems bad to me.
- I'd like to move the '_templates' symbols into an external library that can be accessed behind the scenes.  To keep the library a bit cleaner.