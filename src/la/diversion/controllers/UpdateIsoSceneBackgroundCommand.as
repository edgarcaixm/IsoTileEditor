/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 6, 2011
 *
 */

package la.diversion.controllers
{
	import la.diversion.models.SceneModel;
	import la.diversion.models.components.Background;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class UpdateIsoSceneBackgroundCommand extends SignalCommand
	{
		
		[Inject]
		public var bg:Background;
		
		[Inject]
		public var sceneModel:SceneModel;
		
		override public function execute():void{
			sceneModel.background = bg;
		}
	}
}