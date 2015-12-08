package com.bootstrap {
	import com.mediator.ApplicationMediator;
	import com.mediator.LeftViewMediator;
	import com.mediator.MainViewMediator;
	import com.mediator.RightViewMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class StartupCommand extends SimpleCommand {
	    public function StartupCommand() {
	        super();
	    }
	
	    override public function execute(notification:INotification):void {
	        super.execute(notification);
	        ApplicationController.getInstance().initializeCommands();
	        
			var app:Main = notification.getBody() as Main;
			facade.registerMediator(new ApplicationMediator(app));
			
			facade.registerMediator(new MainViewMediator(app.mainView));
			facade.registerMediator(new LeftViewMediator(app.mainView.leftView));
			facade.registerMediator(new RightViewMediator(app.mainView.rightView));
		}
	}
}