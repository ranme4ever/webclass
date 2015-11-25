package com.proxy
{
	import mx.rpc.IResponder;

	public class ConnectionProxy
	{
		public static const socket:SocketService = new SocketService();
		public function ConnectionProxy(responder:IResponder)
		{
		}
		public function connectLbsServer():void
		{
			SocketService.connectLbsServer();
		}
	}
}