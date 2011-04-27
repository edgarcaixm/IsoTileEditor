/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: Apr 26, 2011
 *
 */

package la.diversion.levelView {
	import flash.events.Event;
	
	public class LevelEvent extends Event {
		
		public static const SET_VIEW_MODE_PLACE_ASSETS:String = 		"setViewModePlaceAssets";
		public static const SET_VIEW_MODE_SET_WALKABLE_TILES:String = 	"serViewModeSetWalkableTiles";
		
		public function LevelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}