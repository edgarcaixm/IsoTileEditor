/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: Apr 29, 2011
 *
 */

package la.diversion.views {
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	import la.diversion.enums.IsoSceneViewModes;
	import la.diversion.models.AssetModel;
	import la.diversion.models.components.GameAsset;
	import la.diversion.signals.AddNewLibraryAssetSignal;
	import la.diversion.signals.AssetFinishedDraggingSignal;
	import la.diversion.signals.AssetStartedDraggingSignal;
	import la.diversion.signals.LoadAssetLibrarySignal;
	import la.diversion.signals.NewLibraryAssetAddedSignal;
	import la.diversion.signals.UpdateAssetViewModeSignal;
	import la.diversion.views.components.AssetListItem;
	
	import org.robotlegs.mvcs.SignalMediator;
	
	public class AssetMediator extends SignalMediator {
		
		[Inject]
		public var view:AssetView;
		
		[Inject]
		public var assetModel:AssetModel;
		
		[Inject]
		public var updateWalkableMode:UpdateAssetViewModeSignal;
		
		[Inject]
		public var addNewAsset:AddNewLibraryAssetSignal;
		
		[Inject]
		public var newAssetAdded:NewLibraryAssetAddedSignal;
		
		[Inject]
		public var assetStartDragging:AssetStartedDraggingSignal;
		
		[Inject]
		public var assetFinishedDragging:AssetFinishedDraggingSignal;
		
		[Inject]
		public var loadAssetLibrary:LoadAssetLibrarySignal;
		
		private var _listCount:int = 0;
		private var _assetBeingDragged:GameAsset;
		
		override public function onRegister():void{
			trace("AssetViewMediator onRegister");
			addToSignal(view.setWalkableModeClicked, handleSetWalkableModeClicked);
			addToSignal(view.viewAddNewAsset, handleViewAddNewAsset);
			//addToSignal(view.assetStartDragging, handleAssetStartDragging);
			//addToSignal(view.assetFinishDragging, handleAssetFinishDragging);
			
			newAssetAdded.add(handleNewAssetAdded);
		}
		
		private function handleSetWalkableModeClicked():void{
			//TODO - move this to a listenter from the model?
			if(view.walkableModeBtn.label == "Set Walkable"){
				view.walkableModeBtn.label = "Place Assets";
				updateWalkableMode.dispatch(IsoSceneViewModes.VIEW_MODE_SET_WALKABLE_TILES);
			}else{
				view.walkableModeBtn.label = "Set Walkable";
				updateWalkableMode.dispatch(IsoSceneViewModes.VIEW_MODE_PLACE_ASSETS);
			}
			
		}
		
		private function handleViewAddNewAsset(file:File):void{
			loadAssetLibrary.dispatch(file.url);
		}
		
		private function handleListItemMouseDown(event:MouseEvent):void{
			addOnceToSignal(AssetListItem(event.target).mouseUp, handleListItemMouseUp);
			_assetBeingDragged = AssetListItem(event.target).gameAsset.clone();
			assetStartDragging.dispatch(_assetBeingDragged);
		}
		
		private function handleListItemMouseUp(event:MouseEvent):void{
			assetFinishedDragging.dispatch(_assetBeingDragged, event);
		}
		
		private function handleNewAssetAdded(asset:GameAsset):void{
			var listItem:AssetListItem = new AssetListItem(asset, view.item_width, view.item_height, asset.displayClassId);
			listItem.y = view.item_height * _listCount;
			view.assetHolder.addChild(listItem);
			_listCount++;
			
			addToSignal(listItem.mouseDown, handleListItemMouseDown);
			view.initScroller();
		}
		
		private function handleAssetStartDragging(asset:GameAsset):void{
			assetStartDragging.dispatch(asset);
		}
		
		private function handleAssetFinishDragging(asset:GameAsset, event:MouseEvent):void{
			assetFinishedDragging.dispatch(asset, event);
		}
	}
}