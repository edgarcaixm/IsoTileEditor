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
	
	import la.diversion.enums.AssetViewModes;
	import la.diversion.enums.PropertyViewModes;
	import la.diversion.models.AssetModel;
	import la.diversion.models.vo.Background;
	import la.diversion.models.vo.MapAsset;
	import la.diversion.signals.AddNewLibraryAssetSignal;
	import la.diversion.signals.AssetFinishedDraggingSignal;
	import la.diversion.signals.AssetStartedDraggingSignal;
	import la.diversion.signals.AssetViewModeUpdatedSignal;
	import la.diversion.signals.NewLibraryAssetAddedSignal;
	import la.diversion.signals.NewLibraryBackgroundAddedSignal;
	import la.diversion.signals.UpdateIsoSceneBackgroundSignal;
	import la.diversion.signals.UpdatePropertiesViewModeSignal;
	import la.diversion.views.components.AssetListItem;
	
	import org.robotlegs.mvcs.SignalMediator;
	
	public class AssetMediator extends SignalMediator {
		
		[Inject]
		public var view:AssetView;
		
		[Inject]
		public var assetModel:AssetModel;
		
		[Inject]
		public var addNewAsset:AddNewLibraryAssetSignal;
		
		[Inject]
		public var newAssetAdded:NewLibraryAssetAddedSignal;
		
		[Inject]
		public var assetStartDragging:AssetStartedDraggingSignal;
		
		[Inject]
		public var assetFinishedDragging:AssetFinishedDraggingSignal;
		
		[Inject]
		public var assetViewModeUpdated:AssetViewModeUpdatedSignal;
		
		[Inject]
		public var newBackgroundAdded:NewLibraryBackgroundAddedSignal;
		
		[Inject]
		public var updateIsoSceneBackground:UpdateIsoSceneBackgroundSignal;
		
		[Inject]
		public var updatePropertiesViewMode:UpdatePropertiesViewModeSignal;
		
		private var _assetListCount:int = 0;
		private var _backgroundListCount:int = 0;
		private var _assetBeingDragged:MapAsset;
		private var _listItemSelected:AssetListItem;
		
		override public function onRegister():void{
			//trace("AssetViewMediator onRegister");
			addToSignal(view.mouseEventMouseWheel, handleMouseEventMouseWheel);
			
			addToSignal(assetViewModeUpdated, handleAssetViewModeUpdated);
			addToSignal(newAssetAdded, handleNewAssetAdded);
			addToSignal(newBackgroundAdded, handleNewBackgroundAdded);
		}
		
		private function handleNewBackgroundAdded(bg:Background):void{
			//trace("handleNewBackgroundAdded:" + bg.id);
			var listItem:AssetListItem = new AssetListItem(bg, view.item_width, view.item_height);
			listItem.y = view.item_height * _backgroundListCount;
			view.backgroundHolder.addChild(listItem);
			_backgroundListCount++;
			
			addToSignal(listItem.mouseDown, handleBackgroundListItemMouseDown);
			view.initScroller();
		}
		
		private function handleBackgroundListItemMouseDown(event:MouseEvent):void{
			updateIsoSceneBackground.dispatch( AssetListItem(event.target).gameAsset.clone() );
		}
		
		private function handleAssetViewModeUpdated(viewMode:String):void{
			//trace("handleAssetViewModeUpdated: " + viewMode);
			switch(assetModel.viewMode) {
				case AssetViewModes.VIEW_MODE_ISOVIEW_ASSETS:
					view.assetHolder.visible = true;
					view.backgroundHolder.visible = false;
					break;
				case AssetViewModes.VIEW_MODE_BACKGROUNDS:
					view.assetHolder.visible = false;
					view.backgroundHolder.visible = true;
					break;
				
				default:
					break;
			}
		}
		
		private function handleMouseEventMouseWheel(event:MouseEvent):void{
			switch(assetModel.viewMode) {
				case AssetViewModes.VIEW_MODE_ISOVIEW_ASSETS:
					if (view.assetHolder.content.height > view.assetHolder.height) {
						view.assetHolderScroller.value = view.assetHolderScroller.value - (event.delta * 4);
					}
					break;
				case AssetViewModes.VIEW_MODE_BACKGROUNDS:
					if (view.backgroundHolder.content.height > view.backgroundHolder.height) {
						view.backgroundHolderScroller.value = view.backgroundHolderScroller.value - (event.delta * 4);
					}
					break;
				
				default:
					break;
			}

		}
		
		private function handleAssetListItemMouseDown(event:MouseEvent):void{
			trace("handleAssetListItemMouseDown");
			_listItemSelected = AssetListItem(event.target);
			addOnceToSignal(_listItemSelected.mouseUp, handleListItemMouseUp);
			addOnceToSignal(_listItemSelected.mouseRollOut, handleListItemRollOut);
			_assetBeingDragged = null;
			updatePropertiesViewMode.dispatch(PropertyViewModes.VIEW_MODE_LIBRARY_ASSET, AssetListItem(event.target).gameAsset);
		}
		
		private function handleListItemMouseUp(event:MouseEvent):void{
			trace("handleListItemMouseUp");
			this.signalMap.removeFromSignal(_listItemSelected.mouseRollOut, handleListItemRollOut);
			if(_assetBeingDragged){
				assetFinishedDragging.dispatch(_assetBeingDragged, event);
			}
		}
		
		private function handleListItemRollOut(event:MouseEvent):void{
			trace("handleListItemRollOut");
			_assetBeingDragged = AssetListItem(event.target).gameAsset.clone();
			assetStartDragging.dispatch(_assetBeingDragged);
		}
		
		private function handleNewAssetAdded(asset:MapAsset):void{
			var listItem:AssetListItem = new AssetListItem(asset, view.item_width, view.item_height);
			listItem.y = view.item_height * _assetListCount;
			view.assetHolder.addChild(listItem);
			_assetListCount++;
			
			addToSignal(listItem.mouseDown, handleAssetListItemMouseDown);
			view.initScroller();
		}
	}
}