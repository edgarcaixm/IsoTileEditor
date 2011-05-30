/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 17, 2011
 *
 */

package la.diversion.controllers
{
	import org.robotlegs.mvcs.SignalCommand;
	
	import la.diversion.models.SceneModel;
	import la.diversion.models.vo.PropertyUpdate;
	
	public class UpdateIsoScenePropertyCommand extends SignalCommand
	{
		[Inject]
		public var update:PropertyUpdate;
		
		[Inject]
		public var model:SceneModel;
		
		override public function execute():void{
			model.updateSceneProperty(update.editProperty, update.value);
		}
	}
}