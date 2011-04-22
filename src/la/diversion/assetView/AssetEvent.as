/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: Apr 21, 2011
 *
 */

package la.diversion.assetView {
	import flash.events.Event;
	
	public class AssetEvent extends Event {
		
		public static var DRAG_OBJECT_START:String = 					"dragObjectStart";
		public static var DRAG_OBJECT_END:String = 						"dragObjectEnd";
		
		private var _data:*;
		
		public function AssetEvent(type:String, data:* = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this._data = data;
		}
		
		override public function clone():Event{
			return new AssetEvent(this.type, _data, this.bubbles, this.cancelable);
		}
		
		public function get data():*{
			return _data;
		}
		
		public function set data(dataz:*):void{
			this._data = dataz;
		}
	}
}