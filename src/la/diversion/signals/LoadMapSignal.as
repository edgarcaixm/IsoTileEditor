/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 3, 2011
 *
 */

package la.diversion.signals
{
	import flash.filesystem.File;
	
	import org.osflash.signals.Signal;
	
	public class LoadMapSignal extends Signal
	{
		public function LoadMapSignal(...parameters)
		{
			super(File);
		}
	}
}