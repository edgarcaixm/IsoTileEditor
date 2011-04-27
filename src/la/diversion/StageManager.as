/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: Apr 25, 2011
 *
 */

package la.diversion {
	import flash.utils.Dictionary;
	
	import la.diversion.levelView.Grid;
	import la.diversion.levelView.LevelEvent;
	
	public class StageManager {
		
		private static var _stageLibrary:Dictionary = new Dictionary();
		private static var _grid:Grid;
		private static var _viewMode:String;
		
		public static var VIEW_MODE_PLACE_ASSETS:String = "viewModePlaceAssets";
		public static var VIEW_MODE_SET_WALKABLE_TILES:String = "viewModeSetWalkableTiles";
		
		public function StageManager()
		{
			_viewMode = StageManager.VIEW_MODE_PLACE_ASSETS;
		}
		
		public static function get grid():Grid
		{
			return _grid;
		}

		public static function set grid(value:Grid):void
		{
			_grid = value;
		}

		public static function get viewMode():String
		{
			return _viewMode;
		}

		public static function set viewMode(value:String):void
		{
			switch(value){
				case StageManager.VIEW_MODE_PLACE_ASSETS:
					_viewMode = value;
					for each(var paAsset:GameAsset in StageManager.getAllAssets()){
						paAsset.container.alpha = 1;
					}
					EventBus.dispatcher.dispatchEvent(new LevelEvent(LevelEvent.SET_VIEW_MODE_PLACE_ASSETS));
					break;
				case StageManager.VIEW_MODE_SET_WALKABLE_TILES:
					_viewMode = value;
					for each(var swtAsset:GameAsset in StageManager.getAllAssets()){
						swtAsset.container.alpha = 0.5;
					}
					EventBus.dispatcher.dispatchEvent(new LevelEvent(LevelEvent.SET_VIEW_MODE_SET_WALKABLE_TILES));
					break;
			}
		}

		public static function addAsset(asset:GameAsset):void{
			_stageLibrary[asset.id] = asset;
		}
		
		public static function getAsset(assetId:String):GameAsset{
			return _stageLibrary[assetId];
		}
		
		public static function removeAsset(assetId:String):void{
			delete _stageLibrary[assetId];
		}
		
		public static function getAllAssets():Dictionary{
			return _stageLibrary;
		}
	}
}