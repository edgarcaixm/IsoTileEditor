/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 10, 2011
 *
 */

package la.diversion.controllers
{
	import la.diversion.models.SceneModel;
	import la.diversion.models.components.Background;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class ResetIsoSceneBackgroundCommand extends SignalCommand
	{
		
		[Inject]
		public var sceneModel:SceneModel;
		
		override public function execute():void{
			sceneModel.background = null;
		}
	}
}