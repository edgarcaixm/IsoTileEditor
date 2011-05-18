/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 8, 2011
 *
 */

package la.diversion.views
{
	import flash.events.Event;
	
	import la.diversion.enums.PropertyViewModes;
	import la.diversion.models.SceneModel;
	import la.diversion.models.components.GameAsset;
	import la.diversion.models.components.PropertyUpdate;
	import la.diversion.signals.IsoSceneStageColorUpdatedSignal;
	import la.diversion.signals.PropertiesViewModeUpdatedSignal;
	import la.diversion.signals.SceneGridSizeUpdatedSignal;
	import la.diversion.signals.UpdateApplicationWindowResizeSignal;
	import la.diversion.signals.UpdateIsoSceneAssetPropertySignal;
	import la.diversion.signals.UpdateIsoScenePropertySignal;
	import la.diversion.signals.UpdateSceneGridSizeSignal;
	
	import mx.collections.ArrayCollection;
	import mx.events.FlexNativeWindowBoundsEvent;
	
	import org.robotlegs.mvcs.SignalMediator;
	
	import spark.events.GridItemEditorEvent;
	
	public class PropertiesMediator extends SignalMediator
	{
		[Inject]
		public var view:PropertiesView;
		
		[Inject]
		public var sceneModel:SceneModel;
		
		[Inject]
		public var updateSceneGridSize:UpdateSceneGridSizeSignal;
		
		[Inject]
		public var propertiesViewModeUpdated:PropertiesViewModeUpdatedSignal;
		
		[Inject]
		public var updateIsoSceneProperty:UpdateIsoScenePropertySignal;
		
		[Inject]
		public var updateIsoSceneAssetProperty:UpdateIsoSceneAssetPropertySignal;
		
		[Inject]
		public var updateApplicationWindowResize:UpdateApplicationWindowResizeSignal;
		
		[Inject]
		public var sceneGridSizeUpdated:SceneGridSizeUpdatedSignal;
		
		[Inject]
		public var isoSceneStageColorUpdated:IsoSceneStageColorUpdatedSignal;
		
		private var _dataProvider:ArrayCollection
		private var _asset:GameAsset;
		
		override public function onRegister():void{
			//trace("PropertiesMediator");
			
			view.propertyGrid.dataProvider = sceneModel.editProperitiesList;
			
			addToSignal(view.gridItemEditorSessionSave, handleGridItemEditorSessionSave);
			addToSignal(view.gridItemEditorSessionStarting, handleGridItemEditorSessionStarting);
			addToSignal(propertiesViewModeUpdated, handlePropertiesViewModeUpdated);
			addToSignal(updateApplicationWindowResize, handleUpdateApplicationWindowResize);
			addToSignal(sceneGridSizeUpdated, handleSceneGridSizeUpdated);
			addToSignal(isoSceneStageColorUpdated, handleIsoSceneStageColorUpdated);
			
			//var gridSize:Object = new Object();
			//gridSize.cols = SceneModel.DEFAULT_COLS;
			//gridSize.rows = SceneModel.DEFAULT_ROWS;
			//updateSceneGridSize.dispatch(gridSize);
		}
		
		private function handleIsoSceneStageColorUpdated(newcolor:uint):void{
			if(sceneModel.viewModeProperties == PropertyViewModes.VIEW_MODE_MAP){
				view.propertyGrid.dataProvider = sceneModel.editProperitiesList;
			}
		}
		
		private function handleSceneGridSizeUpdated():void{
			if(sceneModel.viewModeProperties == PropertyViewModes.VIEW_MODE_MAP){
				view.propertyGrid.dataProvider = sceneModel.editProperitiesList;
			}
		}
		
		private function handleUpdateApplicationWindowResize(event:FlexNativeWindowBoundsEvent):void{
			view.x = event.afterBounds.width - view.width - 5;
		}
		
		private function handleGridItemEditorSessionSave(event:GridItemEditorEvent):void {
			if(sceneModel.viewModeProperties == PropertyViewModes.VIEW_MODE_MAP){
				var update:PropertyUpdate = new PropertyUpdate();
				update.editProperty = view.propertyGrid.dataProvider.getItemAt(event.rowIndex).editProperty;
				update.value = view.propertyGrid.dataProvider.getItemAt(event.rowIndex).value;
				updateIsoSceneProperty.dispatch(update);
			}else if (sceneModel.viewModeProperties == PropertyViewModes.VIEW_MODE_ASSET){
				var assetUpdate:PropertyUpdate = new PropertyUpdate();
				assetUpdate.id = _asset.id;
				assetUpdate.editProperty = view.propertyGrid.dataProvider.getItemAt(event.rowIndex).editProperty;
				assetUpdate.value = view.propertyGrid.dataProvider.getItemAt(event.rowIndex).value;
				updateIsoSceneAssetProperty.dispatch(assetUpdate);
			}
		}
		
		private function handleGridItemEditorSessionStarting(event:GridItemEditorEvent):void{
			
			if( !view.propertyGrid.dataProvider.getItemAt(event.rowIndex).canEdit ){
				event.preventDefault();
			}
		}
		
		private function handlePropertiesViewModeUpdated(viewMode:String, asset:GameAsset):void {
			//trace("handlePropertiesViewModeUpdated: " + viewMode);
			switch(viewMode) {
				case PropertyViewModes.VIEW_MODE_MAP:
					view.title = "Map Properties";
					view.propertyGrid.dataProvider = sceneModel.editProperitiesList;
					break;
				case PropertyViewModes.VIEW_MODE_ASSET:
					view.title = "Asset Properties";
					_asset = asset;
					view.propertyGrid.dataProvider = asset.editProperitiesList;
					break;
				
				default:
					break;
			}
		}
	}
}