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
			
			var users:Object = {
				cmd:NetProtocol.CLASS_USER_LIST,
				userList:[
					{name:'tom',uid:10001},
					{name:'jim',uid:1002},
					{name:'kim',uid:1003}
				]	
			};
			var usersPacket:MsgPacket = new MsgPacket();
			usersPacket.writeEntry(users.cmd,users);
			var user_rl:Object = usersPacket.getEntry();
			for(var key1:String in user_rl){
				trace(key1+":"+user_rl[key1])
			}
		}
	}
}