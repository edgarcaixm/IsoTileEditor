/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 3, 2011
 *
 */

package la.diversion.signals {
	import org.osflash.signals.Signal;
	
	import flash.filesystem.File;
	
	public class LoadAssetLibrarySignal extends Signal {
		public function LoadAssetLibrarySignal(...parameters)
		{
			super(File);
		}
	}
}