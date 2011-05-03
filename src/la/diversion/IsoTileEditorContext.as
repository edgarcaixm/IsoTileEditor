package la.diversion
{
	import flash.display.DisplayObjectContainer;
	
	import la.diversion.models.SceneModel;
	import la.diversion.models.AssetModel;
	import la.diversion.views.*;
	import la.diversion.controllers.*;
	import la.diversion.signals.*;
	
	import org.robotlegs.mvcs.SignalContext;
	
	public class IsoTileEditorContext extends SignalContext	{
		public function IsoTileEditorContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true){
			super(contextView, autoStartup);
		}
		
		override public function startup():void {
			//bootstrap here
			trace("startup");
			
			//signals
			injector.mapSingleton(AssetViewModeUpdatedSignal);
			injector.mapSingleton(AssetRemovedFromSceneSignal);
			injector.mapSingleton(NewLibraryAssetAddedSignal);
			injector.mapSingleton(AssetStartedDraggingSignal);
			injector.mapSingleton(AssetFinishedDraggingSignal);
			injector.mapSingleton(AddAssetToSceneSignal);
			injector.mapSingleton(AssetAddedToSceneSignal);
			injector.mapSingleton(UpdateTileWalkableSignal);
			injector.mapSingleton(TileWalkableUpdatedSignal);
			injector.mapSingleton(UpdateSceneGridSizeSignal);
			injector.mapSingleton(SceneGridSizeUpdatedSignal);
			
			//models
			injector.mapSingleton(SceneModel);
			injector.mapSingleton(AssetModel);
			
			//signal to command mappings
			signalCommandMap.mapSignalClass(UpdateAssetViewModeSignal, UpdateAssetViewModeCommand);
			signalCommandMap.mapSignalClass(AddNewLibraryAssetSignal, AddNewLibraryAssetCommand);
			signalCommandMap.mapSignalClass(AssetStartedDraggingSignal, AssetStartDraggingCommand);
			signalCommandMap.mapSignalClass(AddAssetToSceneSignal, AddNewSceneAssetCommand);
			signalCommandMap.mapSignalClass(UpdateTileWalkableSignal, UpdateTileWalkableCommand);
			signalCommandMap.mapSignalClass(UpdateSceneGridSizeSignal, UpdateSceneGridSizeCommand);
			
			//mediators
			mediatorMap.mapView(IsoSceneView,IsoSceneMediator);
			mediatorMap.mapView(AssetView, AssetMediator);
			mediatorMap.mapView(PropertyView, PropertyMediator);
			mediatorMap.mapView(MainMenuView, MainMenuMediator);
			
			//last, this will call init on the IsoTileEditor
			mediatorMap.mapView(IsoTileEditor,IsoTileEditorMediator);
		}
	}
}