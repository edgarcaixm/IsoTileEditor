package la.diversion
{
	import flash.display.DisplayObjectContainer;
	
	import la.diversion.controllers.*;
	import la.diversion.models.*
	import la.diversion.services.*;
	import la.diversion.signals.*;
	import la.diversion.views.*;
	
	import org.robotlegs.mvcs.SignalContext;
	
	public class IsoTileEditorContext extends SignalContext	{
		public function IsoTileEditorContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true){
			super(contextView, autoStartup);
		}
		
		override public function startup():void {
			//bootstrap here
			trace("startup");
			
			//signals
			injector.mapSingleton(IsoSceneViewModeUpdatedSignal);
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
			injector.mapSingleton(LoadAssetLibrarySignal);
			injector.mapSingleton(LoadAssetLibraryCompleteSignal);
			injector.mapSingleton(SaveMapSignal);
			injector.mapSingleton(LoadMapSignal);
			injector.mapSingleton(UpdateAssetViewModeSignal);
			injector.mapSingleton(AssetViewModeUpdatedSignal);
			injector.mapSingleton(AddNewLibraryBackgroundSignal);
			injector.mapSingleton(NewLibraryBackgroundAddedSignal);
			injector.mapSingleton(UpdateIsoSceneBackgroundSignal);
			injector.mapSingleton(IsoSceneBackgroundUpdatedSignal);
			injector.mapSingleton(UpdatePropertiesViewModeSignal);
			injector.mapSingleton(PropertiesViewModeUpdatedSignal);
			injector.mapSingleton(UpdateIsoSceneAssetPropertySignal);
			injector.mapSingleton(UpdateIsoSceneBackgroundPositionSignal);
			injector.mapSingleton(ResetIsoSceneBackgroundSignal);
			injector.mapSingleton(IsoSceneBackgroundResetSignal);
			injector.mapSingleton(UpdateApplicationWindowResizeSignal);
			injector.mapSingleton(UpdateIsoScenePropertySignal);
			injector.mapSingleton(IsoSceneStageColorUpdatedSignal);
			injector.mapSingleton(UpdateLibraryAssetPropertySignal);
			injector.mapSingleton(UpdateIsoSceneAutoSetWalkableSignal);
			injector.mapSingleton(UpdateApplicationCurrentFileSignal);
			injector.mapSingleton(ApplicationCurrentFileUpdatedSignal);
			injector.mapSingleton(AddMapAssetPathingPointSignal);
			injector.mapSingleton(RemoveMapAssetPathingPointSignal);
			injector.mapSingleton(MapAssetPathingPointsUpdatedSignal);
			injector.mapSingleton(PlayerAvatarSpawnPositionUpdatedSignal);
			
			//models
			injector.mapSingleton(SceneModel);
			injector.mapSingleton(AssetModel);
			injector.mapSingleton(ApplicationModel);
			
			//services
			injector.mapSingletonOf(ILoadAssetLibrary, LoadAssetLibraryService);
			injector.mapSingletonOf(ISaveMap, SaveMapService);
			injector.mapSingletonOf(ILoadMap, LoadMapService);
			
			//signal to command mappings
			signalCommandMap.mapSignalClass(UpdateIsoSceneViewModeSignal, UpdateIsoSceneViewModeCommand);
			signalCommandMap.mapSignalClass(AddNewLibraryAssetSignal, AddNewLibraryAssetCommand);
			signalCommandMap.mapSignalClass(AssetStartedDraggingSignal, AssetStartDraggingCommand);
			signalCommandMap.mapSignalClass(AddAssetToSceneSignal, AddNewSceneAssetCommand);
			signalCommandMap.mapSignalClass(UpdateTileWalkableSignal, UpdateTileWalkableCommand);
			signalCommandMap.mapSignalClass(UpdateSceneGridSizeSignal, UpdateSceneGridSizeCommand);
			signalCommandMap.mapSignalClass(LoadAssetLibrarySignal, LoadAssetLibraryCommand);
			signalCommandMap.mapSignalClass(SaveMapSignal, SaveMapCommand);
			signalCommandMap.mapSignalClass(LoadMapSignal, LoadMapCommand);
			signalCommandMap.mapSignalClass(UpdateAssetViewModeSignal, UpdateAssetViewModeCommand);
			signalCommandMap.mapSignalClass(AddNewLibraryBackgroundSignal, AddNewLibraryBackgroundCommand);
			signalCommandMap.mapSignalClass(UpdateIsoSceneBackgroundSignal, UpdateIsoSceneBackgroundCommand);
			signalCommandMap.mapSignalClass(UpdatePropertiesViewModeSignal, UpdatePropertiesViewModeCommand);
			signalCommandMap.mapSignalClass(UpdateIsoSceneAssetPropertySignal, UpdateIsoSceneAssetPropertyCommand);
			signalCommandMap.mapSignalClass(UpdateIsoSceneBackgroundPositionSignal, UpdateIsoSceneBackgroundPositionCommand);
			signalCommandMap.mapSignalClass(ResetIsoSceneBackgroundSignal, ResetIsoSceneBackgroundCommand);
			signalCommandMap.mapSignalClass(UpdateIsoScenePropertySignal, UpdateIsoScenePropertyCommand);
			signalCommandMap.mapSignalClass(UpdateLibraryAssetPropertySignal, UpdateLibraryAssetPropertyCommand);
			signalCommandMap.mapSignalClass(UpdateIsoSceneAutoSetWalkableSignal, UpdateIsoSceneAutoSetWalkableCommand);
			signalCommandMap.mapSignalClass(UpdateApplicationCurrentFileSignal, UpdateApplicaitonCurrentFileCommand);
			signalCommandMap.mapSignalClass(AddMapAssetPathingPointSignal, AddMapAssetPathingPointCommand);
			signalCommandMap.mapSignalClass(RemoveMapAssetPathingPointSignal, RemoveMapAssetPathingPointCommand);
			
			//mediators
			mediatorMap.mapView(IsoSceneView,IsoSceneMediator);
			mediatorMap.mapView(AssetView, AssetMediator);
			mediatorMap.mapView(MainMenuView, MainMenuMediator);
			mediatorMap.mapView(PropertiesView, PropertiesMediator);
			
			//last, this will call init on the IsoTileEditor
			mediatorMap.mapView(IsoTileEditor,IsoTileEditorMediator);
		}
	}
}