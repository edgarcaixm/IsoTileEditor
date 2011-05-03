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
	
	import org.robotlegs.mvcs.SignalMediator;
	
	public class MainMenuMediator extends SignalMediator {
		
		[Inject]
		public var view:MainMenuView;
		
		[Inject]
		public var sceneModel:SceneModel;
		
		override public function onRegister():void{
			addToSignal(view.eventFileNew, handleFileNew);
			addToSignal(view.eventFileSave, handleFileSave);
			
			addOnceToSignal(view.eventAddedToStage, handleAddedToStage);
		}
		
		private function handleAddedToStage(event:Event):void{
			
		}
		
		private function handleFileNew():void{
			trace("MainMenuMediator handleFileNew");
		}
		
		private function handleFileSave(file:File):void{
			trace("MainMenuMediator handleFileSave");
			
			//TODO - Move me to a service!
			//trace(sceneModel.toJSON());
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeUTFBytes(sceneModel.toJSON());
			fileStream.close();
		}
		
	}
}