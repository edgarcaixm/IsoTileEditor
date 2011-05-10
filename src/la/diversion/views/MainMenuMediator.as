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
	
	import la.diversion.models.SceneModel;
	import la.diversion.models.components.Background;
	import la.diversion.signals.LoadAssetLibrarySignal;
	import la.diversion.signals.LoadMapSignal;
	import la.diversion.signals.ResetIsoSceneBackgroundSignal;
	import la.diversion.signals.SaveMapSignal;
	import la.diversion.signals.UpdateIsoSceneBackgroundSignal;
	import la.diversion.signals.UpdateIsoSceneViewModeSignal;
	
	import org.robotlegs.mvcs.SignalMediator;
	
	public class MainMenuMediator extends SignalMediator {
		
		[Inject]
		public var view:MainMenuView;
		
		[Inject]
		public var sceneModel:SceneModel;
		
		[Inject]
		public var saveMap:SaveMapSignal;
		
		[Inject]
		public var loadMap:LoadMapSignal;
		
		[Inject]
		public var loadAssetLibrary:LoadAssetLibrarySignal;
		
		[Inject]
		public var updateIsoSceneViewMode:UpdateIsoSceneViewModeSignal;
		
		[Inject]
		public var resetIsoSceneBackground:ResetIsoSceneBackgroundSignal;
		
		override public function onRegister():void{
			addToSignal(view.eventFileNew, handleFileNew);
			addToSignal(view.eventFileSave, handleFileSave);
			addToSignal(view.eventFileOpen, handleFileOpen);
			addToSignal(view.eventLoadAssetLibrary, handleLoadAssetLibrary);
			addToSignal(view.eventUpdateIsoSceneViewMode, handleUpdateIsoSceneViewMode);
			addToSignal(view.eventResetIsoSceneBackground, hangleResetIsoSceneBackground);
			
			addOnceToSignal(view.eventAddedToStage, handleAddedToStage);
		}
		
		private function handleAddedToStage(event:Event):void{
			
		}
		
		private function handleFileNew():void{
			//trace("MainMenuMediator handleFileNew");
		}
		
		private function handleFileSave(file:File):void{
			//trace("MainMenuMediator handleFileSave");
			saveMap.dispatch(file);
		}
		
		private function handleFileOpen(file:File):void{
			loadMap.dispatch(file);
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