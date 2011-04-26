/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: chris
 * Created: Apr 26, 2011
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
	
	public class MainMenu extends UIComponent {
		public function MainMenu() {
			super();
			addEventListener(Event.ADDED_TO_STAGE, init)
		}
		
		public function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			var fileMenu:NativeMenuItem;
			var editMenu:NativeMenuItem;
			
			if (NativeWindow.supportsMenu) {
				stage.nativeWindow.menu = new NativeMenu();
				stage.nativeWindow.menu.addEventListener(Event.SELECT, selectCommandMenu);
				fileMenu = stage.nativeWindow.menu.addItem(new NativeMenuItem("File"));
				fileMenu.submenu = createFileMenu();
				editMenu = stage.nativeWindow.menu.addItem(new NativeMenuItem("Edit"));
				editMenu.submenu = createEditMenu();
			}
			
			if (NativeApplication.supportsMenu){
				NativeApplication.nativeApplication.menu.addEventListener(Event.SELECT, selectCommandMenu);
				fileMenu = NativeApplication.nativeApplication.menu.addItem(new NativeMenuItem("File"));
				fileMenu.submenu = createFileMenu();
			}
		}
		
		public function createFileMenu():NativeMenu {
			var fileMenu:NativeMenu = new NativeMenu();
			fileMenu.addEventListener(Event.SELECT, selectCommandMenu);
			
			//var newCommand:NativeMenuItem = fileMenu.addItem(new NativeMenuItem("New"));
			//newCommand.addEventListener(Event.SELECT, selectCommand);
			var saveCommand:NativeMenuItem = fileMenu.addItem(new NativeMenuItem("Save"));
			saveCommand.addEventListener(Event.SELECT, selectCommand);
			//var openRecentMenu:NativeMenuItem = 
			//	fileMenu.addItem(new NativeMenuItem("Open Recent")); 
			//openRecentMenu.submenu = new NativeMenu();
			//openRecentMenu.submenu.addEventListener(Event.DISPLAYING,
		//		updateRecentDocumentMenu);
			//openRecentMenu.submenu.addEventListener(Event.SELECT, selectCommandMenu);
			
			return fileMenu;
		}
		
		public function createEditMenu():NativeMenu {
			var editMenu:NativeMenu = new NativeMenu();
			editMenu.addEventListener(Event.SELECT, selectCommandMenu);
			
			var copyCommand:NativeMenuItem = editMenu.addItem(new NativeMenuItem("Copy"));
			copyCommand.addEventListener(Event.SELECT, selectCommand);
			copyCommand.keyEquivalent = "c";
			var pasteCommand:NativeMenuItem = 
				editMenu.addItem(new NativeMenuItem("Paste"));
			pasteCommand.addEventListener(Event.SELECT, selectCommand);
			pasteCommand.keyEquivalent = "v";
			editMenu.addItem(new NativeMenuItem("", true));
			var preferencesCommand:NativeMenuItem = 
				editMenu.addItem(new NativeMenuItem("Preferences"));
			preferencesCommand.addEventListener(Event.SELECT, selectCommand);
			
			return editMenu;
		}
		
		private function updateRecentDocumentMenu(event:Event):void {
			trace("Updating recent document menu.");
			var docMenu:NativeMenu = NativeMenu(event.target);
			
			for each (var item:NativeMenuItem in docMenu.items) {
				docMenu.removeItem(item);
			}
		}
		
		private function selectRecentDocument(event:Event):void {
			trace("Selected recent document: " + event.target.data.name);
		}
		
		private function selectCommand(event:Event):void {
			trace("Selected command: " + event.target.label);
			switch (event.target.label) {
				case "Save":
					dispatchEvent(new Event("Save"));
					break;
				default:
					break;
			}
			
		}
		
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
