package com.commands
{
	import com.proxy.ConnectionProxy;
	
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
		private var proxy:ConnectionProxy;
		override public function execute(notification:INotification):void
		{
			// TODO Auto Generated method stub
			super.execute(notification);
			proxy = new ConnectionProxy();
			if (!mediaServerCfg)
				mediaServerCfg = notification.getBody();
			connectAuthServer(mediaServerCfg);
		}
		private function connectAuthServer(cfg:Object):void {
			var ip:String = cfg.ip;
			var port:int = cfg.port;
			proxy.connectServer(ip, [port], this);
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