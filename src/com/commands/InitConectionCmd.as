package com.commands
{
	import com.constants.ApplicationConfigure;
	import com.proxy.ConnectionProxy;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class InitConectionCmd extends SimpleCommand implements IResponder
	{
		public function InitConectionCmd()
		{
			super();
		}
		
		public static const BEGIN_CONNECT_LBS_SERVER:String = "connectLbsServer";
		private var proxy:ConnectionProxy;
		override public function execute(notification:INotification):void
		{
			super.execute(notification);
			proxy = new ConnectionProxy()
			switch(notification.getName()){
				case BEGIN_CONNECT_LBS_SERVER:
					proxy.connectLbsServer(ApplicationConfigure.LBS_SERVER_PATH,ApplicationConfigure.LBS_SERVER_PORTS,this);
					break;
			}
		}
		
		public function fault(info:Object):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function result(data:Object):void
		{
			// TODO Auto Generated method stub
			
		}
		
	}
}