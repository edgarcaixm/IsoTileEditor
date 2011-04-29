
Install:
----------------------------------------
Place the following files in:
~/Library/Application Support/Adobe/Flash CS5/en_US/Configuration/WindowSWF/

Diversion Tile Editor.swf
events.jsfl
stage_monitor.jsfl
tileeditor.jsfl


Run
----------------------------------------
To access the panel in Flash CS5:
- load sample_lib.fla
- goto Window : Other Panels : Diversion Tile Editor


Notes:
----------------------------------------
- New Library creation isn't working yet, so the sample_lib is the only one that will reliably work right now.
- Renaming items from the library panel will lead to bad things.
- Creating a new tile while editing another symbol will add it to that symbols timeline (this needs to be fixed)
- New Tile creation needs to be streamlined so its not repurposing tile properties
- I'd like to move the basetile symbols into an external library that can be accessed behind the scenes.  To keep the library a bit cleaner.