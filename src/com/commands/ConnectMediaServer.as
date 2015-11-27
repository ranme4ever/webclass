package com.commands
{
	import com.proxy.ConnectionProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ConnectMediaServer extends SimpleCommand
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
			proxy = new ConnectionProxy(this);
			if (!mediaServerCfg)mediaServerCfg = notification.getBody();
			connectAsServer(mediaServerCfg);
		}
		private function connectAsServer(cfg:Object):void {
			var ip:String = cfg.ip;
			var port:int = cfg.port;
			proxy.connectSocket(ip, [port], this);
		}
	}
}