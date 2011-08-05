/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: Aug 5, 2011
 *
 */

package la.diversion.signals
{
	import org.osflash.signals.Signal;
	
	public class UpdateIsoSceneGridVisibility extends Signal
	{
		public function UpdateIsoSceneGridVisibility(...parameters)
		{
			super(Boolean);
		}
	}
}