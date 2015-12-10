package com.proxy
{
	

	public class SocketFactory
	{
		
		private static var signalSocket:SocketService;
		private static var mediaSocket:SocketService
		public function SocketFactory()
		{
		}
		
		public static function getSignalSocket():SocketService
		{
			if(!signalSocket)
			{
				signalSocket = new SocketService();
			}
			return signalSocket;
		}
		
		public static function getMediaConnection():SocketService{
			if(!mediaSocket){
				mediaSocket = new SocketService();
			}
			return mediaSocket;
		}
	}
}