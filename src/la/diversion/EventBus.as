/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: Apr 21, 2011
 *
 */

package la.diversion {
	import flash.events.EventDispatcher;

	public class EventBus {
		
		public static var dispatcher:EventDispatcher = new EventDispatcher();
		
		public function EventBus()
		{
			throw new Error("Event Bus should only be accessed via static dispatcher member var");
		}
	}
}