package com.bootstrap
{
	import org.puremvc.as3.core.Controller;

	public class ApplicationController extends Controller
	{
		public function ApplicationController()
		{
			super();
		}
		public static function getInstance() : ApplicationController {
			if ( instance == null ) instance = new ApplicationController( );
			return instance as ApplicationController;
		}
		
		public function initializeCommands():void{
	
		}
		
	}
}