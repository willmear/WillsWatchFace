using Toybox.WatchUi as Ui;

class Background extends Ui.Drawable {
	hidden var borderColour;	
	
    function initialize(params) {
        Drawable.initialize(params);

        borderColour = params.get(:borderColour);

    }

    function draw(dc) {



    	var halfOfHeight = dc.getHeight() / 2;
		var deviceWidth = dc.getWidth();					
            
        dc.setColor(borderColour, borderColour);
		dc.fillRectangle(deviceWidth / 2, halfOfHeight / 1.7, 2, halfOfHeight / 1.04);
		

    }
}