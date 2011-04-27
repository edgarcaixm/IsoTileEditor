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
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import la.diversion.levelView.Grid;
	import la.diversion.assetView.AssetViewComponent;
	import la.diversion.levelView.LevelViewComponent;
	import la.diversion.models.Scene;
	import la.diversion.views.MainMenu;
	
	public class MainMenuController {
		
		public var levelComponent:LevelViewComponent;
		public var assetComponent:AssetViewComponent;
		public var mainMenu:MainMenu;
		
		public var _file:File;
		
		public function MainMenuController(menu:MainMenu, levelView:LevelViewComponent, assetView:AssetViewComponent) {
			this.levelComponent = levelView;
			this.assetComponent = assetView;
			this.mainMenu = menu;
			
			mainMenu.addEventListener("Save", onSelectSaveFile);
		}
		
		protected function onSelectSaveFile(event:Event):void {
			_file = new File();
			_file.addEventListener(Event.SELECT, onSave);
			_file.browseForSave("Save Scene");
		}
		
		protected function onSave(event:Event):void {
			_file.removeEventListener(Event.SELECT, onSave);
			var scene:Scene = createSceneModel();
			//trace(scene.toJSON());
			var fileStream:FileStream = new FileStream();
			fileStream.open(_file, FileMode.WRITE);
			fileStream.writeUTFBytes(scene.toJSON());
			fileStream.close();
		}
		
		protected function createSceneModel():Scene {
			var scene:Scene = new Scene();
			var grid:Grid = levelComponent.grid;
			
			scene.setGridSize(levelComponent.cols, levelComponent.rows);
			return scene;
		}
	}
}