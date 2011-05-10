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
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class UpdateIsoSceneBackgroundPositionCommand extends SignalCommand
	{
		[Inject]
		public var position:Object;
		
		[Inject]
		public var sceneModel:SceneModel;
		
		override public function execute():void{
			sceneModel.background.x = position.x;
			sceneModel.background.y = position.y;
		}
	}
}