/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: chris
 * Created: Apr 26, 2011
 *
 */

package la.diversion.controllers {
	import flash.events.*;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	
	import la.diversion.assetView.AssetViewComponent;
	import la.diversion.levelView.LevelViewComponent;
	import la.diversion.models.Scene;
	import la.diversion.views.MainMenu;
	
	public class MainMenuController {
		
		public var levelComponent:LevelViewComponent;
		public var assetComponent:AssetViewComponent;
		public var mainMenu:MainMenu;
		
		public var _file:File;
		private var _fileStream:FileStream;
		
		public function MainMenuController(menu:MainMenu, levelView:LevelViewComponent, assetView:AssetViewComponent) {
			this.levelComponent = levelView;
			this.assetComponent = assetView;
			this.mainMenu = menu;
			
			mainMenu.addEventListener("Save", onSave);
		}
		
		private function onSave(event:Event):void {
			_file = new File();
			_file.browseForSave("Save Scene");
		}
	}
}