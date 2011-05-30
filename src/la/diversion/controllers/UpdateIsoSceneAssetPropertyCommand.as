/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 9, 2011
 *
 */

package la.diversion.controllers
{
	import la.diversion.models.SceneModel;
	import la.diversion.models.vo.PropertyUpdate;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class UpdateIsoSceneAssetPropertyCommand extends SignalCommand
	{
		[Inject]
		public var update:PropertyUpdate;
		
		[Inject]
		public var model:SceneModel;
		
		override public function execute():void{
			model.updateSceneAssetProperty(update.id, update.editProperty, update.value);
		}
	}
}