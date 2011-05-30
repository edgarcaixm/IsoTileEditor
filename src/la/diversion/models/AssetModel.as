/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: Apr 29, 2011
 *
 */

package la.diversion.models {
	import flash.utils.Dictionary;
	
	import la.diversion.enums.AssetViewModes;
	import la.diversion.models.vo.AssetManager;
	import la.diversion.models.vo.Background;
	import la.diversion.models.vo.MapAsset;
	import la.diversion.signals.AssetViewModeUpdatedSignal;
	import la.diversion.signals.NewLibraryAssetAddedSignal;
	import la.diversion.signals.NewLibraryBackgroundAddedSignal;
	
	import org.robotlegs.mvcs.Actor;
	
	public class AssetModel extends Actor {
		
		[Transient]
		[Inject]
		public var newAssetAdded:NewLibraryAssetAddedSignal;
		
		[Transient]
		[Inject]
		public var newBackgroundAdded:NewLibraryBackgroundAddedSignal;

		[Transient]
		[Inject]
		public var assetViewModeUpdated:AssetViewModeUpdatedSignal;
		
		private var _assetManager:AssetManager = new AssetManager();
		private var _backgroundManager:AssetManager = new AssetManager();
		private var _viewMode:String = AssetViewModes.VIEW_MODE_ISOVIEW_ASSETS;
		
		public function AssetModel()
		{
			super();
		}
		
		/**
		 * Add an asset 
		 * 
		 * @param GameAsset
		 * 
		 */
		public function addAsset(asset:MapAsset):void{
			_assetManager.addAsset(asset);
			newAssetAdded.dispatch(asset);
		}
		
		/**
		 * Retreive an asset by assetId
		 * 
		 * @param assetId String
		 * @return GameAsset
		 * 
		 */
		public function getAsset(assetId:String):MapAsset{
			return _assetManager.getAsset(assetId);
		}
		
		public function getAssetByDisplayClass(displayClass:String):MapAsset{
			for each(var asset:MapAsset in _assetManager.assets){
				if(asset.displayClassId == displayClass){
					return asset;
				}
			}
			return null;
		}
		
		/**
		 * Delete an asset
		 * 
		 * @param assetId String
		 * 
		 */
		public function removeAsset(assetId:String):void{
			if(_assetManager.getAsset(assetId)){
				_assetManager.removeAsset(assetId);
			}
		}
		
		/**
		 * Returns the dictionary of all game assets
		 * 
		 * @return Dictionary of game assets
		 * 
		 */
		public function get assetManager():AssetManager{
			return _assetManager;
		}
		
		/**
		 * Add an background 
		 * 
		 * @param Background
		 * 
		 */
		public function addBackground(bg:Background):void{
			_backgroundManager.addAsset(bg);
			newBackgroundAdded.dispatch(bg);
		}
		
		/**
		 * Retreive an background by assetId
		 * 
		 * @param backgroundId String
		 * @return Background
		 * 
		 */
		public function getBackground(backgroundId:String):MapAsset{
			return _backgroundManager.getAsset(backgroundId);
		}
		
		public function getBackgroundByDisplayClass(displayClass:String):Background{
			for each(var bg:Background in _backgroundManager.assets){
				if(bg.displayClassId == displayClass){
					return bg;
				}
			}
			return null;
		}
		
		/**
		 * Delete an background
		 * 
		 * @param backgroundId String
		 * 
		 */
		public function removeBackground(backgroundId:String):void{
			if(_backgroundManager.getAsset(backgroundId)){
				_backgroundManager.removeAsset(backgroundId);
			}
		}
		
		/**
		 * Returns the dictionary of all game backgrounds
		 * 
		 * @return Dictionary of game backgrounds
		 * 
		 */
		public function get backgroundManager():AssetManager{
			return _backgroundManager;
		}
		
		/**
		 * Returns the current viewMode
		 * 
		 * @return view mode String
		 * 
		 */
		[Transient]
		public function get viewMode():String
		{
			return _viewMode;
		}
		
		/**
		 * Sets the current view mode and dispatches a signal
		 * 
		 * @param view mode
		 *
		 */
		public function set viewMode(value:String):void
		{
			_viewMode = value;
			assetViewModeUpdated.dispatch(value);
		}
		
		public function updateLibraryAssetProperty(assetId:String, assetProperty:String, assetValue:*):void{
			var asset:MapAsset = getAsset(assetId);
			if(asset != null){
				asset[assetProperty] = assetValue;
			}
		}
	}
}