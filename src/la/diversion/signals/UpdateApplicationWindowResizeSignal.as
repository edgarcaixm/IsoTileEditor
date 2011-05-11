/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 10, 2011
 *
 */

package la.diversion.signals
{
	import org.osflash.signals.Signal;
	
	import mx.events.FlexNativeWindowBoundsEvent;
	
	public class UpdateApplicationWindowResizeSignal extends Signal
	{
		public function UpdateApplicationWindowResizeSignal(...parameters)
		{
			super(FlexNativeWindowBoundsEvent);
		}
	}
}