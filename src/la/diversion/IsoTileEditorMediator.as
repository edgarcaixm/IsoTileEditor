/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: Apr 28, 2011
 *
 */

package la.diversion {
	import org.robotlegs.mvcs.Mediator;
	
	public class IsoTileEditorMediator extends Mediator {
		
		[Inject]
		public var view:IsoTileEditor;
		
		override public function onRegister():void{
			//trace("IsoTileEditorMediator onRegister");
			view.init();
		}
	}
}