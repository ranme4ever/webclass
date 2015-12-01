package com.commands
{
	import com.protocol.NetProtocol;
	import com.proxy.ConnectionProxy;
	import com.utils.Logger;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.patterns.facade.Facade;

	

	public class ConnectAuthServer extends SimpleCommand implements IResponder
	{
		public static const CONNECT_AUTH_SERVER:String = "connectAuthServer";
		public static const RECIEVE_AUTH_SERVER_CONNECT_CONFRIM:String = "recieveAuthServerConnectConfirm";
		private var proxy:ConnectionProxy;
		override public function execute(notification:INotification):void
		{
			super.execute(notification);
			proxy = new ConnectionProxy();
			switch (notification.getName()) {
				case CONNECT_AUTH_SERVER:
					var asConnectCfg:Object;
					if (!asConnectCfg)
						asConnectCfg = notification.getBody();
					var ip:String = asConnectCfg.ServerIP
					var ports:Array = asConnectCfg.ClientPorts;
					proxy.connectServer(ip, ports, this);
					break;
				case RECIEVE_AUTH_SERVER_CONNECT_CONFRIM:
					var data:Object = notification.getBody();
					//stop server connect
					proxy.stopConnectionTimer();
					Facade.getInstance().sendNotification(LoginCommand.LOGIM_COMMAND, data);
					break;
			}
			
		}
		
		public function result(data:Object):void
		{
			Logger.consoleLog("connect on AS server ok, sent a confrim packet.");
			var sendObj:Object = {};
			sendObj.cmd = NetProtocol.CMD_CONNECT_AUTH_SERVER;
			sendObj.ClientType = "";
			proxy.sendData(sendObj);
		}
		
		public function fault(info:Object):void
		{
		}
	}
}