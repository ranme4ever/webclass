package com.commands
{
	import com.constants.ApplicationConfigure;
	import com.constants.NotificationType;
	import com.protocol.NetProtocol;
	import com.proxy.ConnectionProxyFactory;
	import com.proxy.IConnectionProxy;
	import com.utils.Logger;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ConnectSignalServerCmd extends SimpleCommand implements IResponder
	{
		public function ConnectSignalServerCmd()
		{
			super();
		}
		
		public static const BEGIN_CONNECT_SIGNAL_SERVER:String = "connectSignalServer";
		private var proxy:IConnectionProxy;
		override public function execute(notification:INotification):void
		{
			super.execute(notification);
			proxy = ConnectionProxyFactory.getConnectionProxy()
			switch(notification.getName()){
				case BEGIN_CONNECT_SIGNAL_SERVER:
					proxy.connectSignal(ApplicationConfigure.SIGNAL_SERVER_PATH,ApplicationConfigure.SIGNAL_SERVER_PORTS,this);
					break;
			}
		}
		
		public function fault(info:Object):void
		{
			Logger.consoleLog(info.message);
			facade.sendNotification(NotificationType.CLASS_STATUS_CHANGE,"初始化鏈接失敗..");
		}
		
		public function result(data:Object):void
		{
			// TODO Auto Generated method stub
			if(data.type == "success")
			{
				Logger.consoleLog("connect on signal server,begin sent  confrim packet.");
				var obj:Object = {};
				obj.cmd = NetProtocol.CMD_CONNECT_SIGNAL_SERVER;
				proxy.sendSignalData(obj);
			}
		}
		
	}
}