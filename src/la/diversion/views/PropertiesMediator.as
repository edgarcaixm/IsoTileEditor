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
	import la.diversion.signals.PropertiesViewModeUpdatedSignal;
	import la.diversion.signals.UpdateIsoSceneAssetPropertySignal;
	import la.diversion.signals.UpdateSceneGridSizeSignal;
	
	import mx.collections.ArrayCollection;
	
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
		public var updateIsoSceneAssetProperty:UpdateIsoSceneAssetPropertySignal;
		
		private var _dataProvider:ArrayCollection
		private var _asset:GameAsset;
		
		override public function onRegister():void{
			//trace("PropertiesMediator");
			
			_dataProvider = new ArrayCollection([
				{property:"Cols", value:40, canEdit:true},
				{property:"Rows", value:40, canEdit:true}     
			]); 
			
			view.propertyGrid.dataProvider = _dataProvider;
			
			addToSignal(view.gridItemEditorSessionSave, handleGridItemEditorSessionSave);
			addToSignal(view.gridItemEditorSessionStarting, handleGridItemEditorSessionStarting);
			addToSignal(propertiesViewModeUpdated, handlePropertiesViewModeUpdated);
			
			var gridSize:Object = new Object();
			gridSize.cols = SceneModel.DEFAULT_COLS;
			gridSize.rows = SceneModel.DEFAULT_ROWS;
			updateSceneGridSize.dispatch(gridSize);
		}
		
		private function handleGridItemEditorSessionSave(event:GridItemEditorEvent):void {
			if(sceneModel.viewModeProperties == PropertyViewModes.VIEW_MODE_MAP){
				var gridSize:Object = new Object();
				gridSize.cols = int(view.propertyGrid.dataProvider.getItemAt(0).value);
				gridSize.rows = int(view.propertyGrid.dataProvider.getItemAt(1).value);
				updateSceneGridSize.dispatch(gridSize);
			}else if (sceneModel.viewModeProperties == PropertyViewModes.VIEW_MODE_ASSET){
				var update:Object = new Object();
				update.assetID = _asset.id;
				update.assetProperty = view.propertyGrid.dataProvider.getItemAt(event.rowIndex).editProperty;
				update.assetValue = view.propertyGrid.dataProvider.getItemAt(event.rowIndex).value;
				updateIsoSceneAssetProperty.dispatch(update);
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
					view.propertyGrid.dataProvider = _dataProvider;
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