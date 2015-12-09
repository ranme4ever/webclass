package
{
	import com.protocol.NetProtocol;
	import com.vo.MsgPacket;
	
	import flash.display.Sprite;
	
	public class Test extends Sprite
	{
		public function Test()
		{
			super();
			testMsgPacket();
		}
		
		private function testMsgPacket():void
		{
			var obj:Object ={
				cmd : NetProtocol.CHAT_MESSAGE,
				message:'123456helllo',
				uid:'137189'
			}
			var packet:MsgPacket = new MsgPacket();
			packet.writeEntry(obj.cmd,obj);
			var result:Object = packet.getEntry();
			for(var key:String in result){
				trace(key+":"+result[key])
			}
		}
	}
}