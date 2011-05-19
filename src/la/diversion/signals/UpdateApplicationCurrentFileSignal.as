/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 18, 2011
 *
 */

package la.diversion.signals
{
	import org.osflash.signals.Signal;
	
	import flash.filesystem.File;
	
	public class UpdateApplicationCurrentFileSignal extends Signal
	{
		public function UpdateApplicationCurrentFileSignal(...parameters)
		{
			super(File);
		}
	}
}