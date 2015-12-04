package com.commands
{
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class EnterClassCommand extends SimpleCommand
	{
		public static const ENTER_CLASS:String = "enterClass";
		public function EnterClassCommand()
		{
			super();
		}
	}
}