/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 3, 2011
 *
 */

package la.diversion.services {
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	
	import la.diversion.enums.AssetTypes;
	import la.diversion.models.vo.Background;
	import la.diversion.models.vo.MapAsset;
	import la.diversion.models.vo.SpriteSheet;
	import la.diversion.signals.AddNewLibraryAssetSignal;
	import la.diversion.signals.AddNewLibraryBackgroundSignal;
	import la.diversion.signals.LoadAssetLibraryCompleteSignal;
	
	import mx.controls.Alert;
	
	import org.robotlegs.mvcs.Actor;
	
	public class LoadAssetLibraryService extends Actor implements ILoadAssetLibrary {
		
		[Inject]
		public var addNewLibraryAsset:AddNewLibraryAssetSignal;
		
		[Inject]
		public var addNewLibraryBackground:AddNewLibraryBackgroundSignal;
		
		[Inject]
		public var loadAssetLibraryComplete:LoadAssetLibraryCompleteSignal;
		
		private var _files:Array;
		private var _bulkLoader:BulkLoader;
		
		public function LoadAssetLibraryService()
		{
			super();
			_bulkLoader = new BulkLoader("LoadAssetLibraryService Bulk Loader");
		}
		
		public function LoadAssetLibraryFile(files:Array):void {
			_files = files;
			for each(var file:File in files){
				_bulkLoader.add(file.url);
			}
			_bulkLoader.addEventListener(BulkLoader.COMPLETE, onAllLoaded);
			_bulkLoader.addEventListener(BulkLoader.ERROR, onErrorLoading);
			_bulkLoader.addEventListener(BulkLoader.SECURITY_ERROR, onSecurityErrorLoading);
			_bulkLoader.start();
		}
		
		private function onAllLoaded(event:Event):void {
			_bulkLoader.removeEventListener(BulkLoader.COMPLETE, onAllLoaded);
			_bulkLoader.removeEventListener(BulkLoader.ERROR, onErrorLoading);
			_bulkLoader.removeEventListener(BulkLoader.SECURITY_ERROR, onSecurityErrorLoading);
			for each(var file:File in _files){
				var assetSWF:MovieClip =  _bulkLoader.getMovieClip(file.url);
				for each(var assetDef:Object in assetSWF.tiles){
					var tClass:Class = assetSWF.loaderInfo.applicationDomain.getDefinition(assetDef.classRef) as Class;
					var gameAsset:MapAsset;
					switch(assetDef.type) {
						case "sprite":
							gameAsset = new MapAsset(assetDef.tileID, tClass, AssetTypes.SPRITE,assetDef.rows, assetDef.cols, assetDef.height, file.name, -1,- 1, 0, 0, 0, assetDef.classRef);
							break;
						case "movieclip":
							gameAsset = new MapAsset(assetDef.tileID, tClass, AssetTypes.MOVIECLIP,assetDef.rows, assetDef.cols, assetDef.height, file.name, -1,- 1, 0, 0, 0, assetDef.classRef);
							break;
						case "spritesheet":
							gameAsset = new MapAsset(assetDef.tileID, tClass, AssetTypes.SPRITE_SHEET,assetDef.rows, assetDef.cols, assetDef.height, file.name, -1,- 1, 0, 0, 0, assetDef.classRef);
							gameAsset.spriteSheet = new SpriteSheet();
							gameAsset.spriteSheet.build(new tClass as Sprite, gameAsset.frameWidth, gameAsset.frameHeight);
							gameAsset.spriteSheet.x = gameAsset.spriteSheetOffset_x;
							gameAsset.spriteSheet.y = gameAsset.spriteSheetOffset_y;
							gameAsset.spriteSheet.idle();
							//gameAsset.setSize(20, 20, 80);
							gameAsset.sprites = [gameAsset.spriteSheet];
							break;
						
						default:
							gameAsset = new MapAsset(assetDef.tileID, tClass, AssetTypes.SPRITE,assetDef.rows, assetDef.cols, assetDef.height, file.name, -1,- 1, 0, 0, 0, assetDef.classRef);
							break;
					}
					addNewLibraryAsset.dispatch(gameAsset);
				}
				for each(var bgDef:Object in assetSWF.backgrounds){
					var tClass2:Class = assetSWF.loaderInfo.applicationDomain.getDefinition(bgDef.classRef) as Class;
					var bg:Background = new Background(bgDef.backgroundID, bgDef.classRef, tClass2, AssetTypes.BITMAP, file.name, bgDef.classRef, new tClass2() as BitmapData);
					addNewLibraryBackground.dispatch(bg);
				}
			}
			loadAssetLibraryComplete.dispatch(_files);
		}
		
		private function onErrorLoading(event:ErrorEvent):void{
			_bulkLoader.removeEventListener(BulkLoader.COMPLETE, onAllLoaded);
			_bulkLoader.removeEventListener(BulkLoader.ERROR, onErrorLoading);
			_bulkLoader.removeEventListener(BulkLoader.SECURITY_ERROR, onSecurityErrorLoading);
			trace (event);
			Alert.show(event.toString(),"Error Loading Asset File",Alert.OK);
		}
		
		private function onSecurityErrorLoading(event:SecurityErrorEvent):void{
			_bulkLoader.removeEventListener(BulkLoader.COMPLETE, onAllLoaded);
			_bulkLoader.removeEventListener(BulkLoader.ERROR, onErrorLoading);
			_bulkLoader.removeEventListener(BulkLoader.SECURITY_ERROR, onSecurityErrorLoading);
			trace (event);
			Alert.show(event.toString(),"Error Loading Asset File",Alert.OK);
		}
	}
}