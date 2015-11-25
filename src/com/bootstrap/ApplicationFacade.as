package com.bootstrap
{
	
	import org.puremvc.as3.patterns.facade.Facade;
	
	public class ApplicationFacade extends Facade
	{
		
		public static const STARTUP:String = "main_startup";
		
		public function ApplicationFacade()
		{
			super();
		}
		public static function getInstance() : ApplicationFacade {
			if ( instance == null ) instance = new ApplicationFacade( );
			return instance as ApplicationFacade;
		}
		
		override protected function initializeController():void
		{
			controller = ApplicationController.getInstance();
			registerCommand(STARTUP, StartupCommand);
		}
		
		public function startup(app:Main):void
		{
			sendNotification(STARTUP,app);
		}
	}
}