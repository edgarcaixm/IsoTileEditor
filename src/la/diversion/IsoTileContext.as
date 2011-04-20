package la.diversion
{
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.mvcs.Context;
	
	public class IsoTileContext extends Context	{
		public function IsoTileContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true){
			super(contextView, autoStartup);
		}
		
		override public function startup():void {
			//bootstrap here
		}
	}
}