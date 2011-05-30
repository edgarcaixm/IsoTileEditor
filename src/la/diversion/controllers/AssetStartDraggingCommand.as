/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: Apr 30, 2011
 *
 */

package la.diversion.controllers {
	import flash.events.MouseEvent;
	
	import la.diversion.models.vo.MapAsset;
	import la.diversion.models.SceneModel;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class AssetStartDraggingCommand extends SignalCommand {
		
		[Inject]
		public var gameAsset:MapAsset;
		
		[Inject]
		public var model:SceneModel;
		
		override public function execute():void{
			model.removeAsset(gameAsset.id);
			model.assetBeingDragged = gameAsset;
		}
	}
}