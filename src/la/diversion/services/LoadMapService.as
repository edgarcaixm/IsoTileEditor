/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 4, 2011
 *
 */

package la.diversion.services
{
	import com.adobe.serialization.json.DiversionJSON;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import la.diversion.enums.AssetTypes;
	import la.diversion.enums.TerrainTypes;
	import la.diversion.models.AssetModel;
	import la.diversion.models.SceneModel;
	import la.diversion.models.vo.Background;
	import la.diversion.models.vo.MapAsset;
	import la.diversion.models.vo.SpriteSheet;
	import la.diversion.signals.LoadAssetLibraryCompleteSignal;
	import la.diversion.signals.LoadAssetLibrarySignal;
	
	import mx.controls.Alert;
	
	import org.robotlegs.mvcs.Actor;
	
	public class LoadMapService extends Actor implements ILoadMap
	{
		[Inject]
		public var sceneModel:SceneModel;
		
		[Inject]
		public var assetModel:AssetModel;
		
		[Inject]
		public var loadAssetLibrary:LoadAssetLibrarySignal;
		
		[Inject]
		public var loadAssetLibraryComplete:LoadAssetLibraryCompleteSignal;
		
		private var _file:File;
		private var _map:Object;
		private var _assetFiles:Array;
		
		public function LoadMapService()
		{
			super();
		}
		
		public function loadMap(file:File):void
		{
			_file = file;
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT; // default
			urlLoader.addEventListener(Event.COMPLETE, onMapFileLoadComplete);
			urlLoader.load(new URLRequest(file.url));
		}
		
		private function onMapFileLoadComplete(e:Event):void {
			try{
				_map = DiversionJSON.decode(e.target.data);
			}catch(e:Error) {
				Alert.show(e.toString(),"Error Loading Map File",Alert.OK);
			}
			_assetFiles = new Array();
			var loadedFiles:Dictionary = new Dictionary();
			if(_map && _map.assetModel && _map.assetModel.assetManager){
				//load assets
				for each(var asset:Object in _map.assetModel.assetManager){
					if(!loadedFiles[asset.fileUrl]){
						var f:File = new File(_file.parent.nativePath + "/" + asset.fileUrl);
						_assetFiles.push(f);
						loadedFiles[asset.fileUrl] = true;
						trace("LoadMapService load asset file added: " + _file.parent.nativePath + "/" + asset.fileUrl);
					}
				}
			}else{
				Alert.show("Unable to parse map assets list.","Error Loading Map File",Alert.OK);
				return;
			}
			if(_map && _map.assetModel && _map.assetModel.backgroundManager){
				//load backgrounds
				for each(var bg:Object in _map.assetModel.backgroundManager){
					if(!loadedFiles[bg.fileUrl]){
						var f2:File = new File(_file.parent.nativePath + "/" + bg.fileUrl);
						_assetFiles.push(f2);
						loadedFiles[bg.fileUrl] = true;
						trace("LoadMapService load bg file added: " + _file.parent.nativePath + "/" + bg.fileUrl);
					}
				}
			}else{
				Alert.show("Unable to parse map backgrounds list.","Error Loading Map File",Alert.OK);
				return;
			}
			
			if(_assetFiles.length > 0){
				//load files and wait for finished loading response
				loadAssetLibraryComplete.add(loadMapAssetsComplete);
				loadAssetLibrary.dispatch(_assetFiles);
			}else{
				//load the rest of the level
				loadStageInstances();
			}
		}
		
		private function loadMapAssetsComplete(assetsLoaded:Array):void{
			if(assetsLoaded == _assetFiles){
				loadAssetLibraryComplete.remove(loadMapAssetsComplete);
				updateAssetLibraryWithMapfileSpecifics();
				loadStageInstances();
			}
		}
		
		private function updateAssetLibraryWithMapfileSpecifics():void{
			trace("updateAssetLibraryWithMapfileSpecifics");
			if(_map && _map.assetModel && _map.assetModel.assetManager){
				for each(var asset:Object in _map.assetModel.assetManager){
					var libAsset:MapAsset = assetModel.getAssetByDisplayClass(asset.displayClassId);
					if(libAsset){
						for (var property:* in asset){
							try{
								
								if(property == "displayClassType" 
									|| property == "actorId"
									|| property == "pathingPoints"
									|| property == "classRef"
									|| property == "id"
									|| property == "displayClassId"){
									//ignore these properties
								}else{
									libAsset[property] = asset[property];
								}
							}catch(e:Error){
								trace("ERROR updating library Asset:" + property + ", error:" + e.toString());
							}
						}
						}
				}
			}
		}
		
		private function loadStageInstances():void{
			trace("loadStageInstances");
			if(_map.sceneModel){
				//load map layout
				if(_map.sceneModel.cellSize){
					sceneModel.cellSize = _map.sceneModel.cellSize;
				}
				if(_map.sceneModel.numCols){
					sceneModel.numCols = _map.sceneModel.numCols;
				}
				if(_map.sceneModel.numRows){
					sceneModel.numRows = _map.sceneModel.numRows;
				}
				if(_map.sceneModel.zoomLevel){
					sceneModel.numRows = _map.sceneModel.zoomLevel;
				}
				if(_map.sceneModel.position){
					sceneModel.position = new Point(_map.sceneModel.position.x, _map.sceneModel.position.y);
				}
				if(_map.sceneModel.stageColor){
					sceneModel.stageColor = uint(_map.sceneModel.stageColor);
				}
				if(_map.sceneModel.playerAvatarSpawnPosition){
					sceneModel.playerAvatarSpawnPosition = new Point(_map.sceneModel.playerAvatarSpawnPosition.x, _map.sceneModel.playerAvatarSpawnPosition.y);
				}
				
				if(_map.sceneModel.unwalkableGridTiles){
					for each(var tile:Object in _map.sceneModel.unwalkableGridTiles){
						if(tile["isWalkable"] == false){
							sceneModel.getTile(tile.col, tile.row).isWalkable = false;
						}
						if(tile["terrain_type"] && tile["terrain_type"] != TerrainTypes.GROUND){
							sceneModel.getTile(tile.col, tile.row).terrain_type = tile["terrain_type"];
						}
					}
				}
				
				if(_map.sceneModel.assetManager){
					for each(var savedAsset:Object in _map.sceneModel.assetManager){
						trace("loadMap loadStageInstance: " + savedAsset.displayClassId + "(" + savedAsset.displayClassType + ")");
						var newAsset:MapAsset = assetModel.getAssetByDisplayClass(savedAsset.displayClassId);
						if (newAsset){
							newAsset = newAsset.clone();
							//TODO: refactor this to use some form of reflection
							newAsset.rows = savedAsset.rows;
							newAsset.cols = savedAsset.cols;
							newAsset.height = savedAsset.height;
							newAsset.setSize(savedAsset.cols * sceneModel.cellSize, savedAsset.rows * sceneModel.cellSize, savedAsset.height);
							newAsset.moveTo(savedAsset.stageCol * sceneModel.cellSize, savedAsset.stageRow * sceneModel.cellSize, 0);
							newAsset.stageCol = savedAsset.stageCol;
							newAsset.stageRow = savedAsset.stageRow;
							newAsset.actorId = savedAsset.actorId;
							newAsset.isInteractive = savedAsset.isInteractive;
							newAsset.interactiveCol = savedAsset.interactiveCol;
							newAsset.interactiveRow = savedAsset.interactiveRow;
							newAsset.pathingType = savedAsset.pathingType;
							newAsset.frameWidth = savedAsset.frameWidth;
							newAsset.frameHeight = savedAsset.frameHeight;
							newAsset.spriteSheetOffset_x = savedAsset.spriteSheetOffset_x;
							newAsset.spriteSheetOffset_y = savedAsset.spriteSheetOffset_y;
							newAsset.moveSpeed = savedAsset.moveSpeed;
							newAsset.walkType = savedAsset.walkType;
							var pathingPoints:Array = [];
							if(savedAsset.pathingPoints){
								for (var i:int = 0; i < savedAsset.pathingPoints.length; i++) {
									pathingPoints[i] = new Point(savedAsset.pathingPoints[i].x, savedAsset.pathingPoints[i].y);
								}
							}
							newAsset.pathingPoints = pathingPoints;
							
							if(newAsset.displayClassType == AssetTypes.SPRITE_SHEET){
								newAsset.spriteSheet = new SpriteSheet();
								newAsset.spriteSheet.build(new newAsset.displayClass as Sprite, newAsset.frameWidth, newAsset.frameHeight);
								newAsset.spriteSheet.x = newAsset.spriteSheetOffset_x;
								newAsset.spriteSheet.y = newAsset.spriteSheetOffset_y;
								newAsset.spriteSheet.idle();
								//newAsset.setSize(20, 20, 80);
								newAsset.sprites = [newAsset.spriteSheet];
							}
							
							sceneModel.addAsset(newAsset);
						}else{
							trace("error loading asset: " + savedAsset.displayClassId);
						}
					}
				}
				
				if(_map.sceneModel.background && _map.sceneModel.background.displayClassId){
					var bg:Background = assetModel.getBackgroundByDisplayClass(_map.sceneModel.background.displayClassId);
					if (bg){
						bg = bg.clone();
						bg.x = _map.sceneModel.background.x;
						bg.y = _map.sceneModel.background.y;
						sceneModel.background = bg;
					}
				}
			}
		}
	}
}