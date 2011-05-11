/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: Apr 28, 2011
 *
 */

package la.diversion {
	import la.diversion.enums.AssetViewModes;
	import la.diversion.signals.UpdateApplicationWindowResizeSignal;
	import la.diversion.signals.UpdateAssetViewModeSignal;
	
	import mx.events.FlexNativeWindowBoundsEvent;
	import mx.events.ItemClickEvent;
	
	import org.robotlegs.mvcs.Mediator;
	import org.robotlegs.mvcs.SignalMediator;
	
	public class IsoTileEditorMediator extends SignalMediator {
		
		[Inject]
		public var view:IsoTileEditor;
		
		[Inject]
		public var updateAssetViewMode:UpdateAssetViewModeSignal
		
		[Inject]
		public var updateApplicationWindowResize:UpdateApplicationWindowResizeSignal;
		
		override public function onRegister():void{
			//trace("IsoTileEditorMediator onRegister");
			view.init();
			view.tabBar.addEventListener(ItemClickEvent.ITEM_CLICK, handleTabBarItemClick);
			
			addToSignal(view.signalFlexNativeWindowBoundsEventWindowResize, handleSignalFlexNativeWindowBoundsEventWindowResize);
		}
		
		private function handleSignalFlexNativeWindowBoundsEventWindowResize(event:FlexNativeWindowBoundsEvent):void{
			updateApplicationWindowResize.dispatch(event);
			view.assetsPanel.x = event.afterBounds.width - view.assetsPanel.width - 5;
			view.tabBar.x = event.afterBounds.width - view.tabBar.width - 5;
			view.scenePanel.width = event.afterBounds.width - 365;
			view.scenePanel.height = event.afterBounds.height - 60;
		}
		
		private function handleTabBarItemClick(event:ItemClickEvent):void{
			trace(event.label);
			switch(event.label) {
				//case AssetViewModes.VIEW_MODE_ASSETS:
				case "Assets":
					updateAssetViewMode.dispatch(AssetViewModes.VIEW_MODE_ASSETS);
					break;
				//case AssetViewModes.VIEW_MODE_BACKGROUNDS:
				case "Backgrounds":
					updateAssetViewMode.dispatch(AssetViewModes.VIEW_MODE_BACKGROUNDS);
					break;
				
				default:
					break;
			}
		}
	}
}