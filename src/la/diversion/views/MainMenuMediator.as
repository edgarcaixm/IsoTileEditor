/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 2, 2011
 *
 */

package la.diversion.views {
	import flash.desktop.NativeApplication;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.NativeWindow;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import la.diversion.enums.EditPathingGridModes;
	import la.diversion.enums.IsoSceneViewModes;
	import la.diversion.models.ApplicationModel;
	import la.diversion.models.SceneModel;
	import la.diversion.models.vo.Background;
	import la.diversion.signals.ApplicationCurrentFileUpdatedSignal;
	import la.diversion.signals.IsoSceneViewModeUpdatedSignal;
	import la.diversion.signals.LoadAssetLibrarySignal;
	import la.diversion.signals.LoadMapSignal;
	import la.diversion.signals.ResetIsoSceneBackgroundSignal;
	import la.diversion.signals.SaveMapSignal;
	import la.diversion.signals.UpdateApplicationCurrentFileSignal;
	import la.diversion.signals.UpdateIsoSceneAutoSetWalkableSignal;
	import la.diversion.signals.UpdateIsoSceneBackgroundSignal;
	import la.diversion.signals.UpdateIsoSceneViewModeSignal;
	
	import org.robotlegs.mvcs.SignalMediator;
	import la.diversion.signals.UpdateIsoSceneGridVisibilitySignal;
	
	public class MainMenuMediator extends SignalMediator {
		
		[Inject]
		public var view:MainMenuView;
		
		[Inject]
		public var sceneModel:SceneModel;
		
		[Inject]
		public var applicationModel:ApplicationModel;
		
		[Inject]
		public var saveMap:SaveMapSignal;
		
		[Inject]
		public var loadMap:LoadMapSignal;
		
		[Inject]
		public var loadAssetLibrary:LoadAssetLibrarySignal;
		
		[Inject]
		public var updateIsoSceneViewMode:UpdateIsoSceneViewModeSignal;

		[Inject]
		public var isoSceneViewModeUpdated:IsoSceneViewModeUpdatedSignal;
		
		[Inject]
		public var resetIsoSceneBackground:ResetIsoSceneBackgroundSignal;
		
		[Inject]
		public var updateIsoSceneAutoSetWalkable:UpdateIsoSceneAutoSetWalkableSignal;
		
		[Inject]
		public var updateApplicationCurrentFile:UpdateApplicationCurrentFileSignal;
		
		[Inject]
		public var applicationCurrentFileUpdated:ApplicationCurrentFileUpdatedSignal;
		
		[Inject]
		public var updateIsoSceneGridVisibility:UpdateIsoSceneGridVisibilitySignal;
		
		override public function onRegister():void{
			addToSignal(view.eventFileNew, handleFileNew);
			addToSignal(view.eventFileSave, handleFileSave);
			addToSignal(view.eventFileSaveAs, handleFileSaveAs);
			addToSignal(view.eventFileOpen, handleFileOpen);
			addToSignal(view.eventLoadAssetLibrary, handleLoadAssetLibrary);
			addToSignal(view.eventUpdateIsoSceneViewMode, handleUpdateIsoSceneViewMode);
			addToSignal(view.eventResetIsoSceneBackground, hangleResetIsoSceneBackground);
			addToSignal(view.eventAutoSetToggleWalkable, handleAutoSetToggleWalkable);
			addToSignal(view.eventToggleGrid, handle_eventToggleGrid);
			
			addOnceToSignal(view.eventAddedToStage, handleAddedToStage);
			
			addToSignal(isoSceneViewModeUpdated, handleIsoSceneViewModeUpdated);
			addToSignal(applicationCurrentFileUpdated, handleApplicationCurrentFileUpdated);
		}
		
		private function handle_eventToggleGrid(showGrid:Boolean):void{
			updateIsoSceneGridVisibility.dispatch(showGrid);
		}
		
		private function handleIsoSceneViewModeUpdated(mode:String):void{
			for each(var command:NativeMenuItem in view.isoViewModeCommands){
				switch(command.label) {
					case "Mode: Asset Placement":
						command.checked = (mode == IsoSceneViewModes.VIEW_MODE_PLACE_ASSETS);
						break;
					case "Mode: Set Walkable Tiles":
						command.checked = (mode == IsoSceneViewModes.VIEW_MODE_SET_WALKABLE_TILES);
						break;
					case "Mode: Move Background":
						command.checked = (mode == IsoSceneViewModes.VIEW_MODE_BACKGROUND);
						break;
					case "Mode: Edit Pathing":
						command.checked = (mode == IsoSceneViewModes.VIEW_MODE_EDIT_PATH);
						break;
					
					default:
						break;
				}
			}
		}
		
		private function handleApplicationCurrentFileUpdated(newFile:File):void{
			view.saveCommand.enabled = true;
		}
		
		private function handleAutoSetToggleWalkable(value:String):void{
			updateIsoSceneAutoSetWalkable.dispatch(value);
		}
		
		private function handleAddedToStage(event:Event):void{
			
		}
		
		private function handleFileNew():void{
			//trace("MainMenuMediator handleFileNew");
		}
		
		private function handleFileSave():void{
			if(applicationModel.currentFile){
				saveMap.dispatch(applicationModel.currentFile);
			}
		}
		
		private function handleFileSaveAs(file:File):void{
			saveMap.dispatch(file);
			updateApplicationCurrentFile.dispatch(file);
		}
		
		private function handleFileOpen(file:File):void{
			loadMap.dispatch(file);
			updateApplicationCurrentFile.dispatch(file);
		}
		
		private function handleLoadAssetLibrary(file:File):void{
			loadAssetLibrary.dispatch(new Array(file));
		}
		
		private function handleUpdateIsoSceneViewMode(mode:String):void {
			updateIsoSceneViewMode.dispatch(mode);
		}
		
		private function hangleResetIsoSceneBackground():void {
			resetIsoSceneBackground.dispatch();
		}
	}
}