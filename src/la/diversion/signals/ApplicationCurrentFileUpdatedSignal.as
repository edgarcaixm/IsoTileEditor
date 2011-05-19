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
	
	public class ApplicationCurrentFileUpdatedSignal extends Signal
	{
		public function ApplicationCurrentFileUpdatedSignal(...parameters)
		{
			super(File);
		}
	}
}