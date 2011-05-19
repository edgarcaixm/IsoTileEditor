/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 18, 2011
 *
 */

package la.diversion.controllers
{
	import la.diversion.models.SceneModel;
	
	import org.robotlegs.mvcs.Command;
	
	public class UpdateIsoSceneAutoSetWalkableCommand extends Command
	{
		[Inject]
		public var mode:String;
		
		[Inject]
		public var model:SceneModel;
		
		override public function execute():void{
			model.autoSetWalkable = mode;
		}
	}
}