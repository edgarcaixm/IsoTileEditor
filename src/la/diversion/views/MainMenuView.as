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
	
	import la.diversion.enums.IsoSceneViewModes;
	import la.diversion.models.components.Background;
	
	import mx.core.UIComponent;
	
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;
	
	public class MainMenuView extends UIComponent {
		
		//PUBLIC VARS
		public var eventAddedToStage:NativeSignal;
		public var file:File;
		
		//SIGNALS
		private var _eventFileSave:Signal;
		private var _eventFileOpen:Signal;
		private var _eventFileNew:Signal;
		private var _eventLoadAssetLibrary:Signal;
		private var _eventUpdateIsoSceneViewMode:Signal;
		private var _eventResetIsoSceneBackground:Signal;
		
		//PRIVATE VARS
		private var _isoViewModeCommands:Array = new Array();
		
		public function MainMenuView()
		{
			super();
			
			eventAddedToStage = new NativeSignal(this, Event.ADDED_TO_STAGE, Event);
			eventAddedToStage.addOnce(init);
		}
		
		public function get eventFileNew():Signal
		{
			return _eventFileNew ||= new Signal();
		}

		public function get eventFileSave():Signal
		{
			return _eventFileSave ||= new Signal();
		}

		public function get eventFileOpen():Signal
		{
			return _eventFileOpen ||= new Signal();
		}
		
		public function get eventLoadAssetLibrary():Signal
		{
			return _eventLoadAssetLibrary ||= new Signal();
		}

		public function get eventUpdateIsoSceneViewMode():Signal
		{
			return _eventUpdateIsoSceneViewMode ||= new Signal();
		}

		public function get eventResetIsoSceneBackground():Signal
		{
			return _eventResetIsoSceneBackground ||= new Signal();
		}

		public function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			var fileMenu:NativeMenuItem;
			var editMenu:NativeMenuItem;
			var windowMenu:NativeMenuItem;
			
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
				
				windowMenu = getMenuItemByLabel(stage.nativeWindow.menu, "Window");
				if (windowMenu == null){
					windowMenu = stage.nativeWindow.menu.addItem(new NativeMenuItem("Edit"));
				}
				createWindowMenu(windowMenu);
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
				
				windowMenu = getMenuItemByLabel(NativeApplication.nativeApplication.menu, "Window");
				if (windowMenu == null){
					windowMenu = NativeApplication.nativeApplication.menu.addItem(new NativeMenuItem("Window"));
				}
				createWindowMenu(windowMenu);
				
				
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
			var command:NativeMenuItem = fileMenu.submenu.addItem(new NativeMenuItem("", true));
			
			//command = fileMenu.submenu.addItem(new NativeMenuItem("New Map"));
			//command.addEventListener(Event.SELECT, selectCommand);
			command = fileMenu.submenu.addItem(new NativeMenuItem("Open Map..."));
			command.addEventListener(Event.SELECT, selectCommand);
			command = fileMenu.submenu.addItem(new NativeMenuItem("Save Map"));
			command.addEventListener(Event.SELECT, selectCommand);
			
			command = fileMenu.submenu.addItem(new NativeMenuItem("", true));
			command = fileMenu.submenu.addItem(new NativeMenuItem("Load Asset Library"));
			command.addEventListener(Event.SELECT, selectCommand);
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
		
		public function createWindowMenu(menu:NativeMenuItem):void {
			//trace("createWindowMenu");
			var command:NativeMenuItem = menu.submenu.addItem(new NativeMenuItem("", true));
			
			command = menu.submenu.addItem(new NativeMenuItem("Mode: Asset Placement"));
			command.addEventListener(Event.SELECT, selectCommand);
			command.checked = true;
			_isoViewModeCommands.push(command);
			
			command = menu.submenu.addItem(new NativeMenuItem("Mode: Set Walkable Tiles"));
			command.addEventListener(Event.SELECT, selectCommand);
			_isoViewModeCommands.push(command);
			
			command = menu.submenu.addItem(new NativeMenuItem("Mode: Move Background"));
			command.addEventListener(Event.SELECT, selectCommand);
			_isoViewModeCommands.push(command);
			
			command = menu.submenu.addItem(new NativeMenuItem("", true));
			
			command = menu.submenu.addItem(new NativeMenuItem("Reset Background Image"));
			command.addEventListener(Event.SELECT, selectCommand);
		}
		
		//catch custom menu items
		private function selectCommand(event:Event):void {
			trace("Selected command: " + event.target.label);
			switch (event.target.label) {
				case "Save Map":
					file = new File();
					file.addEventListener(Event.SELECT, onSave);
					file.browseForSave("Save Scene");
					//eventFileSave.dispatch();
					break;
				case "Open Map...":
					file = new File();
					file.addEventListener(Event.SELECT, onOpen);
					file.browseForOpen("Open Scene");
				case "New":
					eventFileNew.dispatch();
					break;
				case "Load Asset Library":
					file = new File();
					file.addEventListener(Event.SELECT, onLoadAssetLibrary);
					file.browseForOpen("Open Scene");
					break;
				case "Mode: Asset Placement":
					if(!event.target.checked){
						uncheckAllIsoViewModes();
						event.target.checked = true;
						eventUpdateIsoSceneViewMode.dispatch(IsoSceneViewModes.VIEW_MODE_PLACE_ASSETS);
					}
					break;
				case "Mode: Set Walkable Tiles":
					if(!event.target.checked){
						uncheckAllIsoViewModes();
						event.target.checked = true;
						eventUpdateIsoSceneViewMode.dispatch(IsoSceneViewModes.VIEW_MODE_SET_WALKABLE_TILES);
					}
					break;
				case "Mode: Move Background":
					if(!event.target.checked){
						uncheckAllIsoViewModes();
						event.target.checked = true;
						eventUpdateIsoSceneViewMode.dispatch(IsoSceneViewModes.VIEW_MODE_BACKGROUND);
					}
					break;
				case "Reset Background Image":
					eventResetIsoSceneBackground.dispatch();
				default:
					break;
			}
			
		}
		
		private function uncheckAllIsoViewModes():void{
			for each(var command:NativeMenuItem in _isoViewModeCommands){
				command.checked = false;
			}
		}
		
		private function onSave(event:Event):void{
			file.removeEventListener(Event.SELECT, onSave);
			eventFileSave.dispatch(file);
		}
		
		private function onOpen(event:Event):void{
			file.removeEventListener(Event.SELECT, onOpen);
			eventFileOpen.dispatch(file);
		}
		
		private function onLoadAssetLibrary(event:Event):void{
			file.removeEventListener(Event.SELECT, onLoadAssetLibrary);
			eventLoadAssetLibrary.dispatch(file);
		}
		
		//catch native menu command selections (copy, paste, etc)
		//TODO - implement any of these that we want/need
		private function selectCommandMenu(event:Event):void {
			if (event.currentTarget.parent != null) {
				var menuItem:NativeMenuItem =
					findItemForMenu(NativeMenu(event.currentTarget));
				if (menuItem != null) {
					//trace("Select event for \"" + 
					//	event.target.label + 
					//	"\" command handled by menu: " + 
					//	menuItem.label);
				}
			} else {
				//trace("Select event for \"" + 
				//	event.target.label + 
				//	"\" command handled by root menu.");
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