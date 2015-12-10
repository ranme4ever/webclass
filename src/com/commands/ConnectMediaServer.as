package com.commands
{
	import com.constants.NotificationType;
	import com.protocol.NetProtocol;
	import com.proxy.ConnectionProxyFactory;
	import com.proxy.IConnectionProxy;
	import com.utils.Logger;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ConnectMediaServer extends SimpleCommand implements IResponder
	{
		public function ConnectMediaServer()
		{
			super();
		}
		
		public static const CONNECT_MEDIA_SERVER:String = "connectMediaServer";
		private var mediaServerCfg:Object;
		private var proxy:IConnectionProxy;
		override public function execute(notification:INotification):void
		{
			// TODO Auto Generated method stub
			super.execute(notification);
			sendNotification(NotificationType.CLASS_STATUS_CHANGE,"正在链接媒体服务器...");
			proxy = ConnectionProxyFactory.getConnectionProxy()
			if (!mediaServerCfg)
				mediaServerCfg = notification.getBody();
			connectMediaServer(mediaServerCfg);
		}
		private function connectMediaServer(cfg:Object):void {
			var ip:String = cfg.ip;
			var port:int = cfg.port;
			proxy.connectMedia(ip, [port], this);
		}
		
		public function fault(info:Object):void
		{
			// TODO Auto Generated method stub
			sendNotification(NotificationType.CLASS_STATUS_CHANGE,"媒体服务器链接失败");
		}
		
		public function result(data:Object):void
		{
			if(data.type == "success")
			{
				Logger.consoleLog("connect on media server success , sent a confrim packet.");
				var obj:Object = {};
				obj.cmd = NetProtocol.CMD_CONNECT_MEDIA_SERVER;
				proxy.sendSignalData(obj);
			}
		}
		
	}
}