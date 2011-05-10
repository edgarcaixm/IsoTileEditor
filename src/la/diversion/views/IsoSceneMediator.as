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
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	import la.diversion.enums.IsoSceneViewModes;
	import la.diversion.enums.PropertyViewModes;
	import la.diversion.models.SceneModel;
	import la.diversion.models.components.Background;
	import la.diversion.models.components.GameAsset;
	import la.diversion.models.components.Tile;
	import la.diversion.signals.AddAssetToSceneSignal;
	import la.diversion.signals.AssetAddedToSceneSignal;
	import la.diversion.signals.AssetFinishedDraggingSignal;
	import la.diversion.signals.AssetRemovedFromSceneSignal;
	import la.diversion.signals.AssetStartedDraggingSignal;
	import la.diversion.signals.IsoSceneBackgroundUpdatedSignal;
	import la.diversion.signals.IsoSceneViewModeUpdatedSignal;
	import la.diversion.signals.SceneGridSizeUpdatedSignal;
	import la.diversion.signals.TileWalkableUpdatedSignal;
	import la.diversion.signals.UpdatePropertiesViewModeSignal;
	import la.diversion.signals.UpdateTileWalkableSignal;
	
	import org.robotlegs.mvcs.SignalMediator;
	
	public class IsoSceneMediator extends SignalMediator {
		
		[Inject]
		public var view:IsoSceneView;
		
		[Inject]
		public var sceneModel:SceneModel;
		
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
		
		private var _isPanning:Boolean = false;
		private var _panX:Number = 0;
		private var _panY:Number = 0;
		private var _panOriginX:Number = 0;
		private var _panOriginY:Number = 0;
		private var _mouseRow:Number;
		private var _mouseCol:Number;
		private var _isMouseOverGrid:Boolean = false;
		private var _isMouseOverThis:Boolean = false;
		private var _zoomFactor:Number = 1;
		
		override public function onRegister():void{
			//sceneModel.setGridSize(40,40);
			makeGrid();
			
			addToSignal(isoSceneViewModeUpdated, handleIsoSceneViewModeUpdated);
			addToSignal(assetRemovedFromScene, handleAssetRemovedFromScene);
			addToSignal(assetAddedToScene, handleAssetAddedToScene);
			addToSignal(assetStartedDragging, handleAssetStartedDragging);
			addToSignal(assetFinishedDragging, handleAssetFinishedDragging);
			addToSignal(tileWalkableUpdated, handleTileWalkableUpdated);
			addToSignal(sceneGridSizedUpdated, handleSceneGridSizeUpdated);
			addToSignal(isoSceneBackgroundUpdated, handleIsoSceneBackgroundUpdated);
			
			addToSignal(view.addedToStage, handleThisAddedToStage);
			addToSignal(view.thisMouseEventRollOut, handleThisMouseEventRollOut);
			addToSignal(view.thisMouseEventRollOver, handleThisMouseEventRollOver);
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
			view.isoGrid.stroke = new Stroke(1, 0x000000,1);
			view.isoGrid.showOrigin = false;
			view.isoScene.addChild(view.isoGrid);
			
			//Set properties for isoView
			view.isoView.setSize(760, 760);
			
			//Add the isoScene to the isoView
			view.isoView.addScene(view.isoScene);
			view.isoScene.render();
			
			//Add the isoView to the stage
			view.addChildAt(view.isoView, 1);
			view.isoView.panTo( int(sceneModel.numRows * sceneModel.cellSize / 2) ,int(sceneModel.numRows * sceneModel.cellSize / 2) );
		}
		
		private function handleIsoSceneBackgroundUpdated(bg:Background):void{
			while(view.isoView.backgroundContainer.numChildren){
				view.isoView.backgroundContainer.removeChildAt(0);
			}
			view.isoView.backgroundContainer.addChild(bg);
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
				view.highlight.container.visible = true;
				view.highlight.moveTo(_mouseCol * sceneModel.cellSize, _mouseRow * sceneModel.cellSize,0);
				view.isoScene.render();
				if(_isMouseOverThis){
					view.colRowText.text = String(_mouseCol) + "\n" + String(_mouseRow);
				}else{
					view.colRowText.text = "";
				}
			}
		}
		
		private function handleStageMouseEventMouseDown(event:MouseEvent):void{
			if(_isMouseOverThis){
				var isoPt:Pt = view.isoView.localToIso(new Pt(view.isoView.mouseX, view.isoView.mouseY));
				_panX = event.stageX;
				_panY = event.stageY;
				_panOriginX = view.isoView.currentX;
				_panOriginY = view.isoView.currentY;
				_isPanning = true;
				view.stageMouseEventMouseUp.addOnce(handleStageMouseEventMouseUp);
			}
		}
		
		private function handleStageMouseEventMouseUp(event:MouseEvent):void{
			_isPanning = false;
		}
		
		private function handleStageMouseEventMouseWheel(event:MouseEvent):void{
			if(_isMouseOverThis){
				_zoomFactor = _zoomFactor + (event.delta / 10);
				if (_zoomFactor < 0.3){
					_zoomFactor = 0.3;
				}else if(_zoomFactor > 2){
					_zoomFactor = 2;
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
			}else if(!_isMouseOverGrid && _isMouseOverThis){
				//click outside the grid, set properties panel to map
				var dummyAsset:GameAsset = new GameAsset("dummyAsset", GameAsset,"dummyAsset",0,0,0);
				updatePropertiesViewMode.dispatch(PropertyViewModes.VIEW_MODE_MAP, dummyAsset);
			}
		}
		
		private function handleAssetAddedToScene(asset:GameAsset):void{
			addToSignal(asset.mouseDown, handleAssetMouseDown);
			addToSignal(asset.rollOver, handleAssetRollOver);
			addToSignal(asset.rollOut, handleAssetRollOut);
			view.isoScene.addChild(asset);
			view.isoScene.render();
		}
		
		private function handleAssetMouseDown(event:ProxyEvent):void{
			if(sceneModel.viewMode == IsoSceneViewModes.VIEW_MODE_PLACE_ASSETS){
				addOnceToSignal( GameAsset(event.target).mouseUp, handleAssetMouseUp);
				assetStartedDragging.dispatch(event.target);
				//updatePropertiesViewMode.dispatch(PropertyViewModes.VIEW_MODE_ASSET, event.target);
			}
		}
		
		private function handleAssetMouseUp(event:MouseEvent):void{
			assetFinishedDragging.dispatch(sceneModel.assetBeingDragged, event);
			//updatePropertiesViewMode.dispatch(PropertyViewModes.VIEW_MODE_ASSET, sceneModel.assetBeingDragged);
		}
		
		private function handleAssetRollOver(event:ProxyEvent):void{
			if(sceneModel.viewMode == IsoSceneViewModes.VIEW_MODE_PLACE_ASSETS){
				GameAsset(event.target).container.alpha = .75;
				GameAsset(event.target).container.filters = [new GlowFilter(0xFF0000, 1, 5, 5, 6, 2, false, false)];
			}
		}
		
		private function handleAssetRollOut(event:ProxyEvent):void{
			if(sceneModel.viewMode == IsoSceneViewModes.VIEW_MODE_PLACE_ASSETS){
				GameAsset(event.target).container.alpha = 1;
				GameAsset(event.target).container.filters = [];
			}
		}
		
		private function handleAssetStartedDragging(asset:GameAsset):void{
			
			view.highlight.setSize(asset.cols * sceneModel.cellSize, asset.rows * sceneModel.cellSize, 0);
			view.isoScene.render();
			
			view.dragImage = new asset.displayClass as Sprite;
			view.dragImage.mouseEnabled = false;
			view.dragImage.mouseChildren = false;
			view.dragImage.alpha = 0.5;
			view.dragImage.scaleX = view.isoView.currentZoom;
			view.dragImage.scaleY = view.isoView.currentZoom;
			view.dragImage.x = view.stage.mouseX;
			view.dragImage.y = view.stage.mouseY;
			view.stage.addChild(view.dragImage);
			
			addToSignal(view.enterFrame, handleAssetDraggingEnterFrame);
			updatePropertiesViewMode.dispatch(PropertyViewModes.VIEW_MODE_ASSET, asset);
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
		
		private function handleAssetFinishedDragging(asset:GameAsset, event:MouseEvent):void{
			if(_isMouseOverGrid && _isMouseOverThis){
				asset.setSize(asset.cols * sceneModel.cellSize, asset.rows * sceneModel.cellSize, 64);
				asset.moveTo(_mouseCol * sceneModel.cellSize, _mouseRow * sceneModel.cellSize, 0);
				asset.stageCol = _mouseCol;
				asset.stageRow = _mouseRow;
				addAssetToScene.dispatch(asset);
				updatePropertiesViewMode.dispatch(PropertyViewModes.VIEW_MODE_ASSET, asset);
			}else{
				//cleanup the asset, it has landed off the visible stage
				asset.cleanup();
				sceneModel.assetBeingDragged = null;
				updatePropertiesViewMode.dispatch(PropertyViewModes.VIEW_MODE_MAP, asset);
			}
			
			view.highlight.setSize(sceneModel.cellSize,sceneModel.cellSize,0);
			view.isoScene.render();
			view.stage.removeChild(view.dragImage);
			view.enterFrame.remove(handleAssetDraggingEnterFrame);
		}
		
		private function handleAssetRemovedFromScene(asset:GameAsset):void{
			//trace("handleAssetRemovedFromScene");
			view.isoScene.removeChild(asset);
		}
		
		private function handleIsoSceneViewModeUpdated(mode:String):void{
			for(var i:int = 0; i < sceneModel.numCols; i++){
				for(var j:int = 0; j < sceneModel.numRows; j++){
					if(!sceneModel.getTile(i,j).isWalkable){
						if(mode == IsoSceneViewModes.VIEW_MODE_PLACE_ASSETS){
							sceneModel.getTile(i,j).isoTile.container.visible = false;
						}else{
							sceneModel.getTile(i,j).isoTile.container.visible = true;
						}
					}
				}
			}
			view.isoScene.render();
		}
		
	}
}