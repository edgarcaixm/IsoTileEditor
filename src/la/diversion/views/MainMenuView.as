/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 2, 2011
 *
 */

package la.diversion.views {
	import flash.desktop.NativeApplication;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.NativeWindow;
	import flash.events.Event;
	import flash.filesystem.File;
	
	import mx.core.UIComponent;
	
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;
	
	public class MainMenuView extends UIComponent {
		
		public var eventAddedToStage:NativeSignal;
		public var file:File;
		
		private var _eventFileSave:Signal;
		private var _eventFileNew:Signal;
		
		public function MainMenuView()
		{
			super();
			
			eventAddedToStage = new NativeSignal(this, Event.ADDED_TO_STAGE, Event);
			eventAddedToStage.addOnce(init);
		}
		
		public function get eventFileNew():Signal
		{
			return _eventFileNew  ||= new Signal();
		}

		public function get eventFileSave():Signal
		{
			return _eventFileSave  ||= new Signal();
		}

		public function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			var fileMenu:NativeMenuItem;
			var editMenu:NativeMenuItem;
			
			//windows support
			if (NativeWindow.supportsMenu) {
				stage.nativeWindow.menu.addEventListener(Event.SELECT, selectCommandMenu);
				
				fileMenu = getMenuItemByLabel(stage.nativeWindow.menu, "File");
				if (fileMenu == null){
					fileMenu = stage.nativeWindow.menu.addItem(new NativeMenuItem("File"));
				}
				createFileMenu(fileMenu);
				
				editMenu = getMenuItemByLabel(stage.nativeWindow.menu, "Edit");
				if (editMenu == null){
					editMenu = stage.nativeWindow.menu.addItem(new NativeMenuItem("Edit"));
				}
				createEditMenu(editMenu);
			}
			
			//mac support
			if (NativeApplication.supportsMenu){
				NativeApplication.nativeApplication.menu.addEventListener(Event.SELECT, selectCommandMenu);
				
				fileMenu = getMenuItemByLabel(NativeApplication.nativeApplication.menu, "File");
				if (fileMenu == null){
					fileMenu = NativeApplication.nativeApplication.menu.addItem(new NativeMenuItem("File"));
				}
				createFileMenu(fileMenu);
				
				editMenu = getMenuItemByLabel(NativeApplication.nativeApplication.menu, "Edit");
				if (editMenu == null){
					editMenu = NativeApplication.nativeApplication.menu.addItem(new NativeMenuItem("Edit"));
				}
				createEditMenu(editMenu);
			}
		}
		
		private function getMenuItemByLabel(menu:NativeMenu, labelName:String):NativeMenuItem {
			var count:uint = menu.items.length;
			for(var i:uint=0; i < count; i++){
				var item:NativeMenuItem = menu.getItemAt(i);
				if(item.label === labelName) return item;
			}
			return null;
		}
		
		public function createFileMenu(fileMenu:NativeMenuItem):void {
			var newCommand:NativeMenuItem = fileMenu.submenu.addItem(new NativeMenuItem("New"));
			newCommand.addEventListener(Event.SELECT, selectCommand);
			var saveCommand:NativeMenuItem = fileMenu.submenu.addItem(new NativeMenuItem("Save"));
			saveCommand.addEventListener(Event.SELECT, selectCommand);
		}
		
		public function createEditMenu(editMenu:NativeMenuItem):void {
			
			//TODO - these exist as native mac menu items, do we need to create them for windows??
			/*
			var copyCommand:NativeMenuItem = editMenu.submenu.addItem(new NativeMenuItem("Copy"));
			copyCommand.addEventListener(Event.SELECT, selectCommand);
			copyCommand.keyEquivalent = "c";
			
			var pasteCommand:NativeMenuItem = editMenu.submenu.addItem(new NativeMenuItem("Paste"));
			pasteCommand.addEventListener(Event.SELECT, selectCommand);
			pasteCommand.keyEquivalent = "v";
			
			editMenu.submenu.addItem(new NativeMenuItem("", true));
			var preferencesCommand:NativeMenuItem =	editMenu.submenu.addItem(new NativeMenuItem("Preferences"));
			preferencesCommand.addEventListener(Event.SELECT, selectCommand);
			*/
			
		}
		
		//catch custom menu items
		private function selectCommand(event:Event):void {
			trace("Selected command: " + event.target.label);
			switch (event.target.label) {
				case "Save":
					file = new File();
					file.addEventListener(Event.SELECT, onSave);
					file.browseForSave("Save Scene");
					//eventFileSave.dispatch();
					break;
				case "New":
					eventFileNew.dispatch();
					break;
				default:
					break;
			}
			
		}
		
		private function onSave(event:Event):void{
			file.removeEventListener(Event.SELECT, onSave);
			eventFileSave.dispatch(file);
		}
		
		//catch native menu command selections (copy, paste, etc)
		private function selectCommandMenu(event:Event):void {
			if (event.currentTarget.parent != null) {
				var menuItem:NativeMenuItem =
					findItemForMenu(NativeMenu(event.currentTarget));
				if (menuItem != null) {
					trace("Select event for \"" + 
						event.target.label + 
						"\" command handled by menu: " + 
						menuItem.label);
				}
			} else {
				trace("Select event for \"" + 
					event.target.label + 
					"\" command handled by root menu.");
			}
		}
		
		private function findItemForMenu(menu:NativeMenu):NativeMenuItem {
			for each (var item:NativeMenuItem in menu.parent.items) {
				if (item != null) {
					if (item.submenu == menu) {
						return item;
					}
				}
			}
			return null;
		}
	}
}