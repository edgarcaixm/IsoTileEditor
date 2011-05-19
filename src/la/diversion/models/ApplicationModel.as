/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 18, 2011
 *
 */

package la.diversion.models
{
	import flash.filesystem.File;
	
	import la.diversion.signals.ApplicationCurrentFileUpdatedSignal;
	
	import org.robotlegs.mvcs.Actor;
	
	public class ApplicationModel extends Actor
	{
		[Inject]
		public var applicationCurrentFileUpdated:ApplicationCurrentFileUpdatedSignal;
		
		private var _currentFile:File;
		
		public function ApplicationModel()
		{
			super();
		}

		public function get currentFile():File {
			return _currentFile;
		}

		public function set currentFile(value:File):void {
			_currentFile = value;
			applicationCurrentFileUpdated.dispatch(value);
		}

	}
}