/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: Apr 28, 2011
 *
 */

package la.diversion.views {
	import as3isolib.display.IsoView;
	import as3isolib.display.primitive.IsoBox;
	import as3isolib.display.primitive.IsoPrimitive;
	import as3isolib.display.primitive.IsoRectangle;
	import as3isolib.display.scene.IsoGrid;
	import as3isolib.display.scene.IsoScene;
	import as3isolib.geom.IsoMath;
	import as3isolib.geom.Pt;
	import as3isolib.graphics.SolidColorFill;
	import as3isolib.graphics.Stroke;
	
	import eDpLib.events.ProxyEvent;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import la.diversion.enums.AssetTypes;
	import la.diversion.enums.AutoSetWalkableModes;
	import la.diversion.enums.IsoSceneViewModes;
	import la.diversion.enums.PropertyViewModes;
	import la.diversion.models.SceneModel;
	import la.diversion.models.vo.Background;
	import la.diversion.models.vo.MapAsset;
	import la.diversion.models.vo.SpriteSheet;
	import la.diversion.models.vo.Tile;
	import la.diversion.signals.AddAssetToSceneSignal;
	import la.diversion.signals.AddMapAssetPathingPointSignal;
	import la.diversion.signals.AssetAddedToSceneSignal;
	import la.diversion.signals.AssetFinishedDraggingSignal;
	import la.diversion.signals.AssetRemovedFromSceneSignal;
	import la.diversion.signals.AssetStartedDraggingSignal;
	import la.diversion.signals.IsoSceneBackgroundResetSignal;
	import la.diversion.signals.IsoSceneBackgroundUpdatedSignal;
	import la.diversion.signals.IsoSceneStageColorUpdatedSignal;
	import la.diversion.signals.IsoSceneViewModeUpdatedSignal;
	import la.diversion.signals.MapAssetPathingPointsUpdatedSignal;
	import la.diversion.signals.PropertiesViewModeUpdatedSignal;
	import la.diversion.signals.RemoveMapAssetPathingPointSignal;
	import la.diversion.signals.SceneGridSizeUpdatedSignal;
	import la.diversion.signals.TileWalkableUpdatedSignal;
	import la.diversion.signals.UpdateApplicationWindowResizeSignal;
	import la.diversion.signals.UpdateIsoSceneBackgroundPositionSignal;
	import la.diversion.signals.UpdateIsoSceneViewModeSignal;
	import la.diversion.signals.UpdatePropertiesViewModeSignal;
	import la.diversion.signals.UpdateTileWalkableSignal;
	
	import mx.events.FlexNativeWindowBoundsEvent;
	
	import org.robotlegs.mvcs.SignalMediator;
	
	public class IsoSceneMediator extends SignalMediator {
		
		[Inject]
		public var view:IsoSceneView;
		
		[Inject]
		public var sceneModel:SceneModel;
		
		[Inject]
		public var updateIsoSceneViewMode:UpdateIsoSceneViewModeSignal;
		
		[Inject]
		public var isoSceneViewModeUpdated:IsoSceneViewModeUpdatedSignal;
		
		[Inject]
		public var assetRemovedFromScene:AssetRemovedFromSceneSignal;
		
		[Inject]
		public var assetAddedToScene:AssetAddedToSceneSignal;
		
		[Inject]
		public var assetStartedDragging:AssetStartedDraggingSignal;
		
		[Inject]
		public var assetFinishedDragging:AssetFinishedDraggingSignal;
		
		[Inject]
		public var addAssetToScene:AddAssetToSceneSignal;
		
		[Inject]
		public var updateTileWalkable:UpdateTileWalkableSignal;
		
		[Inject]
		public var tileWalkableUpdated:TileWalkableUpdatedSignal;
		
		[Inject]
		public var sceneGridSizedUpdated:SceneGridSizeUpdatedSignal;
		
		[Inject]
		public var isoSceneBackgroundUpdated:IsoSceneBackgroundUpdatedSignal;
		
		[Inject]
		public var updatePropertiesViewMode:UpdatePropertiesViewModeSignal;
		
		[Inject]
		public var propertiesViewModeUpdated:PropertiesViewModeUpdatedSignal;
		
		[Inject]
		public var updateIsoSceneBackgroundPosition:UpdateIsoSceneBackgroundPositionSignal;
		
		[Inject]
		public var isoSceneBackgroundReset:IsoSceneBackgroundResetSignal;
		
		[Inject]
		public var updateApplicationWindowResize:UpdateApplicationWindowResizeSignal;
		
		[Inject]
		public var isoSceneStageColorUpdated:IsoSceneStageColorUpdatedSignal;
		
		[Inject]
		public var addMapAssetPathingPoint:AddMapAssetPathingPointSignal;
		
		[Inject]
		public var removeMapAssetPathingPoint:RemoveMapAssetPathingPointSignal;
		
		[Inject]
		public var mapAssetPathingPointsUpdated:MapAssetPathingPointsUpdatedSignal;
		
		private var _isPanning:Boolean = false;
		private var _isMovingBackground:Boolean = false;
		private var _panX:Number = 0;
		private var _panY:Number = 0;
		private var _panOriginX:Number = 0;
		private var _panOriginY:Number = 0;
		private var _mouseRow:Number;
		private var _mouseCol:Number;
		private var _isMouseOverGrid:Boolean = false;
		private var _isMouseOverThis:Boolean = false;
		private var _zoomFactor:Number = 1;
		private var _assetSelected:MapAsset;
		private var _assetSelectedMovePoint:Point;
		private var _highlightIsLocked:Boolean = false;
		private var _pathingHighlights:Array = [];
		
		override public function onRegister():void{
			makeGrid();
			
			addToSignal(isoSceneViewModeUpdated, handleIsoSceneViewModeUpdated);
			addToSignal(assetRemovedFromScene, handleAssetRemovedFromScene);
			addToSignal(assetAddedToScene, handleAssetAddedToScene);
			addToSignal(assetStartedDragging, handleAssetStartedDragging);
			addToSignal(assetFinishedDragging, handleAssetFinishedDragging);
			addToSignal(tileWalkableUpdated, handleTileWalkableUpdated);
			addToSignal(sceneGridSizedUpdated, handleSceneGridSizeUpdated);
			addToSignal(isoSceneBackgroundUpdated, handleIsoSceneBackgroundUpdated);
			addToSignal(isoSceneBackgroundReset, handleIsoSceneBackgroundReset);
			addToSignal(updateApplicationWindowResize, handleUpdateApplicationWindowResize);
			addToSignal(isoSceneStageColorUpdated, handleIsoSceneStageColorUpdated);
			addToSignal(mapAssetPathingPointsUpdated, handleMapAssetPathingPointsUpdated);
			addToSignal(propertiesViewModeUpdated, handlePropertiesViewModeUpdated);
			
			addToSignal(view.addedToStage, handleThisAddedToStage);
			addToSignal(view.thisMouseEventRollOut, handleThisMouseEventRollOut);
			addToSignal(view.thisMouseEventRollOver, handleThisMouseEventRollOver);
			addToSignal(view.enterFrame, handleEnterFrame);
		}
		
		private function handleEnterFrame(event:Event):void{
			view.isoScene.render();
		}
		
		private function handleIsoSceneStageColorUpdated(newColor:uint):void{
			trace("handleIsoSceneStageColorUpdated");
			var w:Number = view.bg.width;
			var h:Number = view.bg.height;
			view.bg.graphics.clear();
			view.bg.graphics.beginFill(sceneModel.stageColor);
			view.bg.graphics.drawRect(0,0,w,h);
			view.bg.graphics.endFill();
		}
		
		private function handleUpdateApplicationWindowResize(event:FlexNativeWindowBoundsEvent):void{
			view.isoView.setSize(event.afterBounds.width - 370, event.afterBounds.height - 95);
			
			view.bg.graphics.clear();
			view.bg.graphics.beginFill(sceneModel.stageColor);
			view.bg.graphics.drawRect(0,0,event.afterBounds.width - 370,event.afterBounds.height - 95);
			view.bg.graphics.endFill();
			
			view.colRowTextLabel.x = event.afterBounds.width - 415 ;
			view.colRowText.x = event.afterBounds.width - 385;
		}
		
		public function makeGrid():void {
			if (view.isoView && view.contains(view.isoView)) {
				view.isoGrid.setGridSize(sceneModel.numCols, sceneModel.numRows);
				view.isoScene.render();
			}else{
				initializeGrid();
			}
		}
		
		protected function initializeGrid():void {
			view.isoScene 		= new IsoScene();
			view.isoView 		= new IsoView();
			view.isoGrid 		= new IsoGrid();
			view.highlight	    = new IsoRectangle();
			
			view.highlight.setSize(sceneModel.cellSize, sceneModel.cellSize, 0);
			view.highlight.fills = [ new SolidColorFill(0x006600, 1) ];
			view.highlight.container.filters = [new GlowFilter(0x00FF00, 1, 5, 5, 6, 2, false, false)];
			view.isoScene.addChildAt(view.highlight,1);
			
			view.isoGrid.cellSize = sceneModel.cellSize;
			view.isoGrid.setGridSize(sceneModel.numCols, sceneModel.numRows);
			view.isoGrid.stroke = new Stroke(0.1, 0xAAAAAA,1);
			view.isoGrid.showOrigin = false;
			view.isoScene.addChild(view.isoGrid);
			
			//Set properties for isoView
			view.isoView.setSize(760, 760);
			
			//Add the isoScene to the isoView
			view.isoView.addScene(view.isoScene);
			view.isoScene.render();
			
			//Add the isoView to the stage
			view.addChildAt(view.isoView, 1);
			view.isoView.panTo( 0 ,int(sceneModel.numRows * sceneModel.cellSize / 2) );
			
			//
			view.bg.graphics.clear();
			view.bg.graphics.beginFill(sceneModel.stageColor);
			view.bg.graphics.drawRect(0,0,760,760);
			view.bg.graphics.endFill();
		}
		
		private function handleIsoSceneBackgroundUpdated(bg:Background):void{
			while(view.isoView.backgroundContainer.numChildren){
				view.isoView.backgroundContainer.removeChildAt(0);
			}
			view.isoView.backgroundContainer.addChild(bg);
		}
		
		private function handleIsoSceneBackgroundReset():void{
			while(view.isoView.backgroundContainer.numChildren){
				view.isoView.backgroundContainer.removeChildAt(0);
			}
		}
		
		private function handleSceneGridSizeUpdated():void{
			makeGrid();
		}
		
		private function handleThisMouseEventRollOut(event:MouseEvent):void{
			_isMouseOverThis = false;
			view.colRowText.text = "";
		}
		
		private function handleThisMouseEventRollOver(event:MouseEvent):void{
			_isMouseOverThis = true;
		}
		
		private function handleStageMouseMove(event:MouseEvent):void{
			if (view.isoGrid){
				var isoPt:Pt = view.isoView.localToIso(new Pt(view.isoView.mouseX, view.isoView.mouseY));
				if(_isPanning){		
					var scaleFactor:Number = 1 / view.isoView.currentZoom;
					view.isoView.panTo(_panOriginX - ((event.stageX - _panX)*scaleFactor), _panOriginY - ((event.stageY - _panY)*scaleFactor));
				}else if(_isMovingBackground){
					var scaleFactor2:Number = 1 / view.isoView.currentZoom;
					var positionUpdate:Object = new Object();
					positionUpdate.x = _panOriginX - ((_panX - event.stageX)*scaleFactor2);
					positionUpdate.y = _panOriginY - ((_panY - event.stageY)*scaleFactor2);
					updateIsoSceneBackgroundPosition.dispatch(positionUpdate);
				}
				_mouseCol = Math.floor(isoPt.x / sceneModel.cellSize);
				if (_mouseCol < 0 || _mouseCol >= sceneModel.numCols)
				{
					_isMouseOverGrid = false;
					view.highlight.container.visible = false;
					view.colRowText.text = "";
					return;
				}
				_mouseRow = Math.floor(isoPt.y / sceneModel.cellSize);
				if (_mouseRow < 0 || _mouseRow >= sceneModel.numRows)
				{
					_isMouseOverGrid = false;
					view.highlight.container.visible = false;
					view.colRowText.text = "";
					return;
				}
				
				_isMouseOverGrid = true;
				if (!_highlightIsLocked){
					view.highlight.container.visible = true;
					view.highlight.moveTo(_mouseCol * sceneModel.cellSize, _mouseRow * sceneModel.cellSize,0);
					view.isoScene.render();
				}
				if(_isMouseOverThis){
					view.colRowText.text = String(_mouseCol) + "\n" + String(_mouseRow);
				}else{
					view.colRowText.text = "";
				}
			}
		}
		
		private function handleStageMouseEventMouseDown(event:MouseEvent):void{
			if(_isMouseOverThis){
				if(sceneModel.viewMode == IsoSceneViewModes.VIEW_MODE_BACKGROUND && sceneModel.background != null){
					_isMovingBackground = true;
					_panOriginX = sceneModel.background.x;
					_panOriginY = sceneModel.background.y;
				}else{
					_isPanning = true;
					_panOriginX = view.isoView.currentX;
					_panOriginY = view.isoView.currentY;
				}
				
				var isoPt:Pt = view.isoView.localToIso(new Pt(view.isoView.mouseX, view.isoView.mouseY));
				_panX = event.stageX;
				_panY = event.stageY;
				view.stageMouseEventMouseUp.addOnce(handleStageMouseEventMouseUp);
				
			}
		}
		
		private function handleStageMouseEventMouseUp(event:MouseEvent):void{
			_isPanning = false;
			_isMovingBackground = false;
		}
		
		private function handleStageMouseEventMouseWheel(event:MouseEvent):void{
			if(_isMouseOverThis){
				_zoomFactor = _zoomFactor + (event.delta / 10);
				if (_zoomFactor < 0.1){
					_zoomFactor = 0.1;
				}else if(_zoomFactor > 3){
					_zoomFactor = 3;
				}
				view.isoView.zoom(_zoomFactor);
			}
		}
		
		private function handleThisAddedToStage(event:Event):void{
			addToSignal(view.stageMouseEventClick, handleStageMouseEventClick);
			addToSignal(view.stageMouseEventMouseMove, handleStageMouseMove);
			addToSignal(view.stageMouseEventMouseDown, handleStageMouseEventMouseDown);
			addToSignal(view.stageMouseEventMouseWheel, handleStageMouseEventMouseWheel);
		}
		
		private function handleTileWalkableUpdated(tile:Tile):void{
			//trace("IsoSceneMediator handleTileWalkableUpdated: " +tile.isoTile.id + ", " + tile.isWalkable + " " + tile.col + ", " + tile.row);
			if(!view.isoScene.contains(tile.isoTile)){
				view.isoScene.addChild(tile.isoTile);
			}
			if(tile.isWalkable || sceneModel.viewMode == IsoSceneViewModes.VIEW_MODE_PLACE_ASSETS){
				tile.isoTile.container.visible = false;
			}else{
				tile.isoTile.container.visible = true;
			}
		}
		
		private function handleStageMouseEventClick(event:MouseEvent):void{
			//trace("handleStageMouseEventClick");
			if(_isMouseOverGrid && _isMouseOverThis && sceneModel.viewMode == IsoSceneViewModes.VIEW_MODE_SET_WALKABLE_TILES){
				var tile:Tile = sceneModel.getTile(_mouseCol, _mouseRow);
				if(tile.isWalkable ){
					updateTileWalkable.dispatch(tile, false);
				}else{
					updateTileWalkable.dispatch(tile, true);
				}
			}else if(_isMouseOverGrid 
				&& _isMouseOverThis 
				&& _assetSelected
				&& sceneModel.viewMode  == IsoSceneViewModes.VIEW_MODE_EDIT_PATH
				&& sceneModel.viewModeProperties == PropertyViewModes.VIEW_MODE_ISOVIEW_ASSET){
				for each(var pt:Point in _assetSelected.pathingPoints){
					if(pt.x == _mouseCol && pt.y == _mouseRow){
						removeMapAssetPathingPoint.dispatch(_assetSelected, pt);
						return;
					}
				}
				addMapAssetPathingPoint.dispatch(_assetSelected, new Point(_mouseCol,_mouseRow));
			}else if(!_isMouseOverGrid && _isMouseOverThis){
				//click outside the grid, set properties panel to map
				var dummyAsset:MapAsset = new MapAsset("dummyAsset", MapAsset,"dummyAsset",0,0,0);
				updatePropertiesViewMode.dispatch(PropertyViewModes.VIEW_MODE_MAP, dummyAsset);
				_assetSelected = null;
				
				if(sceneModel.viewMode == IsoSceneViewModes.VIEW_MODE_EDIT_PATH){
					updateIsoSceneViewMode.dispatch(IsoSceneViewModes.VIEW_MODE_PLACE_ASSETS);
				}
			}
		}
		
		private function handleAssetAddedToScene(asset:MapAsset):void{
			addToSignal(asset.mouseDown, handleAssetMouseDown);
			addToSignal(asset.rollOver, handleAssetRollOver);
			addToSignal(asset.rollOut, handleAssetRollOut);
			view.isoScene.addChild(asset);
			view.isoScene.render();
			if(asset.displayClassType == AssetTypes.SPRITE_SHEET){
				asset.spriteSheet.action();
			}else if(asset.displayClassType == AssetTypes.MOVIECLIP){
				MovieClip(asset.container.getChildAt(0)).gotoAndStop("state_0");
			}
			_assetSelected = asset;
			updateMapAssetPathingGridDisplay();
			view.isoScene.render();
		}
		
		private function handleAssetMouseDown(event:ProxyEvent):void{
			if(sceneModel.viewMode == IsoSceneViewModes.VIEW_MODE_PLACE_ASSETS){
				_assetSelected = MapAsset(event.target);
				_assetSelectedMovePoint = new Point(MouseEvent(event.targetEvent).stageX, MouseEvent(event.targetEvent).stageY);
				
				addToSignal(view.stageMouseEventMouseMove, handleAssetMouseMove);
				addOnceToSignal(view.stageMouseEventMouseUp, handleAssetMouseUpNoDrag);
				updatePropertiesViewMode.dispatch(PropertyViewModes.VIEW_MODE_ISOVIEW_ASSET, _assetSelected);
				
				_highlightIsLocked = true;
				view.highlight.setSize(_assetSelected.cols * sceneModel.cellSize, _assetSelected.rows * sceneModel.cellSize, 0);
				view.highlight.moveTo(_assetSelected.stageCol * sceneModel.cellSize, _assetSelected.stageRow * sceneModel.cellSize, 0);
				if(_assetSelected.isInteractive == 1){
					var interactiveTile:IsoRectangle = new IsoRectangle();
					interactiveTile.setSize(sceneModel.cellSize, sceneModel.cellSize, 0);
					interactiveTile.fills = [ new SolidColorFill(0xFFFF00, 1) ];
					interactiveTile.moveTo(_assetSelected.interactiveCol * sceneModel.cellSize, _assetSelected.interactiveRow * sceneModel.cellSize,0);
					view.highlight.addChild(interactiveTile);
				}
				view.isoScene.render();
			}
			updateMapAssetPathingGridDisplay();
		}
		
		private function handleAssetMouseMove(event:MouseEvent):void{
			if (Math.abs(_assetSelectedMovePoint.x - event.stageX) > 5 || Math.abs(_assetSelectedMovePoint.y - event.stageY) > 5){
				_highlightIsLocked = false;
				view.highlight.moveTo(_mouseCol * sceneModel.cellSize, _mouseRow * sceneModel.cellSize,0);
				view.isoScene.render();
				this.signalMap.removeFromSignal( view.stageMouseEventMouseMove, handleAssetMouseMove);
				this.signalMap.removeFromSignal( view.stageMouseEventMouseUp, handleAssetMouseUpNoDrag);
				addOnceToSignal( _assetSelected.mouseUp, handleAssetMouseUp);
				assetStartedDragging.dispatch(_assetSelected);
			}
		}
		
		private function handleAssetMouseUpNoDrag(event:MouseEvent):void{
			this.signalMap.removeFromSignal( view.stageMouseEventMouseMove, handleAssetMouseMove);
			
			if(_assetSelected.isInteractive == 1){
				view.highlight.removeAllChildren();
			}
			//_assetSelected = null;
			_highlightIsLocked = false;
			view.highlight.moveTo(_mouseCol * sceneModel.cellSize, _mouseRow * sceneModel.cellSize,0);
			view.highlight.setSize(sceneModel.cellSize,sceneModel.cellSize,0);
			view.isoScene.render();
		}
		
		private function handleAssetMouseUp(event:MouseEvent):void{
			assetFinishedDragging.dispatch(_assetSelected, event);
		}
		
		private function handleAssetRollOver(event:ProxyEvent):void{
			if(sceneModel.viewMode == IsoSceneViewModes.VIEW_MODE_PLACE_ASSETS){
				MapAsset(event.target).container.alpha = .75;
				MapAsset(event.target).container.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 12, 3, false, false)];
			}
		}
		
		private function handleAssetRollOut(event:ProxyEvent):void{
			if(sceneModel.viewMode == IsoSceneViewModes.VIEW_MODE_PLACE_ASSETS){
				MapAsset(event.target).container.alpha = 1;
				MapAsset(event.target).container.filters = [];
			}
		}
		
		private function handleAssetStartedDragging(asset:MapAsset):void{
			if(asset.stageCol >= 0 && asset.stageRow >=0  && sceneModel.autoSetWalkable == AutoSetWalkableModes.AUTO_SET){
				for (var i:int = asset.stageCol; i < (asset.stageCol + asset.cols); i++) {
					for (var j:int = asset.stageRow ; j < (asset.stageRow + asset.rows); j++) {
						var tile:Tile = sceneModel.getTile(i,j);
						updateTileWalkable.dispatch(tile, true);
					}
				}
			}
			
			if(_assetSelected != asset){
				_assetSelected = null;
			}
			
			switch(asset.displayClassType) {
				case AssetTypes.SPRITE:
					view.dragImage = new asset.displayClass as Sprite;
					break;
				case AssetTypes.SPRITE_SHEET:
					var displaySprite:Sprite = new Sprite();
					var bmp:Bitmap = new Bitmap(asset.spriteSheet.getFrameBitmap().bitmapData);
					bmp.x = asset.spriteSheetOffset_x;
					bmp.y = asset.spriteSheetOffset_y;
					displaySprite.addChild(bmp);
					view.dragImage = displaySprite;
					break;
				case AssetTypes.MOVIECLIP:
					var dragClip:MovieClip = new asset.displayClass as MovieClip;
					dragClip.gotoAndStop("state_0");
					view.dragImage = dragClip;
					break;
				
				default:
					view.dragImage = new asset.displayClass as Sprite;
					break;
			}
			
			view.dragImage.mouseEnabled = false;
			view.dragImage.mouseChildren = false;
			view.dragImage.alpha = 0.5;
			view.dragImage.scaleX = view.isoView.currentZoom;
			view.dragImage.scaleY = view.isoView.currentZoom;
			view.dragImage.x = view.stage.mouseX;
			view.dragImage.y = view.stage.mouseY;
			view.stage.addChild(view.dragImage);
			
			addToSignal(view.enterFrame, handleAssetDraggingEnterFrame);
			updatePropertiesViewMode.dispatch(PropertyViewModes.VIEW_MODE_ISOVIEW_ASSET, asset);
		}
		
		private function handleAssetDraggingEnterFrame(event:Event):void{
			if(_isMouseOverGrid && _isMouseOverThis){
				var point:Point = view.isoView.isoToLocal(new Pt(_mouseCol * sceneModel.cellSize, _mouseRow * sceneModel.cellSize, 0));
				point = view.localToGlobal(point);
				view.dragImage.x = point.x;
				view.dragImage.y = point.y;
			}else{
				view.dragImage.x = view.stage.mouseX;
				view.dragImage.y = view.stage.mouseY;
			}
		}
		
		private function handleAssetFinishedDragging(asset:MapAsset, event:MouseEvent):void{
			if(asset.isInteractive == 1){
				view.highlight.removeAllChildren();
			}
			
			if(_isMouseOverGrid && _isMouseOverThis){
				_assetSelected = asset;
				asset.setSize(asset.cols * sceneModel.cellSize, asset.rows * sceneModel.cellSize, 64);
				asset.moveTo(_mouseCol * sceneModel.cellSize, _mouseRow * sceneModel.cellSize, 0);
				asset.stageCol = _mouseCol;
				asset.stageRow = _mouseRow;
				addAssetToScene.dispatch(asset);
				updatePropertiesViewMode.dispatch(PropertyViewModes.VIEW_MODE_ISOVIEW_ASSET, asset);
				
				if(asset.stageCol >= 0 && asset.stageRow >=0 && sceneModel.autoSetWalkable == AutoSetWalkableModes.AUTO_SET){
					for (var i:int = asset.stageCol; i < (asset.stageCol + asset.cols); i++) {
						for (var j:int = asset.stageRow ; j < (asset.stageRow + asset.rows); j++) {
							var tile:Tile = sceneModel.getTile(i,j);
							updateTileWalkable.dispatch(tile, false);
						}
					}
				}
			}else{
				//cleanup the asset, it has landed off the visible stage
				asset.cleanup();
				_assetSelected = null;
				sceneModel.assetBeingDragged = null;
				updatePropertiesViewMode.dispatch(PropertyViewModes.VIEW_MODE_MAP, asset);
			}
			
			updateMapAssetPathingGridDisplay();
			view.highlight.setSize(sceneModel.cellSize,sceneModel.cellSize,0);
			view.isoScene.render();
			view.stage.removeChild(view.dragImage);
			view.enterFrame.remove(handleAssetDraggingEnterFrame);
		}
		
		private function handleAssetRemovedFromScene(asset:MapAsset):void{
			trace("handleAssetRemovedFromScene");
			view.isoScene.removeChild(asset);
		}
		
		private function handleIsoSceneViewModeUpdated(mode:String):void{
			//trace("handleIsoSceneViewModeUpdated:" + mode);
			for(var i:int = 0; i < sceneModel.numCols; i++){
				for(var j:int = 0; j < sceneModel.numRows; j++){
					if(!sceneModel.getTile(i,j).isWalkable  && (mode == IsoSceneViewModes.VIEW_MODE_SET_WALKABLE_TILES || mode == IsoSceneViewModes.VIEW_MODE_EDIT_PATH)){
						sceneModel.getTile(i,j).isoTile.container.visible = true;
					}else{
						if (sceneModel.getTile(i,j).isoTile){
							sceneModel.getTile(i,j).isoTile.container.visible = false;
						}
					}
				}
			}
			if(mode == IsoSceneViewModes.VIEW_MODE_EDIT_PATH && sceneModel.viewModeProperties == PropertyViewModes.VIEW_MODE_ISOVIEW_ASSET){
				updateMapAssetPathingGridDisplay(_assetSelected);
			}else{
				updateMapAssetPathingGridDisplay(null);
			}
			view.isoScene.render();
		}
		
		private function handleMapAssetPathingPointsUpdated(asset:MapAsset):void{
			updateMapAssetPathingGridDisplay(asset);
		}
		
		private function updateMapAssetPathingGridDisplay(asset:MapAsset = null):void{
			if(asset != null && _assetSelected == asset && sceneModel.viewMode  == IsoSceneViewModes.VIEW_MODE_EDIT_PATH){
				//create new points if needed
				if(_assetSelected.pathingPoints.length > _pathingHighlights.length){
					addPathingHighlights(_assetSelected.pathingPoints.length - _pathingHighlights.length);
				}
				//move points to correct positions
				for (var i:int = 0; i < _assetSelected.pathingPoints.length; i++) {
					var pt:Point = _assetSelected.pathingPoints[i];
					if(!IsoRectangle(_pathingHighlights[i]).parent){
						view.isoScene.addChild(_pathingHighlights[i]);
					}
					IsoRectangle(_pathingHighlights[i]).moveTo(pt.x * sceneModel.cellSize, pt.y * sceneModel.cellSize,0);
				}
				//hide any points not needed
				if(_pathingHighlights.length > _assetSelected.pathingPoints.length){
					for (var j:int = _assetSelected.pathingPoints.length; j < _pathingHighlights.length; j++) {
						if(IsoRectangle(_pathingHighlights[j]).parent){
							view.isoScene.removeChild(_pathingHighlights[i]);
						}
					}
				}
			}else{
				//hide any visible pathing points
				for (var k:int = 0; k < _pathingHighlights.length; k++) {
					if(IsoRectangle(_pathingHighlights[k]).parent){
						view.isoScene.removeChild(_pathingHighlights[k]);
					}
				}
			}
		}
		
		private function addPathingHighlights(numberToAdd:int):void{
			var newSize:int = _pathingHighlights.length + numberToAdd;
			for (var i:int = _pathingHighlights.length; i < newSize; i++) {
				var rec:IsoRectangle = new IsoRectangle();
				rec.setSize(sceneModel.cellSize,sceneModel.cellSize,0);
				rec.fills = [ new SolidColorFill(0xFFFFFF, 1) ];
				var txt:TextField = new TextField();
				txt.defaultTextFormat = new TextFormat(null, 24, 0x000000);
				txt.text = String(i);
				txt.x = -7 * String(i).length;
				txt.y = 5;
				txt.mouseEnabled = false;
				rec.container.addChild(txt);
				_pathingHighlights[i] = rec;
			}
		}
		
		private function handlePropertiesViewModeUpdated(mode:String, asset:MapAsset):void{
			if(sceneModel.viewMode == IsoSceneViewModes.VIEW_MODE_EDIT_PATH && sceneModel.viewModeProperties == PropertyViewModes.VIEW_MODE_ISOVIEW_ASSET){
				updateMapAssetPathingGridDisplay(_assetSelected);
			}else{
				updateMapAssetPathingGridDisplay(null);
			}
			view.isoScene.render();
		}
		
	}
}