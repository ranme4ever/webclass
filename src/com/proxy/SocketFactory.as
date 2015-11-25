package com.proxy
{
	

	public class SocketFactory
	{
		
		private static var lbsSocket:SocketService;
		private static var mediaSocket:SocketService
		public function SocketFactory()
		{
		}
		
		public static function getLbsSocket():SocketService
		{
			if(!lbsSocket)
			{
				lbsSocket = new SocketService();
			}
			return lbsSocket;
		}
		
		public static function getMediaConnection():SocketService{
			if(!mediaSocket){
				mediaSocket = new SocketService();
			}
			return mediaSocket;
		}
	}
}