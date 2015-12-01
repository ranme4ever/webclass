package com.commands
{
	import com.constants.ApplicationConfigure;
	import com.protocol.NetProtocol;
	import com.proxy.ConnectionProxy;
	import com.utils.Logger;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ConnectLbsServerCmd extends SimpleCommand implements IResponder
	{
		public function ConnectLbsServerCmd()
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
					proxy.connectServer(ApplicationConfigure.LBS_SERVER_PATH,ApplicationConfigure.LBS_SERVER_PORTS,this);
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
			if(data.type == "socketConnectSuccess")
			{
				Logger.consoleLog("connect on LBS server,begin sent  confrim packet.");
				var obj:Object = {};
				obj.cmd = NetProtocol.CMD_CONNECT_LBS_SERVER;
				obj.FailedServerIP = [];
				proxy.sendData(obj);
			}
		}
		
	}
}