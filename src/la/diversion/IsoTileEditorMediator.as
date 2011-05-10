/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: Apr 28, 2011
 *
 */

package la.diversion {
	import la.diversion.signals.UpdateAssetViewModeSignal;
	import la.diversion.enums.AssetViewModes;
	
	import mx.events.ItemClickEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class IsoTileEditorMediator extends Mediator {
		
		[Inject]
		public var view:IsoTileEditor;
		
		[Inject]
		public var updateAssetViewMode:UpdateAssetViewModeSignal
		
		override public function onRegister():void{
			//trace("IsoTileEditorMediator onRegister");
			view.init();
			view.tabBar.addEventListener(ItemClickEvent.ITEM_CLICK, handleTabBarItemClick);
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